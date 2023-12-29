package handlers

import (
	"log"
	"net/http"
	"io"
    "bytes"
    "encoding/json"
)

type Products struct {
	l *log.Logger
}

type DataToSend struct {
    Title string `json:"title"`
    Genre string    `json:"genre"`
    ReleaseYear int `json:"releaseYear"`
}

func NewProducts(l *log.Logger) *Products{
	return &Products{l}
}

func (p *Products) GetProducts(rw http.ResponseWriter, r *http.Request) {
    p.l.Println("Handle GET Products")

    // Fetch the data from fruit-api
    resp, err := http.Get("http://app-node:3000/movies")
    if err != nil {
        log.Fatal(err)
    }
    defer resp.Body.Close() // Close the response body

    // Read the response body
    body, err := io.ReadAll(resp.Body)
    if err != nil {
        log.Fatalln(err)
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
        http.Error(w, err.Error(), http.StatusBadRequest)
        return
    }

    // Send the product to the other service as a POST request
    payload, err := json.Marshal(newProduct)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }

    url := "http://app-node:3000/movies"
    req, err := http.NewRequest("POST", url, bytes.NewBuffer(payload))
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    req.Header.Set("Content-Type", "application/json")

    client := &http.Client{}
    resp, err := client.Do(req)
    if err != nil {
        http.Error(w, err.Error(), http.StatusInternalServerError)
        return
    }
    defer resp.Body.Close()

    if resp.StatusCode == http.StatusOK {
        p.l.Printf("Product added successfully to the other service")
        w.WriteHeader(http.StatusOK)
    } else {
        http.Error(w, "Failed to send product to the other service", resp.StatusCode)
    }
}
