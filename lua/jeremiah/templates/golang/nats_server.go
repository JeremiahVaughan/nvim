
import (
	"github.com/nats-io/nats-server/v2/server"
)

opts := &server.Options{ 
    Port: 3000,
	Websocket: server.WebsocketOpts{
		Host:  "0.0.0.0",
		Port:  4430,
	},
}
ns, err := server.NewServer(opts)
if err != nil {
    log.Fatalf("error, unable to start nats server. Error: %v", err)
}
go ns.Start()
if !ns.ReadyForConnections(10 * time.Second) {
    log.Fatalf("error, nats failed to start due to timeout")
}
