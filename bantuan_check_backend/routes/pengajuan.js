const express = require('express');
const { getAllPengajuan, createPengajuan } = require('../controllers/pengajuanController');
const router = express.Router();

router.get('/', getAllPengajuan);
router.post('/', createPengajuan);

module.exports = router;