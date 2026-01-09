type ProfilerMutex struct {
	mu                               sync.Mutex
	startTime time.Time
	queryName string
}

func (pm *ProfilerMutex) Lock(queryName string) {
	pm.mu.Lock()
	pm.startTime = time.Now()
	pm.queryName = queryName
}

func (pm *ProfilerMutex) Unlock() {
	log.Printf("%s. Duration: %s\n", pm.queryName, time.Since(pm.startTime))
	pm.mu.Unlock()
}
