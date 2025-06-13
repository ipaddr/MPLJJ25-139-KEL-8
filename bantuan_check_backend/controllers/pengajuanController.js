const Pengajuan = require('../models/Pengajuan');

exports.getAllPengajuan = async (req, res) => {
  const pengajuan = await Pengajuan.find().populate('userId').populate('bantuanId');
  res.json(pengajuan);
};

exports.createPengajuan = async (req, res) => {
  const { userId, bantuanId, status, tanggal } = req.body;
  const pengajuan = new Pengajuan({ userId, bantuanId, status, tanggal });
  await pengajuan.save();
  res.status(201).json(pengajuan);
};