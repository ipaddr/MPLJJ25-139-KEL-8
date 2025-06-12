const mongoose = require('mongoose');

const PengajuanSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  bantuanId: { type: mongoose.Schema.Types.ObjectId, ref: 'Bantuan' },
  status: String,
  tanggal: Date,
});

module.exports = mongoose.model('Pengajuan', PengajuanSchema);
