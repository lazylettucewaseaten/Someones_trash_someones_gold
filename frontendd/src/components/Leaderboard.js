export default function Leaderboard({ leaderboard }) {
  if (!leaderboard.length) {
    return <p>No users found.</p>;
  }

  return (
    <div>
      <h2 className="text-xl font-semibold mb-2">Leaderboard</h2>
      <ul>
        {leaderboard.map(({ handle, totalSolved, hasSolvedActive }) => (
          <li
            key={handle}
            className={`mb-1 ${hasSolvedActive ? 'text-green-600 font-semibold' : ''}`}
          >
            <strong>{handle}</strong> — Problems solved: {totalSolved}
          </li>
        ))}
      </ul>
    </div>
  );
}
