
func printStackTrace() {
    // Create a byte slice to hold the stack trace, size 1024 bytes
    buf := make([]byte, 1024)
    // Capture stack trace into buf, runtime.Stack returns the length of n bytes written
    n := runtime.Stack(buf, false)
    // Print the stack trace as a string
    log.Printf("Stack trace:\n%s\n", buf[:n])
}

