const express = require('express');
const router = express.Router();
const {
  registerUser,
  getActiveProblem,
  getLeaderboard
} = require('../controllers/userController');

const { markProblemSolved } = require('../controllers/userController');

router.post('/solve', markProblemSolved);
router.post('/register', registerUser);

router.get('/active-problem', getActiveProblem);

router.get('/leaderboard', getLeaderboard);

module.exports = router;
