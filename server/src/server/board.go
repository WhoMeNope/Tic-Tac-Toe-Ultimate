package main

type square int

const (
	empty square = 0
	x     square = 1
	o     square = 2
)

type board struct {
	fields [9]square
	isDone bool
}

type wholeBoard struct {
	boards [9]board
}

func newBoard() wholeBoard {
	return wholeBoard{
		boards: [9]board{},
	}
}
