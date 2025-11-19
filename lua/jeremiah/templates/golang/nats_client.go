
import (
	"github.com/nats-io/nats.go"
)

opts := []nats.Option{
    nats.MaxReconnects(-1),
}
Conn, err = nats.Connect(url, opts...)
if err != nil {
    panic(fmt.Errorf("error, when connecting to nats service for client init. Error: %v", err))
}
