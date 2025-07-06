const ActiveProblem = require('../models/ActiveProblem');
require('dotenv').config();

const startNewProblem = async (req, res) => {
  const ADMIN_SECRET = process.env.ADMIN_SECRET;
  const authHeader = req.headers.authorization;

  if (!authHeader || authHeader !== `Bearer ${ADMIN_SECRET}`) {
    return res.status(403).send('Unauthorized');
  }

  const { contestId, index } = req.body;

  if (!contestId || !index) {
    return res.status(400).send('contestId and index are required');
  }

  const problemId = `${contestId}${index}`;
  const startTime = new Date();
  const endTime = new Date(Date.now() + 24 * 60 * 60 * 1000); 

  try {
    await ActiveProblem.deleteMany(); 
    const newProblem = new ActiveProblem({
      problemId,
      contestId,
      index,
      startTime,
      endTime,
    });

    await newProblem.save();
    res.send('New problem started');
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

module.exports = { startNewProblem };
