package template_golang

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)


// http.MethodPost
// http.MethodGet
// http.MethodPut
// http.MethodDelete
func HttpRequest(method, theURL string, reqBody any, dst any) error {
	var body io.Reader
	if reqBody != nil {
		buf := new(bytes.Buffer)
		if err := json.NewEncoder(buf).Encode(reqBody); err != nil {
			return fmt.Errorf("error, %s %q: encoding request body: %w", method, theURL, err)
		}
		body = buf
	}

	request, err := http.NewRequest(method, theURL, body)
	if err != nil {
		return fmt.Errorf("error, when generating get request: %w", err)
	}
	request.Header.Set("Content-Type", "application/json")

	resp, err := http.DefaultClient.Do(request)
	if err != nil {
		return fmt.Errorf("error, request if http method %s failed: %w", method, err)
	}
	defer resp.Body.Close()

	if resp.StatusCode < 200 || resp.StatusCode > 299 {
		const maxErrorBody = 4 << 10 // 4 KiB
		rb, readErr := io.ReadAll(&io.LimitedReader{R: resp.Body, N: maxErrorBody})
		if readErr != nil {
			return fmt.Errorf("error, when reading error resp body: %w", readErr)
		}
		if resp.StatusCode == http.StatusNotFound {
			log.Printf("received a 404 when attempting url. Url: %s", request.URL)
		}
		return fmt.Errorf(
			"error, when performing get request. REQUEST METHOD: %s. RESPONSE CODE: %d. RESPONSE MESSAGE: %s",
			method,
			resp.StatusCode,
			string(rb),
		)
	}

	// Caller doesn't care about response body; just drain so connection can be reused.
	if dst == nil {
		_, _ = io.Copy(io.Discard, resp.Body)
		return nil
	}

	dec := json.NewDecoder(resp.Body)
	if err := dec.Decode(dst); err != nil {
		if err == io.EOF {
			return fmt.Errorf("%s %q: empty response body", method, theURL)
		}
		return fmt.Errorf("error, %s %q: decoding JSON response: %w", method, theURL, err)
	}

	return nil
}
