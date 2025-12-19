
// In migration file:
// -- Set busy_timeout to 5000 milliseconds (5 seconds)
// -- This ensures SQLite will wait up to 5 seconds for a lock before returning SQLITE_BUSY
// PRAGMA busy_timeout = 5000;
// PRAGMA journal_mode = WAL;

// -- Create a test table for health check lock testing
// -- This table is used to test database lock detection
// CREATE TABLE IF NOT EXISTS health_check_test (
//     id INTEGER PRIMARY KEY,
//     test_value TEXT
// );



// CheckDatabaseLock checks if the database is locked for more than 5 seconds.
// With PRAGMA busy_timeout = 5000, SQLite will only return SQLITE_BUSY after waiting 5 seconds.
// Returns an error if SQLITE_BUSY is encountered, indicating the database has been locked for more than 5 seconds.
func (m *HealthModel) CheckDatabaseLock(ctx context.Context, timeout time.Duration) error {
	// Create a context with timeout for the database check
	checkCtx, cancel := context.WithTimeout(ctx, timeout)
	defer cancel()

	// Attempt to acquire a write lock immediately
	// With PRAGMA busy_timeout = 5000, this will wait up to 5 seconds before returning SQLITE_BUSY
	_, err := m.database..ExecContext(checkCtx, "DELETE FROM health_check_test WHERE id = 999")
	if err != nil {
		// Check if the error is a SQLite error with BUSY_TIMEOUT or BUSY code
		var sqliteErr *sqlite3.Error
		if errors.As(err, &sqliteErr) {
			// Check for BUSY_TIMEOUT (extended error code) or BUSY (base error code)
			if sqliteErr.ExtendedCode() == sqlite3.BUSY_TIMEOUT || sqliteErr.Code() == sqlite3.BUSY {
				msg := fmt.Sprintf("database has been locked for more than 5 seconds: %v", err)
				log.Println(msg)
				return errors.New(msg)
			}
		}
		// Other errors (connection issues, etc.)
		msg := fmt.Sprintf("database error: %v", err)
		log.Println(msg)
		return errors.New(msg)
	}

	// Successfully acquired the lock within 5 seconds
	return nil
}

