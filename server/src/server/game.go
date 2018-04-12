package main

import (
	"log"

	"github.com/gorilla/websocket"
)

type game struct {
	playerOne     *websocket.Conn
	playerTwo     *websocket.Conn
	board         wholeBoard
	playerOneTurn bool
}

type turn struct {
	Board  int `json:"board"`
	Square int `json:"square"`
}

func newGame(pOne, pTwo *websocket.Conn) {
	nGame := game{playerOne: pOne, playerTwo: pTwo, board: newBoard(), playerOneTurn: true}
	go playGame(&nGame)
}

func playGame(game *game) {
	var (
		playerOneCh = make(chan turn, 100)
		playerTwoCh = make(chan turn, 100)
		playing     = true
	)

	defer game.playerOne.Close()
	defer game.playerTwo.Close()

	go listenPlayer(game.playerOne, playerOneCh, playing)
	go listenPlayer(game.playerTwo, playerTwoCh, playing)

	for playing {
		select { // check if this would call both cases if there are stuff inside both channels
		case msg := <-playerOneCh:
			if game.playerOneTurn {
				game.playerTwo.WriteJSON(msg)
				game.playerOneTurn = !game.playerOneTurn
			} else {
				game.playerOne.WriteJSON("It's not your turn, sorry")
			}
		case msg := <-playerTwoCh:
			if !game.playerOneTurn {
				game.playerOne.WriteJSON(msg)
				game.playerOneTurn = !game.playerOneTurn
			} else {
				game.playerTwo.WriteJSON("It's not your turn, sorry")
			}
		}
	}
	game.playerOne.WriteJSON(createDisconnectMessage)
	game.playerTwo.WriteJSON(createDisconnectMessage)
}

func listenPlayer(player *websocket.Conn, ch chan turn, playing bool) {
	for playing {
		var msg turn

		err := player.ReadJSON(&msg)
		log.Println(msg)

		if err != nil {
			log.Printf("error: %v", err)
			break
		}

		ch <- msg
	}
}
