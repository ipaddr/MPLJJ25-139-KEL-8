const mongoose = require('mongoose');

const BantuanSchema = new mongoose.Schema({
  title: String,
  description: String,
  status: String,
});

module.exports = mongoose.model('Bantuan', BantuanSchema);