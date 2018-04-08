package main

import (
	"flag"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

var addr = flag.String("addr", "localhost:3000", "http service address")

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

var connsBuff chan *websocket.Conn

func pair(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("upgrade:", err)
		return
	}

	select {
	case c2 := <-connsBuff:
		connect(c, c2)

	default:
		connsBuff <- c
	}
}

func connect(c1, c2 *websocket.Conn) {
	err := c1.WriteJSON(newConnectedMessage(true, true))
	if err != nil {
		log.Println("write:", err)
		return
	}
	err = c2.WriteJSON(newConnectedMessage(false, true))
	if err != nil {
		log.Println("write:", err)
		return
	}

	go echoFromTo(c1, c2)
	go echoFromTo(c2, c1)
}

func echoFromTo(c1, c2 *websocket.Conn) {
	defer c1.Close()

	for {
		mt, message, err := c1.ReadMessage()
		if err != nil {
			log.Println("read:", err)
			break
		}
		log.Printf("recv: %s", message)

		err = c2.WriteMessage(mt, message)
		if err != nil {
			log.Println("write:", err)
			break
		}
	}
}

func main() {
	flag.Parse()
	log.SetFlags(0)

	connsBuff = make(chan *websocket.Conn, 100)
	fs := http.FileServer(http.Dir("."))

	http.HandleFunc("/match", pair)
	http.Handle("/", fs)

	log.Fatal(http.ListenAndServe(*addr, nil))
}
