type Task struct {
	Fn     func(chan string)
	Result chan string
}

type TaskQueue struct {
	taskChan chan Task
}

var taskQueueInstance *TaskQueue
var once sync.Once

func GetTaskQueueInstance() *TaskQueue {
	once.Do(func() {
		taskQueueInstance = &TaskQueue{
			taskChan: make(chan Task, 100),
		}
		taskQueueInstance.StartWorkers(10)
	})
	return taskQueueInstance
}

func (q *TaskQueue) StartWorkers(numWorkers int) {
	for i := 0; i < numWorkers; i++ {
		go func() {
			for task := range q.taskChan {
				task.Fn(task.Result)
			}
		}()
	}
}

func (q *TaskQueue) AddTask(task Task) {
	q.taskChan <- task
}

func exampleUsage() {
	// Fetch the singleton instance and start 10 workers
	queue := GetTaskQueueInstance()

	// Create yer own channel to receive the result
	resultChan := make(chan string)

	// Add the task
	queue.AddTask(Task{
		Fn: func(result chan string) {
			result <- "This task be complete, yarrr!"
		},
		Result: resultChan,
	})

	// Wait for result
	result := <-resultChan
	fmt.Println("Result: ", result)

	// Yarrr, add more tasks as ye please!
}
