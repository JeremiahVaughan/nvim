---
name: http-response-optimization
description: Improve HTTP handler responses with correct content headers and compression. Use when the user asks to add gzip, set UTF-8 content types, reduce response size, or tune response headers for large pages.
---

# HTTP Response Optimization

## Quick Start

When asked to optimize a response:

1. Locate the exact handler that writes the response body.
2. Set an explicit content type with charset when returning text.
3. Add compression negotiation (`Accept-Encoding`).
4. Set cache-variant headers (`Vary`) when compression is conditional.
5. Validate behavior for compressed and uncompressed clients.

## Default Implementation Pattern (Go net/http)

Use this baseline for HTML/text endpoints:

```go
w.Header().Set("Content-Type", "text/html; charset=utf-8")

var out io.Writer = w
if strings.Contains(r.Header.Get("Accept-Encoding"), "gzip") {
	w.Header().Set("Content-Encoding", "gzip")
	w.Header().Set("Vary", "Accept-Encoding")

	gz := gzip.NewWriter(w)
	defer gz.Close()
	out = gz
}

err := tmpl.Execute(out, data)
if err != nil {
	// existing project error path
}
```

## Decision Rules

- For HTML pages, default to `text/html; charset=utf-8`.
- For JSON APIs, use `application/json; charset=utf-8`.
- Only set `Content-Encoding: gzip` when gzip is actually used.
- Add `Vary: Accept-Encoding` whenever compressed/uncompressed variants exist.
- Keep the non-gzip path unchanged for compatibility.
- Avoid broad refactors unless the user asks; keep changes scoped to requested handlers.

## Validation Checklist

- [ ] Endpoint still renders normally without `Accept-Encoding: gzip`.
- [ ] Compressed request returns `Content-Encoding: gzip`.
- [ ] Response includes intended UTF-8 content type header.
- [ ] `Vary: Accept-Encoding` is present when gzip branch exists.
- [ ] Build/lint pass after edits.

## Verification Commands

```bash
# Compressed path
curl -sI -H "Accept-Encoding: gzip" http://localhost:8080/your-endpoint

# Uncompressed path
curl -sI http://localhost:8080/your-endpoint
```
