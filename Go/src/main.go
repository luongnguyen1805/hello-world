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
	commandBuffer := ""
	lastTimestamp := time.Now()

	for {
		select {
		case b, ok := <-input:
			if !ok {
				return
			}

			if b == 10 || b == 13 { // Enter
				switch commandBuffer {
				case "1":
					Shared().Action1()
				case "2":
					Shared().Action2()
				}

				fmt.Printf("\n\rExited.")
				return

			} else if b == 127 || b == 8 { // Backspace
				if len(commandBuffer) > 0 {
					commandBuffer = commandBuffer[:len(commandBuffer)-1]
				}
			} else if b >= 32 && b <= 126 { // Printable ASCII
				commandBuffer += string(b)
			}

			fmt.Printf("\033[2K\rRun loop %d | Type command: %s", loop, commandBuffer)

		default:
			nowTimestamp := time.Now()
			if nowTimestamp.Sub(lastTimestamp) > time.Second {
				fmt.Printf("\033[2K\rRun loop %d | Type command: %s", loop, commandBuffer)

				loop++
				lastTimestamp = nowTimestamp
			}
		}
	}
}
