const mongoose = require('mongoose');

const EdukasiSchema = new mongoose.Schema({
  title: String,
  content: String,
});

module.exports = mongoose.model('Edukasi', EdukasiSchema);
