package main

import (
	"fmt"
	"time"
)

// Config defines application configuration
type Config struct {
	Name    string `json:"name"`
	Version string `json:"version"`
	Debug   bool   `json:"debug"`
}

// Server represents a web server
type Server struct {
	config *Config
	port   int
}

// NewServer creates a new server instance
func NewServer(config *Config, port int) *Server {
	return &Server{
		config: config,
		port:   port,
	}
}

// Start begins the server
func (s *Server) Start() error {
	fmt.Printf("Starting %s v%s on port %d\n",
		s.config.Name, s.config.Version, s.port)

	// Simulate server startup
	time.Sleep(1 * time.Second)
	return nil
}

func main() {
	config := &Config{
		Name:    "TestApp",
		Version: "1.0.0",
		Debug:   true,
	}

	server := NewServer(config, 8080)
	if err := server.Start(); err != nil {
		fmt.Printf("Error starting server: %v\n", err)
	}
}
