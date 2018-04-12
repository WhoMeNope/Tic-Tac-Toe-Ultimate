package main

import (
	"flag"
	"log"
	"net/http"
)

func main() {
	var port string
	flag.StringVar(&port, "port", "8000", "The port on which the server runs")
	flag.Parse()

	fs := http.FileServer(http.Dir("../public")) // Change this to wherever your executable will be
	http.Handle("/", fs)
	http.HandleFunc("/match", enqueue)

	log.Println("Server started on port " + port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
