package main

import (
	"log"
	"math/rand"
	"net/http"

	"github.com/gorilla/websocket"
)

var (
	queue    = make(chan *websocket.Conn, 100)
	upgrader = websocket.Upgrader{}
)

func enqueue(w http.ResponseWriter, r *http.Request) {
	log.Println("Someone created a websocket connection")
	playerOne, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Fatal(err)
	}

	select {
	case playerTwo := <-queue:
		match(playerOne, playerTwo)
	default:
		queue <- playerOne
	}
}

//todo fix this, it's fucking up the starting player
func match(playerOne, playerTwo *websocket.Conn) {
	xFirst := true
	if rand.Intn(2) == 0 {
		playerOne, playerTwo = playerTwo, playerOne
	}

	if rand.Intn(2) == 1 {
		xFirst = false
	}

	if err := playerOne.WriteJSON(createConnectedMessage(true, xFirst)); err != nil {
		log.Fatal(err)
	}

	if err := playerTwo.WriteJSON(createConnectedMessage(false, xFirst)); err != nil {
		log.Fatal(err)
	}

	newGame(playerOne, playerTwo)
}
