package main

import (
	"encoding/base64"
	"fmt"
	"io"
	"os"
	"strings"
	"unicode/utf8"
)

func main() {
	input, err := readInput()
	if err != nil {
		fmt.Fprintf(os.Stderr, "b64flip: failed to read input: %v\n", err)
		os.Exit(1)
	}

	result := toggleBase64(input)
	fmt.Println(result)
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
