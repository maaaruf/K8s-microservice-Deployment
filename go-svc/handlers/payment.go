package handlers

import (
	"bytes"
	"encoding/json"
	"io"
	"log"
	"net/http"
)

type Payment struct {
	l *log.Logger
}

type PaymentData struct {
	Amount int `json:"amount"`
}

func NewPayment(l *log.Logger) *Payment {
	return &Payment{l}
}

func (p *Payment) LoadPayments(rw http.ResponseWriter, r *http.Request) {
	p.l.Println("Handle GET Payments")

	// Fetch the data from fruit-api
	resp, err := http.Get("http://app-dotnet:8080/api/LoadPayments")
	if err != nil {
		p.l.Println("Error fetching data from payment-api:", err)
		http.Error(rw, "Error fetching data from payment-api", http.StatusInternalServerError)
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

func (p *Payment) Pay(w http.ResponseWriter, r *http.Request) {
	p.l.Println("Handle POST Request")

	var newPayment PaymentData
	err := json.NewDecoder(r.Body).Decode(&newPayment)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Send the payment to the other service as a POST request
	payload, err := json.Marshal(newPayment)
	if err != nil {
		p.l.Println("Error marshalling payload:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	url := "http://app-dotnet:8080/api/Pay"
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payload))
	if err != nil {
		p.l.Println("Error creating request:", err)
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
