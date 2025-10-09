package main

import (
	"bytes"
	"encoding/base64"
	"errors"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"testing"
)

func TestToggleBase64Decode(t *testing.T) {
	got := toggleBase64("SGVsbG8=\n")
	if got != "Hello" {
		t.Fatalf("expected decoded value 'Hello', got %q", got)
	}
}

func TestToggleBase64Encode(t *testing.T) {
	got := toggleBase64("Hello")
	if got != "SGVsbG8=" {
		t.Fatalf("expected encoded value 'SGVsbG8=', got %q", got)
	}
}

func TestTryDecodeRawEncoding(t *testing.T) {
	raw := base64.RawStdEncoding.EncodeToString([]byte("Hello"))
	got, ok := tryDecode(raw)
	if !ok {
		t.Fatalf("expected raw base64 to decode successfully")
	}
	if got != "Hello" {
		t.Fatalf("expected 'Hello', got %q", got)
	}
}

func TestTryDecodeRejectsInvalidUTF8(t *testing.T) {
	s := base64.StdEncoding.EncodeToString([]byte{0xff, 0xfe})
	if _, ok := tryDecode(s); ok {
		t.Fatalf("expected invalid UTF-8 payload to be rejected")
	}
}

func TestTrimTrailingNewlines(t *testing.T) {
	tests := map[string]string{
		"no-newline":        "text",
		"single-newline":    "text\n",
		"carriage-newline":  "text\r\n",
		"multiple-newlines": "text\n\n",
		"mixed-newlines":    "text\n\r\n",
	}

	for name, input := range tests {
		t.Run(name, func(t *testing.T) {
			got := trimTrailingNewlines(input)
			if got != "text" {
				t.Fatalf("expected 'text', got %q", got)
			}
		})
	}
}

func TestToggleBase64EmptyInput(t *testing.T) {
	if got := toggleBase64("\n\n"); got != "" {
		t.Fatalf("expected empty string, got %q", got)
	}
}

func TestRandomStringLength(t *testing.T) {
	const length = 16
	got, err := randomString(length)
	if err != nil {
		t.Fatalf("randomString returned error: %v", err)
	}
	if len(got) != length {
		t.Fatalf("expected length %d, got %d", length, len(got))
	}
	for _, r := range got {
		if !strings.ContainsRune(randomAlphabet, r) {
			t.Fatalf("unexpected rune %q in random string", r)
		}
	}
}

func TestRandomStringInvalidLength(t *testing.T) {
	if _, err := randomString(0); err == nil {
		t.Fatalf("expected error for non-positive length")
	}
}

func TestRunUnknownCommand(t *testing.T) {
	if err := run([]string{"nope"}); err == nil {
		t.Fatalf("expected error for unknown command")
	}
}

func TestEnsureGoDirectiveUpdatesVersion(t *testing.T) {
	tempDir := t.TempDir()
	modPath := filepath.Join(tempDir, "go.mod")
	initial := "module example.com/test\n\n\tgo 1.24.6\n"
	if err := os.WriteFile(modPath, []byte(initial), 0o644); err != nil {
		t.Fatalf("failed to prepare go.mod: %v", err)
	}

	changed, err := ensureGoDirective(modPath, "1.24.7")
	if err != nil {
		t.Fatalf("ensureGoDirective returned error: %v", err)
	}
	if !changed {
		t.Fatalf("expected version update to be reported")
	}

	data, err := os.ReadFile(modPath)
	if err != nil {
		t.Fatalf("failed to read go.mod: %v", err)
	}
	contents := string(data)
	if !strings.Contains(contents, "go 1.24.7\n") {
		t.Fatalf("go.mod missing updated version: %q", contents)
	}

	changed, err = ensureGoDirective(modPath, "1.24.7")
	if err != nil {
		t.Fatalf("second ensureGoDirective returned error: %v", err)
	}
	if changed {
		t.Fatalf("expected no changes when version already matches")
	}
}

func TestEnsureGoDirectiveInsertsMissingVersion(t *testing.T) {
	tempDir := t.TempDir()
	modPath := filepath.Join(tempDir, "go.mod")
	initial := "module example.com/test\n\nrequire example.com/dep v1.2.3\n"
	if err := os.WriteFile(modPath, []byte(initial), 0o644); err != nil {
		t.Fatalf("failed to prepare go.mod: %v", err)
	}

	changed, err := ensureGoDirective(modPath, "1.24.7")
	if err != nil {
		t.Fatalf("ensureGoDirective returned error: %v", err)
	}
	if !changed {
		t.Fatalf("expected insertion to be reported")
	}

	data, err := os.ReadFile(modPath)
	if err != nil {
		t.Fatalf("failed to read go.mod: %v", err)
	}

	lines := strings.Split(strings.TrimSpace(string(data)), "\n")
	if len(lines) < 3 {
		t.Fatalf("unexpected go.mod layout: %v", lines)
	}
	if lines[1] != "" {
		t.Fatalf("expected blank line between module and go directive, got %q", lines[1])
	}
	if lines[2] != "go 1.24.7" {
		t.Fatalf("expected inserted go directive, got %q", lines[2])
	}
}

