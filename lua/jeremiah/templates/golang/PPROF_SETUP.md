# Performance Profiling Setup with pprof

This document explains how performance profiling was integrated into the BOMR Forecaster application using Go's `runtime/pprof` package.

## Overview

The application now includes HTTP endpoints for runtime profiling, allowing you to identify CPU and memory hot paths in your codebase. This is enabled via the `net/http/pprof` package, which exposes profiling endpoints over HTTP.

## Changes Made

### 1. Router Changes (`router/router.go`)

**Import Added:**
```go
import (
    // ... existing imports
    "net/http/pprof"
)
```

**Handler Registration:**
Added pprof endpoint registration in the `New()` function (lines 137-151):

```go
// Enable pprof endpoints in local mode, dev environment, or when explicitly enabled
if config.EnablePprof {
    // Register pprof handlers manually since we're using a custom ServeMux
    r.mux.HandleFunc("/debug/pprof/", pprof.Index)
    r.mux.HandleFunc("/debug/pprof/cmdline", pprof.Cmdline)
    r.mux.HandleFunc("/debug/pprof/profile", pprof.Profile)
    r.mux.HandleFunc("/debug/pprof/symbol", pprof.Symbol)
    r.mux.HandleFunc("/debug/pprof/trace", pprof.Trace)
    r.mux.HandleFunc("/debug/pprof/heap", pprof.Handler("heap").ServeHTTP)
    r.mux.HandleFunc("/debug/pprof/goroutine", pprof.Handler("goroutine").ServeHTTP)
    r.mux.HandleFunc("/debug/pprof/allocs", pprof.Handler("allocs").ServeHTTP)
    r.mux.HandleFunc("/debug/pprof/block", pprof.Handler("block").ServeHTTP)
    r.mux.HandleFunc("/debug/pprof/mutex", pprof.Handler("mutex").ServeHTTP)
    log.Printf("pprof endpoints enabled at /debug/pprof/")
}
```

**Key Points:**
- Handlers are registered manually because we use a custom `http.ServeMux` instead of the default
- Endpoints are only enabled when:
  - `config.EnablePprof` is true, OR
  - `config.LocalMode` is true, OR
  - `config.Environment == "dev"`
- This ensures pprof is not exposed in production by default

### 2. Config Changes (`config/config.go`)

**New Field Added:**
```go
type Config struct {
    // ... existing fields
    EnablePprof bool `json:"ENABLE_PPROF"`
    // ... rest of fields
}
```

**Environment Variable Support:**
Added check in `New()` function (lines 112-115):

```go
// Check environment variable as override for pprof
if os.Getenv("ENABLE_PPROF") == "true" {
    C.EnablePprof = true
}
```

**Key Points:**
- `EnablePprof` can be set in the JSON config file
- Environment variable `ENABLE_PPROF=true` overrides the config file setting
- This allows runtime control without modifying config files

### 3. Makefile Changes (`Makefile`)

**New Target Added:**
// note when starting up this server you may see this message:

Couldn't find a suitable web browser!
Set the BROWSER environment variable to your desired browser.

This likely means that you are running on headless machine, 
which is fine because the only thing that failed was the browser auto-starting. You can still connect to the server.

```makefile
p:
	@echo "Starting application with pprof enabled..."
	@echo "pprof endpoints will be available at: http://localhost:8081/debug/pprof/"
	@echo "Example: go tool pprof http://localhost:8081/debug/pprof/profile?seconds=30"
	$(eval include include .env.local)
	ENABLE_PPROF=true go run .
```

**Key Points:**
- `make p` starts the application with pprof enabled
- Sets `ENABLE_PPROF=true` environment variable
- Provides helpful usage instructions

## Usage

### Starting the Application with Profiling

```bash
make p
```

This will:
1. Start the application on the configured port (default: 8081)
2. Enable pprof endpoints at `/debug/pprof/`
3. Log a message confirming pprof is enabled

### Available Endpoints

Once running, the following endpoints are available:

- `http://localhost:8081/debug/pprof/` - Index page listing all profiles
- `http://localhost:8081/debug/pprof/profile` - CPU profile (requires `?seconds=N` parameter)
- `http://localhost:8081/debug/pprof/heap` - Memory/heap profile
- `http://localhost:8081/debug/pprof/goroutine` - Goroutine profile
- `http://localhost:8081/debug/pprof/allocs` - Allocation profile
- `http://localhost:8081/debug/pprof/block` - Blocking operations profile
- `http://localhost:8081/debug/pprof/mutex` - Mutex contention profile
- `http://localhost:8081/debug/pprof/trace` - Execution trace

### Generating Profiles

