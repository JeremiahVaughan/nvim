package main

import (
	"crypto/rand"
	"encoding/base64"
	"errors"
	"flag"
	"fmt"
	"io"
	"io/fs"
	"math/big"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"unicode/utf8"
)

var (
	commandRunner            = defaultCommandRunner
	goUpdateOutput io.Writer = os.Stdout
	dockerfileVersionRegexp  = regexp.MustCompile(`golang:\d+(?:\.\d+){1,2}-alpine\d+(\.)\d+`)
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "nvim-helper: %v\n", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	if len(args) > 0 {
		switch args[0] {
		case "random-string":
			length := 5
			if len(args) > 1 {
				value, err := strconv.Atoi(args[1])
				if err != nil || value <= 0 {
					return fmt.Errorf("random-string requires a positive integer length")
				}
				length = value
			}

			result, err := randomString(length)
			if err != nil {
				return fmt.Errorf("failed to generate random string: %w", err)
			}

			fmt.Println(result)
			return nil
		case "go-update":
			return goUpdate(args[1:])
		default:
			return fmt.Errorf("unknown subcommand %q", args[0])
		}
	}

	input, err := readInput()
	if err != nil {
		return fmt.Errorf("failed to read input: %w", err)
	}

	result := toggleBase64(input)
	fmt.Println(result)
	return nil
}

func readInput() (string, error) {
	data, err := io.ReadAll(os.Stdin)
	if err != nil {
		return "", err
	}
	return string(data), nil
}

func trimTrailingNewlines(s string) string {
	return strings.TrimRight(s, "\r\n")
}

func tryDecode(s string) (string, bool) {
	if result, ok := decodeWith(base64.StdEncoding, s); ok {
		return result, true
	}

	if result, ok := decodeWith(base64.RawStdEncoding, s); ok {
		return result, true
	}

	return "", false
}

func decodeWith(enc *base64.Encoding, s string) (string, bool) {
	decoded, err := enc.DecodeString(s)
	if err != nil {
		return "", false
	}

	if !utf8.Valid(decoded) {
		return "", false
	}

	return string(decoded), true
}

func toggleBase64(input string) string {
	trimmed := trimTrailingNewlines(input)

	if trimmed == "" {
		return ""
	}

	if decoded, ok := tryDecode(trimmed); ok {
		return decoded
	}

	return base64.StdEncoding.EncodeToString([]byte(trimmed))
}

const randomAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

func randomString(length int) (string, error) {
	if length <= 0 {
		return "", fmt.Errorf("length must be positive")
	}

	letters := []rune(randomAlphabet)
	result := make([]rune, length)
	max := big.NewInt(int64(len(letters)))

	for i := range result {
		n, err := rand.Int(rand.Reader, max)
		if err != nil {
			return "", err
		}
		result[i] = letters[n.Int64()]
	}

	return string(result), nil
}

func goUpdate(args []string) error {
	flagSet := flag.NewFlagSet("go-update", flag.ContinueOnError)
	flagSet.SetOutput(io.Discard)
	root := flagSet.String("root", ".", "root directory to search for go.mod files")
	version := flagSet.String("version", "", "Go version to enforce (for example, 1.24.7)")
	alpineVersion := flagSet.String("alpine-version", "", "Go alpine-version to enforce (for example, 3.22)")
	if err := flagSet.Parse(args); err != nil {
		return err
	}
	if *version == "" {
		return fmt.Errorf("go-update requires --version=<version>")
	}
	if *alpineVersion == "" {
		return fmt.Errorf("go-update requires --alpine-version=<alpineVersion>")
	}
	if flagSet.NArg() > 0 {
		return fmt.Errorf("unexpected argument %q", flagSet.Arg(0))
	}

	rootAbs, err := filepath.Abs(*root)
	if err != nil {
		return fmt.Errorf("failed to resolve root %q: %w", *root, err)
	}

	var goMods []string
	var dockerfiles []string
	err = filepath.WalkDir(rootAbs, func(path string, d fs.DirEntry, walkErr error) error {
		if walkErr != nil {
			return walkErr
		}
		if d.IsDir() {
			return nil
		}
		if d.Name() == "go.mod" {
			goMods = append(goMods, path)
			return nil
		}
		if strings.Contains(d.Name(), "Dockerfile") {
			dockerfiles = append(dockerfiles, path)
		}
		return nil
	})
	if err != nil {
		return fmt.Errorf("failed to walk %s: %w", rootAbs, err)
	}

	if len(goMods) == 0 {
		return fmt.Errorf("no go.mod files found under %s", rootAbs)
	}

	sort.Strings(goMods)
	sort.Strings(dockerfiles)

	var errs []error
	for _, modPath := range goMods {
		if err := processModule(modPath, *version); err != nil {
			errs = append(errs, err)
			continue
		}
		if _, err := fmt.Fprintln(goUpdateOutput, modPath); err != nil {
			return fmt.Errorf("failed to report result: %w", err)
		}
	}

	for _, dockerPath := range dockerfiles {
		updated, err := ensureDockerfileGoVersion(dockerPath, *version, *alpineVersion)
		if err != nil {
			errs = append(errs, fmt.Errorf("processing %s: %w", dockerPath, err))
			continue
		}
		if !updated {
			continue
		}
		if _, err := fmt.Fprintln(goUpdateOutput, dockerPath); err != nil {
			return fmt.Errorf("failed to report result: %w", err)
		}
	}

	if len(errs) > 0 {
		joined := errorsJoin(errs)
		if len(goMods) == len(errs) {
			return joined
		}
		return fmt.Errorf("completed with errors: %w", joined)
	}

	return nil
}

