// app/controllers/movieController.js
const Movie = require("../models/Movie")

// Controller methods
exports.getAllMovies = async (req, res) => {
	try {
		const movies = await Movie.find()
		res.json(movies)
	} catch (error) {
		res.status(500).json({ error: error.message })
	}
}

exports.getMovieById = async (req, res) => {
	try {
		const movie = await Movie.findById(req.params.id)
		res.json(movie)
	} catch (error) {
		res.status(500).json({ error: error.message })
	}
}

exports.createMovie = async (req, res) => {
	try {
		const movie = new Movie(req.body)
		await movie.save()
		res.status(201).json(movie)
	} catch (error) {
		res.status(500).json({ error: error.message })
	}
}

exports.updateMovie = async (req, res) => {
	try {
		const movie = await Movie.findByIdAndUpdate(req.params.id, req.body, { new: true })
		res.json(movie)
	} catch (error) {
		res.status(500).json({ error: error.message })
	}
}

exports.deleteMovie = async (req, res) => {
	try {
		await Movie.findByIdAndDelete(req.params.id)
		res.status(204).end()
	} catch (error) {
		res.status(500).json({ error: error.message })
	}
}
