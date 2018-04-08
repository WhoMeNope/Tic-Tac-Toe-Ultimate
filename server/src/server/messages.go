package main

type connectedMessage struct {
	Event    string
	IsX      bool
	IsXfirst bool
}

func newConnectedMessage(isX, isXfirst bool) connectedMessage {
	return connectedMessage{
		Event:    "CONNECTED",
		IsX:      isX,
		IsXfirst: isXfirst,
	}
}