func processModule(modPath, version string) error {
	if _, err := ensureGoDirective(modPath, version); err != nil {
		return fmt.Errorf("processing %s: %w", modPath, err)
	}
	dir := filepath.Dir(modPath)
	if err := runGoGet(dir); err != nil {
		return fmt.Errorf("processing %s: %w", modPath, err)
	}
	return nil
}

func runGoGet(dir string) error {
	output, err := commandRunner(dir, "go", "get", "-u", "./...")
	if err != nil {
		message := strings.TrimSpace(string(output))
		if message != "" {
			return fmt.Errorf("go get -u ./... failed in %s: %s: %w", dir, message, err)
		}
		return fmt.Errorf("go get -u ./... failed in %s: %w", dir, err)
	}
	return nil
}

func ensureGoDirective(path, version string) (bool, error) {
	info, err := os.Stat(path)
	if err != nil {
		return false, fmt.Errorf("stat %s: %w", path, err)
	}

	data, err := os.ReadFile(path)
	if err != nil {
		return false, fmt.Errorf("read %s: %w", path, err)
	}

	content := strings.ReplaceAll(string(data), "\r\n", "\n")
	hadTrailingNewline := strings.HasSuffix(content, "\n")
	if hadTrailingNewline {
		content = strings.TrimSuffix(content, "\n")
	}

	var lines []string
	if content != "" {
		lines = strings.Split(content, "\n")
	}

	goLine := "go " + version
	for i, line := range lines {
		trimmed := strings.TrimSpace(line)
		if strings.HasPrefix(trimmed, "go ") {
			if trimmed == goLine {
				return false, nil
			}
			leading := line[:len(line)-len(strings.TrimLeft(line, " \t"))]
			lines[i] = leading + goLine
			updated := strings.Join(lines, "\n")
			if hadTrailingNewline || updated != "" {
				updated += "\n"
			}
			if err := os.WriteFile(path, []byte(updated), info.Mode()); err != nil {
				return false, fmt.Errorf("write %s: %w", path, err)
			}
			return true, nil
		}
	}

	moduleIdx := -1
	insertIdx := len(lines)
	for i, line := range lines {
		if strings.HasPrefix(strings.TrimSpace(line), "module ") {
			moduleIdx = i
			insertIdx = i + 1
			for insertIdx < len(lines) && strings.TrimSpace(lines[insertIdx]) == "" {
				insertIdx++
			}
			break
		}
	}

	var newLines []string
	newLines = append(newLines, lines[:insertIdx]...)
	if moduleIdx != -1 && insertIdx == moduleIdx+1 {
		newLines = append(newLines, "")
	}
	newLines = append(newLines, goLine)
	newLines = append(newLines, lines[insertIdx:]...)

	updated := strings.Join(newLines, "\n")
	if updated != "" || hadTrailingNewline {
		updated += "\n"
	}
	if err := os.WriteFile(path, []byte(updated), info.Mode()); err != nil {
		return false, fmt.Errorf("write %s: %w", path, err)
	}
	return true, nil
}

func ensureDockerfileGoVersion(path, version, alpineVersion string) (bool, error) {
	info, err := os.Stat(path)
	if err != nil {
		return false, fmt.Errorf("stat %s: %w", path, err)
	}

	data, err := os.ReadFile(path)
	if err != nil {
		return false, fmt.Errorf("read %s: %w", path, err)
	}

	content := string(data)
	changed := false
	replacement := "golang:" + version + "-alpine" + alpineVersion
	updated := dockerfileVersionRegexp.ReplaceAllStringFunc(content, func(match string) string {
		if match == replacement {
			return match
		}
		changed = true
		return replacement
	})

	if !changed {
		return false, nil
	}

	if err := os.WriteFile(path, []byte(updated), info.Mode()); err != nil {
		return false, fmt.Errorf("write %s: %w", path, err)
	}
	return true, nil
}

func defaultCommandRunner(dir, name string, args ...string) ([]byte, error) {
	cmd := exec.Command(name, args...)
	cmd.Dir = dir
	cmd.Env = os.Environ()
	return cmd.CombinedOutput()
}

func errorsJoin(errs []error) error {
	switch len(errs) {
	case 0:
		return nil
	case 1:
		return errs[0]
	default:
		return errors.Join(errs...)
	}
}
