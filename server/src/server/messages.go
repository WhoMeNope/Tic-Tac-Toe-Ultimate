package main

type connectedMessage struct {
	Event    string
	IsX      bool
	IsXfirst bool
}

type disconnectMessage struct {
	Event string
}

func createConnectedMessage(isX, isXfirst bool) connectedMessage {
	return connectedMessage{
		Event:    "CONNECTED",
		IsX:      isX,
		IsXfirst: isXfirst,
	}
}

func createDisconnectMessage() disconnectMessage {
	return disconnectMessage{
		Event: "DISCONNECT",
	}
}
