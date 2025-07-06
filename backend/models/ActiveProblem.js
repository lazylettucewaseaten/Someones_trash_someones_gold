const mongoose = require('mongoose');

const activeProblemSchema = new mongoose.Schema({
  problemId: { type: String, required: true },
  contestId: { type: Number, required: true },
  index: { type: String, required: true },
  startTime: { type: Date, required: true },
  endTime: { type: Date, required: true },

  // Track handles of users who solved this problem
  solvedHandles: {
    type: [String],
    default: [],
  },
});

module.exports = mongoose.model('ActiveProblem', activeProblemSchema);
