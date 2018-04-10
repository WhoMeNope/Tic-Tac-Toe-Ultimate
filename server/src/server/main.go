package main

import (
	"flag"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

var addr = flag.String("addr", "localhost:3000", "http service address")

var upgrader = websocket.Upgrader{}

var connsQueue chan *websocket.Conn

func match(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("upgrade:", err)
		return
	}

	select {
	case c2 := <-connsQueue:
		connect(c, c2)

	default:
		connsQueue <- c
	}
}

func main() {
	flag.Parse()
	log.SetFlags(0)

	http.Handle("/", http.FileServer(http.Dir(".")))

	connsQueue = make(chan *websocket.Conn, 100)
	http.HandleFunc("/match", match)

	log.Fatal(http.ListenAndServe(*addr, nil))
}
