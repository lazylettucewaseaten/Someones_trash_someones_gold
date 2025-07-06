const User = require('../models/User');
const ActiveProblem = require('../models/ActiveProblem');

const getLeaderboard = async (req, res) => {
  try {
    const activeProblem = await ActiveProblem.findOne({});
    const problemId = activeProblem ? activeProblem.problemId : null;


    const users = await User.find({});

    res.json({
      problemId,
      leaderboard: users.map(user => ({
        handle: user.handle,
        totalSolved: user.solvedProblems.length,
        hasSolvedActive: problemId ? user.solvedProblems.includes(problemId) : false,
      })),
    });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};




const registerUser = async (req, res) => {
  const { handle } = req.body;
  const exists = await User.findOne({ handle });
  if (exists) return res.status(400).send('User exists');
  const user = new User({ handle });
  await user.save();
  res.send('Registered');
};


const getActiveProblem = async (req, res) => {
  try {
    const problem = await ActiveProblem.findOne({});
    if (!problem) return res.status(404).json({ message: 'No active problem' });
    res.json(problem);
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};



const markProblemSolved = async (req, res) => {
  const { handle } = req.body;
  if (!handle) return res.status(400).json({ message: 'User handle required' });

  try {
    const activeProblem = await ActiveProblem.findOne({});
    if (!activeProblem) return res.status(404).json({ message: 'No active problem found' });

    if (!activeProblem.solvedHandles.includes(handle)) {
      activeProblem.solvedHandles.push(handle);
      await activeProblem.save();
    }

    res.json({ message: 'Marked solved successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Server error', error: err.message });
  }
};

module.exports = {
  registerUser,
  getActiveProblem,
  getLeaderboard,
  markProblemSolved,
};
