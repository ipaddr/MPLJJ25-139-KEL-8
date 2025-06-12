const Edukasi = require('../models/Edukasi');

exports.getAllEdukasi = async (req, res) => {
  const edukasi = await Edukasi.find();
  res.json(edukasi);
};

exports.createEdukasi = async (req, res) => {
  const { title, content } = req.body;
  const edukasi = new Edukasi({ title, content });
  await edukasi.save();
  res.status(201).json(edukasi);
};
