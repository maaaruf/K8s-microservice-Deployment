package main

import (
	"context"
	"fmt"
	"github.com/go-redis/redis"
	gohandlers "github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"os"
	"os/signal"
	"poridhi/handlers"
	"time"

)

var client *redis.Client

func main() {
	l := log.New(os.Stdout, "products-api", log.LstdFlags)

	ph := handlers.NewProducts(l)
	pay := handlers.NewPayment(l)

	// Create Redis client
	client = redis.NewClient(&redis.Options{
		Addr:     "redis:6379",
		Password: "",
		DB:       0,
	})

	// Initialize Redis cache
	client.Set("number", "1670", 0)

	// create a new serve mux and register the handlers
	sm := mux.NewRouter()

	getRouter := sm.Methods(http.MethodGet).Subrouter()
	getRouter.HandleFunc("/api/products", ph.GetProducts)
	getRouter.HandleFunc("/api/payment", pay.LoadPayments)
	getRouter.Use(middleware)

	postRouter := sm.Methods(http.MethodPost).Subrouter()
	postRouter.HandleFunc("/api/products", ph.AddProduct)
	postRouter.HandleFunc("/api/payment", pay.Pay)
	postRouter.Use(middleware)

	// CORS
	ch := gohandlers.CORS(
		gohandlers.AllowedOrigins([]string{"*"}),
		gohandlers.AllowedMethods([]string{"GET", "HEAD", "POST", "PUT", "OPTIONS"}),
		gohandlers.AllowedHeaders([]string{"Content-Type", "X-Expected-Number"}),
	)

	// create a new server
	s := http.Server{
		Addr:         ":9090",           // configure the bind address
		Handler:      ch(sm),            // set the default handler
		ErrorLog:     l,                 // set the logger for the server
		ReadTimeout:  5 * time.Second,   // max time to read request from the client
		WriteTimeout: 10 * time.Second,  // max time to write response to the client
		IdleTimeout:  120 * time.Second, // max time for connections using TCP Keep-Alive
	}

	// start the server
	go func() {
		l.Println("Starting server on port 9090")

		err := s.ListenAndServe()
		if err != nil {
			l.Printf("Error starting server: %s\n", err)
			os.Exit(1)
		}
	}()

	// trap sigterm or interupt and gracefully shutdown the server
	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	signal.Notify(c, os.Kill)

	// Block until a signal is received.
	sig := <-c
	log.Println("Got signal:", sig)

	// gracefully shutdown the server, waiting max 30 seconds for current operations to complete
	ctx, _ := context.WithTimeout(context.Background(), 30*time.Second)
	s.Shutdown(ctx)

}

// Redis middleware
func middleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		// Get expected number from header
		expectedNum := r.Header.Get("X-Expected-Number")
		fmt.Println("Expected Number", expectedNum)

		// Get actual number from Redis
		actualNum, err := client.Get("number").Result()
		fmt.Println("Actual Number", actualNum)

		// Check if numbers match
		if err != nil || expectedNum != actualNum {
			w.WriteHeader(http.StatusForbidden)
			w.Write([]byte("Numbers do not match"))
			return
		}

		// Call next handler if match
		next.ServeHTTP(w, r)
	})
}
