const express = require('express');
const router = express.Router();
const { startNewProblem } = require('../controllers/adminController');

router.post('/start-problem', startNewProblem);

module.exports = router;
