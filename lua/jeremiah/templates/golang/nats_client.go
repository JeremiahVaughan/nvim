
import (
	"github.com/nats-io/nats.go"
)


opts := []nats.Option{
    nats.MaxReconnects(-1),
	nats.Token(config.DbExpressAgentKey),
}
// url can be any of these as long as the server is hosting that protocol, your client config will use the specified protocal based on what is provided as the url:
// nats://localhost:4444
// wss://localhost:4444
// ws://localhost:4444
Conn, err = nats.Connect(url, opts...)
if err != nil {
    panic(fmt.Errorf("error, when connecting to nats service for client init. Error: %v", err))
}
