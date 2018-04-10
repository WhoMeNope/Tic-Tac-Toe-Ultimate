package main

import (
	"log"

	"github.com/gorilla/websocket"
)

func connect(c1, c2 *websocket.Conn) {
	var err error
	err = c1.WriteJSON(newConnectedMessage(true, true))
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
