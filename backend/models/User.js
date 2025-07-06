const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  handle: { type: String, unique: true },
  points: { type: Number, default: 0 },
  solvedProblems: [String],
});

module.exports = mongoose.model('User', userSchema);
