const express = require('express');
const { getAllBantuan, createBantuan } = require('../controllers/bantuanController');
const router = express.Router();

router.get('/', getAllBantuan);
router.post('/', createBantuan);

module.exports = router;