stageStart := time.Now()

logStage := func(stage string, stageStart time.Time) {
	log.Printf("%s. Duration: %s\n", stage, time.Since(stageStart))
}

logStage("time spent doing XXXXXXX", stageStart)

// reference: https://en.wikipedia.org/wiki/Orders_of_magnitude_(time)
// nanosecond   ns One billionth of one second 1 ns: The time needed to execute one machine cycle by a 1 GHz microprocessor
// microsecond  μs One millionth of one second 1 μs: The time needed to execute one machine cycle by an Intel 80186 microprocessor
// millisecond  ms One thousandth of one second
