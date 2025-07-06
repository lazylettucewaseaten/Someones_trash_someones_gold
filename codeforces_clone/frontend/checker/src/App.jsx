import React, { useState } from "react";
import "./App.css";
import QuestionTemplate from "./questiontemplate.jsx";

function App() {
  const [assignmentNo, setAssignmentNo] = useState("");
  const [questions, setQuestions] = useState([]);

  function addQuestion() {
    setQuestions([
      ...questions,
      { questionNo: "", questionText: "", inputFile: null, outputFile: null },
    ]);
  }

  function updateQuestion(index, field, value) {
    const updated = [...questions];
    updated[index] = { ...updated[index], [field]: value };
    setQuestions(updated);
  }

  function handleSubmit() {
    console.log("Assignment No:", assignmentNo);
    console.log("Questions:", questions);
  }

  return (
    <div className="app-container">
      <div className="top-bar">
        <label htmlFor="assignmentNo">Enter the assignment no.</label>
        <input
          id="assignmentNo"
          type="text"
          value={assignmentNo}
          onChange={(e) => setAssignmentNo(e.target.value)}
          placeholder="Assignment #"
        />
        <button onClick={addQuestion}>Add question</button>
      </div>

      <div className="questions-list">
        {questions.map((q, i) => (
          <QuestionTemplate
            key={i}
            index={i}
            data={q}
            onChange={updateQuestion}
            
          />
        ))}
      </div>

      {questions.length > 0 && (
        <div className="submit-btn-container">
          <button onClick={handleSubmit}>Submit</button>
        </div>
      )}
    </div>
  );
}

export default App;

// Option C: Cloud storage (e.g., AWS S3, Google Cloud Storage)
// Upload question files or JSON blobs to cloud storage buckets.

// Docker container can pull or mount files via cloud SDK or sync.

// Requires network setup inside the container to access cloud.

// Pros: Durable, scalable, accessible globally.

// Cons: More complex setup, network dependency.
