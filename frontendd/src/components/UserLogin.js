import React, { useState } from 'react';
import axios from 'axios';

export default function UserLogin({ backendUrl, onLogin }) {
  const [handle, setHandle] = useState('');
  const [error, setError] = useState('');

  const handleRegister = async () => {
    try {
      await axios.post(`${backendUrl}/api/users/register`, { handle });
      onLogin(handle);
    } catch (err) {
      setError('Handle already registered or invalid.');
    }
  };

  return (
    <div className="space-y-4">
      <h2 className="text-xl font-semibold text-center">Register to View Problem</h2>
      <div className="flex items-center space-x-2 justify-center">
        <input
          type="text"
          placeholder="Enter Codeforces Handle"
          className="border rounded px-3 py-1"
          value={handle}
          onChange={(e) => setHandle(e.target.value)}
        />
        <button
          className="bg-blue-600 text-white px-4 py-1 rounded"
          onClick={handleRegister}
        >
          Register
        </button>
      </div>
      {error && <p className="text-center text-red-600">{error}</p>}
    </div>
  );
}
