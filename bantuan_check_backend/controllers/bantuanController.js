const Bantuan = require('../models/Bantuan');

exports.getAllBantuan = async (req, res) => {
  const bantuan = await Bantuan.find();
  res.json(bantuan);
};

exports.createBantuan = async (req, res) => {
  const { title, description, status } = req.body;
  const bantuan = new Bantuan({ title, description, status });
  await bantuan.save();
  res.status(201).json(bantuan);
};