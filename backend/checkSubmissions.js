// checkSubmissions.js
const cron = require('node-cron');
const axios = require('axios');
const User = require('./models/User');
const ActiveProblem = require('./models/ActiveProblem');

const CODEFORCES_API = 'https://codeforces.com/api';

cron.schedule('*/5 * * * *', async () => {
  try {
    const problem = await ActiveProblem.findOne();
    if (!problem) return;

    const now = new Date();
    if (now > problem.endTime) {
      console.log("Active problem expired.");
      return;
    }

    const usersToCheck = await User.find({
      solvedProblems: { $ne: problem.problemId }
    });

    for (const user of usersToCheck) {
      try {
        const res = await axios.get(`${CODEFORCES_API}/user.status`, {
          params: { handle: user.handle }
        });

        const submissions = res.data.result;
        const solved = submissions.some(sub =>
          sub.problem.contestId === problem.contestId &&
          sub.problem.index === problem.index &&
          sub.verdict === 'OK'
        );

        if (solved) {
          await User.updateOne(
            { handle: user.handle },
            {
              $inc: { points: 100 },
              $push: { solvedProblems: problem.problemId }
            }
          );
          console.log(`${user.handle} solved ${problem.problemId}`);
        }
      } catch (err) {
        console.error(`Error checking user ${user.handle}: ${err.message}`);
      }
    }
  } catch (err) {
    console.error(`Cron job error: ${err.message}`);
  }
});
