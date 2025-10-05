package main

import (
	"encoding/base64"
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
