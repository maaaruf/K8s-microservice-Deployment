# Movie CRUD App

This is a simple movie CRUD (Create, Read, Update, Delete) application built with Node.js, Express.js, MongoDB using Mongoose, and Docker Compose.

## Getting Started

These instructions will help you set up and run the movie CRUD app on your local machine.

### Prerequisites

Make sure you have the following software installed on your machine:

- Docker
- Docker Compose
- Node.js

### Installation

1. Clone the repository:

    ```bash
    git clone <repository-url>
  
    ```

2. Install dependencies:

    ```bash
    npm install
    ```

3. Create a `.env` file in the root directory and set the necessary environment variables:

    ```dotenv
    PORT=3000
    DB_URL=mongodb://mongo:27017/movie_db
    ```

### Running the App

Use the following command to start the app:

```bash
docker-compose up --build

# Movie CRUD API

This API provides endpoints for basic CRUD operations on movies.

## Endpoints

### Get All Movies

**GET /movies**

Get a list of all movies.

#### Example

```bash
curl http://localhost:3000/movies
```

**GET /movies/:id**

```bash
curl http://localhost:3000/movies/1

```

**POST /movies**

```bash
curl -X POST -H "Content-Type: application/json" -d '{"title": "Inception", "genre": "Sci-Fi", "releaseYear": 2010}' http://localhost:3000/movies
```

**PUT /movies/:id**

```bash
curl -X PUT -H "Content-Type: application/json" -d '{"title": "Inception", "genre": "Sci-Fi", "releaseYear": 2010}' http://localhost:3000/movies/1

```

**DELETE /movies/:id**

```bash
curl -X DELETE http://localhost:3000/movies/1
```
