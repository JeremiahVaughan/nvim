package main

import (
	"crypto/rand"
	"encoding/base64"
	"fmt"
	"io"
	"math/big"
	"os"
	"strconv"
	"strings"
	"unicode/utf8"
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
