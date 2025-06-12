const express = require('express');
const { getAllEdukasi, createEdukasi } = require('../controllers/edukasiController');
const router = express.Router();

router.get('/', getAllEdukasi);
router.post('/', createEdukasi);

module.exports = router;