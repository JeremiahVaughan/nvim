func DoingSOmething() error {
    done := make(chan error, 1)

	go func() {
            err := doingSomethingElse()
            if err != nil {
                done <- fmt.Errorf("error, when doingSomethingElse() for DoingSomething(). Error: %v", err)
                return
            }
	    done <- nil
	}()

	select {
	case err := <-done:
		return err
	case <- time.After(20 * time.Seconds):
		return errors.New("error, doingSOmethingElse() for DoingSomething() has timed out")
	}
}