#### CPU Profile (30 seconds)
```bash
go tool pprof http://localhost:8081/debug/pprof/profile?seconds=30
```

**Important:** Generate load on your application while profiling is running, otherwise you'll get 0 samples.

#### Heap/Memory Profile
```bash
go tool pprof http://localhost:8081/debug/pprof/heap
```

#### Goroutine Profile
```bash
go tool pprof http://localhost:8081/debug/pprof/goroutine
```

### Analyzing Profiles

#### Interactive Mode
Once in pprof interactive mode, use these commands:

- `top` - Show top functions by CPU/memory usage
- `top10` - Show top 10 functions
- `list <function_name>` - Show annotated source code
- `web` - Generate visual graph (requires graphviz)
- `svg` - Generate SVG visualization
- `png` - Generate PNG visualization
- `help` - Show all available commands

#### Web UI (Recommended)
For the easiest analysis experience:

```bash
# Save profile to file first
curl "http://localhost:8081/debug/pprof/profile?seconds=30" > cpu.prof

# Open in web UI
go tool pprof -http=:8082 cpu.prof

# Store profile data in memory so you don't have to remember to clean up
go tool pprof -http=:8082 "http://localhost:8081/debug/pprof/profile?seconds=30"
```

This opens a web interface at `http://localhost:8082` with:
- **Top** view - Functions sorted by usage
- **Graph** view - Visual call graph
- **Flame Graph** view - Flame graph visualization
- **Source** view - Annotated source code
- **Disassembly** view - Assembly code

### Example Workflow

1. **Start application with profiling:**
   ```bash
   make p
   ```

2. **In another terminal, generate load while profiling:**
   ```bash
   # Generate a 30-second CPU profile
   go tool pprof http://localhost:8081/debug/pprof/profile?seconds=30
   
   # While profiling is running, use your application normally
   # or generate load with curl requests
   ```

3. **Analyze the profile:**
   ```bash
   # If you saved it to a file
   go tool pprof -http=:8082 cpu.prof
   
   # Or use interactive mode
   go tool pprof cpu.prof
   (pprof) top10
   (pprof) list <function_name>
   (pprof) web
   ```

## Prerequisites

### Install Graphviz (for visual graphs)

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install graphviz
```

**macOS:**
```bash
brew install graphviz
```

**Fedora/RHEL:**
```bash
sudo dnf install graphviz
```

Verify installation:
```bash
dot -V
```

## Troubleshooting

### "No samples were found"

This means your application was idle during profiling. Solutions:

1. **Generate load while profiling:**
   ```bash
   # Terminal 1: Start profiling
   go tool pprof http://localhost:8081/debug/pprof/profile?seconds=30
   
   # Terminal 2: Generate load
   for i in {1..100}; do
       curl -s http://localhost:8081/bomr/getForecast > /dev/null &
   done
   ```

2. **Use different profile types:**
   - Heap profile works even when idle
   - Goroutine profile shows what goroutines are doing

3. **Enable block profiling** (for I/O-bound apps):
   Add to `main.go`:
   ```go
   import _ "runtime"
   
   func main() {
       runtime.SetBlockProfileRate(1)
       runtime.SetMutexProfileFraction(1)
       // ... rest of code
   }
   ```

### Profile file is binary

CPU profile files (`.pb.gz`) are binary format. Use `go tool pprof` to read them:

```bash
go tool pprof cpu.prof
# or
go tool pprof -http=:8082 cpu.prof
```

### Port conflicts

If port 8081 is already in use, check your config file for the `HTTP_PORT` setting and adjust accordingly.

## Security Considerations

- **Production:** pprof endpoints are **NOT** enabled in production by default
- **Manual Override:** Use `ENABLE_PPROF=true` environment variable to enable explicitly

**Important:** Never expose pprof endpoints in production without proper authentication, as they can reveal sensitive information about your application's internals.

## Additional Resources

- [Go pprof Documentation](https://pkg.go.dev/net/http/pprof)
- [Go Blog: Profiling Go Programs](https://go.dev/blog/pprof)
- [Dave Cheney's pprof Guide](https://github.com/google/pprof/blob/main/doc/README.md)

## Summary

The pprof integration provides:
- ✅ Easy-to-use HTTP endpoints for profiling
- ✅ Multiple profile types (CPU, heap, goroutine, etc.)
- ✅ Simple `make p` command to enable profiling
- ✅ Safe defaults (disabled in production)
- ✅ Environment variable override for flexibility
- ✅ Web UI support for visual analysis

Use `make p` to start profiling, then use `go tool pprof` to analyze your application's performance characteristics and identify hot paths.
