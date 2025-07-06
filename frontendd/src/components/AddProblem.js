import React, { useState } from 'react';
import axios from 'axios';

export default function AddProblem({ backendUrl, onProblemAdded }) {
  const [contestId, setContestId] = useState('');
  const [index, setIndex] = useState('');
  const [message, setMessage] = useState('');

  const handleAdd = async () => {
    try {
      await axios.post(`${backendUrl}/api/admin/start-problem`, {
        contestId,
        index,
      });
      setMessage('Problem added successfully');
      onProblemAdded();
    } catch {
      setMessage('Failed to add problem');
    }
  };

  return (
    <div className="space-y-2">
      <h2 className="text-lg font-semibold text-center">Add Problem (Admin)</h2>
      <div className="flex space-x-2 justify-center">
        <input
          type="text"
          placeholder="Contest ID"
          className="border px-3 py-1 rounded"
          value={contestId}
          onChange={(e) => setContestId(e.target.value)}
        />
        <input
          type="text"
          placeholder="Problem Index (e.g., A)"
          className="border px-3 py-1 rounded"
          value={index}
          onChange={(e) => setIndex(e.target.value)}
        />
        <button
          className="bg-green-600 text-white px-4 py-1 rounded"
          onClick={handleAdd}
        >
          Add
        </button>
      </div>
      {message && <p className="text-center text-blue-600">{message}</p>}
    </div>
  );
}
