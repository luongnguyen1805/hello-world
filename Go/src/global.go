package main

import (
	"fmt"
	"sync"
)

type Global struct{}

func (g *Global) Action1() {
	fmt.Printf("\n\r...Action1...")
}

func (g *Global) Action2() {
	fmt.Printf("\n\r...Action2...")
}

var (
	instance *Global
	once     sync.Once
)

func Shared() *Global {
	once.Do(func() {
		instance = &Global{}
	})
	return instance
}
