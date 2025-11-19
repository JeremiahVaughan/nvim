package template_golang

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestHttpRequest_SendsJSONAndDecodesResponse(t *testing.T) {
	t.Parallel()

	var capturedRequest struct {
		Method      string
		ContentType string
		Body        map[string]any
	}

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()

		capturedRequest.Method = r.Method
		capturedRequest.ContentType = r.Header.Get("Content-Type")

		if err := json.NewDecoder(r.Body).Decode(&capturedRequest.Body); err != nil {
			t.Fatalf("failed to decode request body: %v", err)
		}

		w.Header().Set("Content-Type", "application/json")
		_, _ = w.Write([]byte(`{"status":"ok","count":2}`))
	}))
	defer server.Close()

	type payload struct {
		Value string `json:"value"`
	}
	type response struct {
		Status string `json:"status"`
		Count  int    `json:"count"`
	}

	var dst response
	err := HttpRequest(http.MethodPost, server.URL, payload{Value: "hello"}, &dst)
	if err != nil {
		t.Fatalf("HttpRequest returned error: %v", err)
	}

	if capturedRequest.Method != http.MethodPost {
		t.Fatalf("expected method %q, got %q", http.MethodPost, capturedRequest.Method)
	}
	if capturedRequest.ContentType != "application/json" {
		t.Fatalf("expected content-type %q, got %q", "application/json", capturedRequest.ContentType)
	}
	if got := capturedRequest.Body["value"]; got != "hello" {
		t.Fatalf("expected encoded body value %q, got %v", "hello", got)
	}
	if dst.Status != "ok" || dst.Count != 2 {
		t.Fatalf("unexpected decoded response: %+v", dst)
	}
}

func TestHttpRequest_HandlesNilDestination(t *testing.T) {
	t.Parallel()

	received := make(chan error, 1)

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer r.Body.Close()
		_, err := w.Write([]byte(`{"ignored":true}`))
		received <- err
	}))
	defer server.Close()

	if err := HttpRequest(http.MethodGet, server.URL, nil, nil); err != nil {
		t.Fatalf("HttpRequest returned error: %v", err)
	}

	if err := <-received; err != nil {
		t.Fatalf("handler failed to write response: %v", err)
	}
}

func TestHttpRequest_ReturnsErrorForBadStatus(t *testing.T) {
	t.Parallel()

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.Error(w, "boom", http.StatusTeapot)
	}))
	defer server.Close()

	err := HttpRequest(http.MethodGet, server.URL, nil, &struct{}{})
	if err == nil {
		t.Fatal("expected error but got nil")
	}
	for _, want := range []string{"RESPONSE CODE: 418", "boom"} {
		if !strings.Contains(err.Error(), want) {
			t.Fatalf("error %q does not contain %q", err, want)
		}
	}
}

func TestHttpRequest_EncodeBodyFailure(t *testing.T) {
	t.Parallel()

	err := HttpRequest(http.MethodGet, "http://example.com", make(chan int), nil)
	if err == nil {
		t.Fatal("expected error but got nil")
	}
	if !strings.Contains(err.Error(), "encoding request body") {
		t.Fatalf("error %q does not indicate encoding failure", err)
	}
}

func TestHttpRequest_EmptyBodyDecodeFailure(t *testing.T) {
	t.Parallel()

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {}))
	defer server.Close()

	err := HttpRequest(http.MethodGet, server.URL, nil, &struct{}{})
	if err == nil {
		t.Fatal("expected error but got nil")
	}
	if !strings.Contains(err.Error(), "empty response body") {
		t.Fatalf("error %q does not mention empty response body", err)
	}
}
