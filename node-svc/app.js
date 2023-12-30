// app/app.js
const express = require("express")
const mongoose = require("mongoose")
const bodyParser = require("body-parser")
const movieRoutes = require("./app/routes/movieRoutes")
require("dotenv").config() // Load environment variables

const app = express()

// Middleware
app.use(bodyParser.json())

// Connect to MongoDB using environment variable
mongoose.connect(process.env.DB_URL, {
	useNewUrlParser: true,
	useUnifiedTopology: true,
})

// Routes
app.use("/movies", movieRoutes)

// Start server
const PORT = process.env.PORT || 3000
app.listen(PORT, () => {
	console.log(`Server is running on port ${PORT}`)
})
