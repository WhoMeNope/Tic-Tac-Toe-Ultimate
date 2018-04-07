package main

type connectedMessage struct {
	Event    string
	IsX      bool
	IsXfirst bool
}

func newConnectedMessage(isX, isXfirst bool) connectedMessage {
	return connectedMessage{
		Event:    "CONNECTED",
		IsX:      true,
		IsXfirst: true,
	}
}
