import React, { useEffect, useState } from 'react';
import axios from 'axios';
import AdminLogin from './components/AdminLogin';
import Leaderboard from './components/Leaderboard';
import ProblemDisplay from './components/ProblemDisplay';
import UserLogin from './components/UserLogin';
import AddProblem from './components/AddProblem';

const BACKEND_URL = 'http://localhost:3000';

export default function App() {
  const [problem, setProblem] = useState(null);
  const [leaderboard, setLeaderboard] = useState([]);
  const [admin, setAdmin] = useState(false);
  const [user, setUser] = useState(null);

  // Fetch active problem (public)
  const fetchActiveProblem = async () => {
    try {
      const res = await axios.get(`${BACKEND_URL}/api/users/active-problem`);
      setProblem(res.data);
    } catch {
      setProblem(null);
    }
  };
console.log(leaderboard);
  // Fetch leaderboard (public)
  const fetchLeaderboard = async () => {
    try {
      const res = await axios.get(`${BACKEND_URL}/api/users/leaderboard`);
      setLeaderboard(Array.isArray(res.data.leaderboard) ? res.data.leaderboard : []);
    } catch {
      setLeaderboard([]);
    }
  };

  // On mount fetch both problem and leaderboard (public data)
  useEffect(() => {
    fetchActiveProblem();
    fetchLeaderboard();

    const interval = setInterval(() => {
      fetchActiveProblem();
      fetchLeaderboard();
    }, 60000); // every 60 seconds

    return () => clearInterval(interval);
  }, []);

  return (
    <div className="p-4 max-w-3xl mx-auto space-y-6">
      <h1 className="text-3xl font-bold text-center">Codeforces Tracker</h1>

      {/* Always visible problem */}
      <ProblemDisplay problem={problem} />

      {/* Always visible leaderboard */}
      <Leaderboard leaderboard={leaderboard} />

      {/* Show user login/register if user not logged in */}
      {!user && (
        <UserLogin
          onLogin={(userData) => setUser(userData)}
          backendUrl={BACKEND_URL}
        />
      )}

      {/* Admin login and add problem */}
      {!admin ? (
        <AdminLogin
          onAdminLogin={() => setAdmin(true)}
          backendUrl={BACKEND_URL}
          onRefreshProblem={fetchActiveProblem}
        />
      ) : (
        <div className="space-y-2">
          <p className="text-center text-green-600 font-semibold">Admin logged in</p>
          <AddProblem backendUrl={BACKEND_URL} onProblemAdded={fetchActiveProblem} />
        </div>
      )}
    </div>
  );
}
