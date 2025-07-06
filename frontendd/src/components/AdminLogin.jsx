import React, { useState } from 'react';
import axios from 'axios';

export default function AdminLogin({ onAdminLogin, backendUrl, onRefreshProblem }) {
  const [id, setId] = useState('');
  const [password, setPassword] = useState('');
  const [contestId, setContestId] = useState('');
  const [index, setIndex] = useState('');

  const ADMIN_ID = 'admin';
  const ADMIN_PASS = 'admin123';
  const ADMIN_TOKEN = 'supersecureadminsecret'; // must match backend .env ADMIN_SECRET

  const handleLogin = () => {
    if (id === ADMIN_ID && password === ADMIN_PASS) {
      onAdminLogin();
    } else {
      alert('Invalid admin credentials');
    }
  };

  const handleSubmitProblem = async () => {
    if (!contestId || !index) {
      alert('Fill both contest ID and index');
      return;
    }
    try {
      await axios.post(
        `${backendUrl}/api/admin/start-problem`,
        { contestId, index },
        { headers: { Authorization: `Bearer ${ADMIN_TOKEN}` } }
      );
      alert('Problem started!');
      onRefreshProblem();
      setContestId('');
      setIndex('');
    } catch (err) {
      alert('Failed to start problem');
    }
  };

  return (
    <div className="border p-4 rounded shadow space-y-4">
      <h2 className="text-xl font-semibold">Admin Login</h2>
      <input
        type="text"
        placeholder="Admin ID"
        className="border p-2 w-full"
        value={id}
        onChange={(e) => setId(e.target.value)}
      />
      <input
        type="password"
        placeholder="Password"
        className="border p-2 w-full"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
      />
      <button onClick={handleLogin} className="bg-blue-600 text-white px-4 py-2 rounded w-full">
        Login
      </button>

      <hr />

      
    </div>
  );
}
