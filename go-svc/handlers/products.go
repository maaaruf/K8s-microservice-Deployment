package handlers

import (
	"bytes"
	"encoding/json"
	"io"
	"log"
	"net/http"
)

type Products struct {
	l *log.Logger
}

type DataToSend struct {
	Title       string `json:"title"`
	Genre       string `json:"genre"`
	ReleaseYear int    `json:"releaseYear"`
}

func NewProducts(l *log.Logger) *Products {
	return &Products{l}
}

func (p *Products) GetProducts(rw http.ResponseWriter, r *http.Request) {
	p.l.Println("Handle GET Products")

	// Fetch the data from fruit-api
	resp, err := http.Get("http://app-node:3000/movies")
	if err != nil {
		p.l.Println("Error fetching data from fruit-api:", err)
		http.Error(rw, "Error fetching data from fruit-api", http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close() // Close the response body

	// Read the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		p.l.Println("Error reading response body:", err)
		http.Error(rw, "Error reading response body", http.StatusInternalServerError)
		return
	}

	// Write the body to the client
	rw.WriteHeader(resp.StatusCode)
	rw.Write(body)
}

func (p *Products) AddProduct(w http.ResponseWriter, r *http.Request) {
	p.l.Println("Handle POST Request")

	var newProduct DataToSend
	err := json.NewDecoder(r.Body).Decode(&newProduct)
	if err != nil {
		p.l.Println("Error decoding JSON:", err)
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Send the product to the other service as a POST request
	payload, err := json.Marshal(newProduct)
	if err != nil {
		p.l.Println("Error marshalling JSON:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	url := "http://app-node:3000/movies"
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payload))
	if err != nil {
		p.l.Println("Error creating POST request:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		p.l.Println("Error sending POST request:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	// Read the response body
	responseBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		p.l.Println("Error reading response body:", err)
		http.Error(w, "Error reading response body", http.StatusInternalServerError)
		return
	}

	// Log the response
	p.l.Printf("Response from the other service: %s\n", responseBytes)

	// Write the response body to the client
	w.WriteHeader(resp.StatusCode)
	w.Write(responseBytes)
}
