const mongoose=require('mongoose')

const userSchema = new mongoose.Schema({
  handle: String,
  points: { type: Number, default: 0 },
  solvedProblems: [String], 
});
const activeProblemSchema = new mongoose.Schema({
  problemId: String, // e.g., "1700A"
  contestId: Number,
  index: String,     // e.g., "A"
  startTime: Date,
  endTime: Date,
  processedHandles: [String] // Users who already solved it
});


module.exports = {    
    userSchema: mongoose.model('User', userSchema),
    activeProblemSchema: mongoose.model('ActiveProblem',activeProblemSchema),
}