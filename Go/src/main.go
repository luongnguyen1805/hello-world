package main

import (
	"fmt"
	"os"
	"time"

	"golang.org/x/term"
)

func showActions() {
	fmt.Println("\r1. Action 1")
	fmt.Println("\r2. Action 2")
	fmt.Println("\r0. Exit")
}

func main() {

	oldState, err := term.MakeRaw(int(os.Stdin.Fd()))
	if err != nil {
		panic(err)
	}
	defer func() {
		term.Restore(int(os.Stdin.Fd()), oldState)
		fmt.Println()
	}()

	input := make(chan byte)
	go func() {
		buf := make([]byte, 1)
		for {
			n, err := os.Stdin.Read(buf)
			if err == nil && n > 0 {
				input <- buf[0]
			}
		}
	}()

	showActions()
	loop := 0

	for {
		loop++
		select {
		case b := <-input:
			if b == '0' {
				fmt.Println("\n\rExit.")
				return
			}
		default:
			fmt.Printf("\033[2K\rEvent loop %d | Type command: ", loop)
			time.Sleep(1000 * time.Millisecond)
		}
	}
}
