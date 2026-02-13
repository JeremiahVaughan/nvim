package payload

import (
	"bytes"
	"compress/gzip"
	"encoding/json"
	"fmt"
)

func EncodeZippedJSON(v any) ([]byte, error) {
	var buf bytes.Buffer

	gz := gzip.NewWriter(&buf)

	if err := json.NewEncoder(gz).Encode(v); err != nil {
		_ = gz.Close()
		return nil, fmt.Errorf("error, encode zipped json: json encode failed: %w", err)
	}

	if err := gz.Close(); err != nil {
		return nil, fmt.Errorf("error, encode zipped json: gzip close failed: %w", err)
	}

	return buf.Bytes(), nil
}

func DecodeZippedJSON(data []byte, v any) error {
	gz, err := gzip.NewReader(bytes.NewReader(data))
	if err != nil {
		return fmt.Errorf("error, decode zipped json: invalid gzip data: %w", err)
	}
	defer gz.Close()

	if err := json.NewDecoder(gz).Decode(v); err != nil {
		return fmt.Errorf("error, decode zipped json: json decode failed: %w", err)
	}

	return nil
}
