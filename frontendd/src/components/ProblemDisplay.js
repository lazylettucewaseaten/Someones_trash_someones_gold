import React, { useEffect, useState } from 'react';

function formatTime(seconds) {
  if (seconds < 0) return 'Expired';
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  const s = seconds % 60;
  return `${h}h ${m}m ${s}s`;
}

export default function ProblemDisplay({ problem }) {
  const [timeLeft, setTimeLeft] = useState(null);

  useEffect(() => {
    if (!problem) return;

    const interval = setInterval(() => {
      const diff = new Date(problem.endTime) - new Date();
      setTimeLeft(Math.floor(diff / 1000));
    }, 1000);

    return () => clearInterval(interval);
  }, [problem]);

  if (!problem) return <p>No active problem</p>;

  return (
    <div className="border p-4 rounded shadow">
      <h2 className="text-xl font-semibold mb-2">Active Problem</h2>
      <p>
        <strong>Contest:</strong> {problem.contestId} - Problem {problem.index}
      </p>
      <p>
        <strong>Time left:</strong> {formatTime(timeLeft)}
      </p>
      <a
        href={`https://codeforces.com/contest/${problem.contestId}/problem/${problem.index}`}
        target="_blank"
        rel="noreferrer"
        className="text-blue-600 underline"
      >
        View Problem on Codeforces
      </a>
    </div>
  );
}