func TestGoUpdateProcessesModules(t *testing.T) {
	tempDir := t.TempDir()
	modPaths := []string{
		filepath.Join(tempDir, "a", "go.mod"),
		filepath.Join(tempDir, "b", "c", "go.mod"),
	}
	dockerPaths := []string{
		filepath.Join(tempDir, "a", "Dockerfile"),
		filepath.Join(tempDir, "b", "Dockerfile.dev"),
	}
	for _, path := range modPaths {
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatalf("failed to create directory: %v", err)
		}
		contents := "module example.com/test\n\nrequire example.com/dep v1.0.0\n"
		if err := os.WriteFile(path, []byte(contents), 0o644); err != nil {
			t.Fatalf("failed to write %s: %v", path, err)
		}
	}
	for _, path := range dockerPaths {
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatalf("failed to create directory: %v", err)
		}
		contents := "FROM golang:1.22.1\nRUN echo hello\n"
		if err := os.WriteFile(path, []byte(contents), 0o644); err != nil {
			t.Fatalf("failed to write %s: %v", path, err)
		}
	}

	origRunner := commandRunner
	var calls []struct {
		dir  string
		name string
		args []string
	}
	commandRunner = func(dir, name string, args ...string) ([]byte, error) {
		calls = append(calls, struct {
			dir  string
			name string
			args []string
		}{dir: dir, name: name, args: append([]string(nil), args...)})
		return []byte{}, nil
	}
	defer func() { commandRunner = origRunner }()

	var output bytes.Buffer
	origOutput := goUpdateOutput
	goUpdateOutput = &output
	defer func() { goUpdateOutput = origOutput }()

	if err := goUpdate([]string{"--root", tempDir, "--version", "1.24.7"}); err != nil {
		t.Fatalf("goUpdate returned error: %v", err)
	}

	if len(calls) != len(modPaths) {
		t.Fatalf("expected %d go get invocations, saw %d", len(modPaths), len(calls))
	}
	for _, call := range calls {
		if call.name != "go" {
			t.Fatalf("expected command 'go', got %q", call.name)
		}
		if !equalStrings(call.args, []string{"get", "-u", "./..."}) {
			t.Fatalf("unexpected args: %v", call.args)
		}
	}

	var expectedPaths []string
	for _, path := range append([]string(nil), modPaths...) {
		absPath, err := filepath.Abs(path)
		if err != nil {
			t.Fatalf("failed to resolve absolute path: %v", err)
		}
		expectedPaths = append(expectedPaths, absPath)
	}
	for _, path := range append([]string(nil), dockerPaths...) {
		absPath, err := filepath.Abs(path)
		if err != nil {
			t.Fatalf("failed to resolve absolute path: %v", err)
		}
		expectedPaths = append(expectedPaths, absPath)
	}
	sort.Strings(expectedPaths)

	raw := strings.TrimSpace(output.String())
	lines := []string{}
	if raw != "" {
		lines = strings.Split(raw, "\n")
		sort.Strings(lines)
	}
	if !equalStrings(lines, expectedPaths) {
		t.Fatalf("unexpected output lines: %v", lines)
	}

	for _, path := range modPaths {
		data, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("failed to read %s: %v", path, err)
		}
		if !strings.Contains(string(data), "go 1.24.7\n") {
			t.Fatalf("go version not updated in %s", path)
		}
	}
	for _, path := range dockerPaths {
		data, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("failed to read %s: %v", path, err)
		}
		if !strings.Contains(string(data), "FROM golang:1.24.7") {
			t.Fatalf("golang image not updated in %s", path)
		}
	}
}

func TestGoUpdateAggregatesErrors(t *testing.T) {
	tempDir := t.TempDir()
	modPaths := []string{
		filepath.Join(tempDir, "a", "go.mod"),
		filepath.Join(tempDir, "b", "go.mod"),
	}
	for _, path := range modPaths {
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatalf("failed to create directory: %v", err)
		}
		contents := "module example.com/test\n"
		if err := os.WriteFile(path, []byte(contents), 0o644); err != nil {
			t.Fatalf("failed to write %s: %v", path, err)
		}
	}

	failingDir := filepath.Dir(modPaths[1])
	origRunner := commandRunner
	commandRunner = func(dir, name string, args ...string) ([]byte, error) {
		if dir == failingDir {
			return []byte("network failure"), errors.New("go get failed")
		}
		return []byte{}, nil
	}
	defer func() { commandRunner = origRunner }()

	var output bytes.Buffer
	origOutput := goUpdateOutput
	goUpdateOutput = &output
	defer func() { goUpdateOutput = origOutput }()

	err := goUpdate([]string{"--root", tempDir, "--version", "1.24.7"})
	if err == nil {
		t.Fatalf("expected goUpdate to report failure")
	}
	if !strings.Contains(err.Error(), "completed with errors") {
		t.Fatalf("expected aggregated error message, got %q", err)
	}
	if !strings.Contains(err.Error(), failingDir) {
		t.Fatalf("expected error to mention failing module, got %q", err)
	}

	trimmed := strings.TrimSpace(output.String())
	if trimmed == "" {
		t.Fatalf("expected successful module path in output, got empty string")
	}
	lines := strings.Split(trimmed, "\n")
	if len(lines) != 1 {
		t.Fatalf("expected only successful module path in output, got %v", lines)
	}
	successPath, err := filepath.Abs(modPaths[0])
	if err != nil {
		t.Fatalf("failed to resolve absolute path: %v", err)
	}
	if lines[0] != successPath {
		t.Fatalf("unexpected success path %q", lines[0])
	}
}

func equalStrings(a, b []string) bool {
	if len(a) != len(b) {
		return false
	}
	for i := range a {
		if a[i] != b[i] {
			return false
		}
	}
	return true
}
