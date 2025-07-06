// questiontemplate.jsx
import React from "react";



export default function QuestionTemplate({ index, data, onChange,onRemove }) {

  const removeque=()=>{
    onRemove(index);
  };
  return (
    <div style={{ border: "1px solid #ccc", padding: 10, margin: 10 }}>
      <button onClick={removeque}>Cross</button>
      <div>Enter the question no.</div>
      <input
        value={data.questionNo}
        onChange={(e) => onChange(index, "questionNo", e.target.value)}
      />

      <div>Enter the question text</div>
      <input
        value={data.questionText}
        onChange={(e) => onChange(index, "questionText", e.target.value)}
      />

      <div>Select the input file for test_case</div>
      <input
        type="file"
        onChange={(e) => onChange(index, "inputFile", e.target.files[0])}
      />

      <div>Select the output file for test_case</div>
      <input
        type="file"
        onChange={(e) => onChange(index, "outputFile", e.target.files[0])}
      />
    </div>
  );
}
