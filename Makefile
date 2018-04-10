all:
	make clean && make server && make client

run:
	cd dist && ./server

server:
	cd server && make && cd ..
	mkdir -p dist
	cp server/server dist

client:
	cd client && elm-make Main.elm && cd ..
	mkdir -p dist
	cp client/index.html dist && cp -r client/assets dist/assets

clean:
	-rm -r dist
	-rm server/server
	-rm client/index.html

.PHONY: run clean server client
