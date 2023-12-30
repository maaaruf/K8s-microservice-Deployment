package main

import (
	"log"
	"net/http"
	"os"
	"os/signal"
	"github.com/gorilla/mux"
	"time"
	"context"
	"poridhi/handlers"
	gohandlers "github.com/gorilla/handlers"
	// "github.com/rs/cors"
)

func main(){
	l := log.New(os.Stdout, "products-api", log.LstdFlags)

	ph := handlers.NewProducts(l)
	pay := handlers.NewPayment(l)

	// create a new serve mux and register the handlers

	sm := mux.NewRouter()

	getRouter := sm.Methods(http.MethodGet).Subrouter()
	getRouter.HandleFunc("/", ph.GetProducts)
	getRouter.HandleFunc("/payment", pay.LoadPayments)

	postRouter := sm.Methods(http.MethodPost).Subrouter()
	postRouter.HandleFunc("/", ph.AddProduct)
	postRouter.HandleFunc("/payment", pay.Pay)
	// postRouter.Use(ph.MiddlewareValidateProduct)

	// putRouter := sm.Methods(http.MethodPut).Subrouter()
	// putRouter.HandleFunc("/{id:[0-9]+}", ph.UpdateProducts)
	// putRouter.Use(ph.MiddlewareValidateProduct)
	
	


	// CORS
	// ch := gohandlers.CORS(
	// 	gohandlers.AllowedOrigins([]string{"*"}),
	// 	gohandlers.AllowedMethods([]string{"*"}),
	// 	gohandlers.AllowedHeaders([]string{"*"}),
	// )
	ch := gohandlers.CORS(
		gohandlers.AllowedOrigins([]string{"*"}),
		gohandlers.AllowedMethods([]string{"GET", "HEAD", "POST", "PUT", "OPTIONS"}),
		gohandlers.AllowedHeaders([]string{"Content-Type"}),
	)
	// c := cors.New(cors.Options{
    //     AllowedOrigins: []string{"*"},
    //     AllowCredentials: true,
    // })

	// create a new server
	s := http.Server{
		Addr:         ":9090",      // configure the bind address
		Handler:      ch(sm),                // set the default handler
		ErrorLog:     l,                 // set the logger for the server
		ReadTimeout:  5 * time.Second,   // max time to read request from the client
		WriteTimeout: 10 * time.Second,  // max time to write response to the client
		IdleTimeout:  120 * time.Second, // max time for connections using TCP Keep-Alive
	}

	// start the server
	go func()  {
		l.Println("Starting server on port 9090")

		err := s.ListenAndServe()
		if err != nil{
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