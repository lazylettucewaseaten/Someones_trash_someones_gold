import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './MusicList.css';  // Optional: For custom styling

const MusicList = () => {
  // State to store fetched files
  const [files, setFiles] = useState([]);

  // Fetch files from the API on component mount
  useEffect(() => {
    axios.get('http://localhost:8000/ashley/getallfiles')
      .then((response) => {
        // Set the fetched files into state
        setFiles(response.data);
      })
      .catch((error) => {
        console.error("Error fetching files:", error);
      });
  }, []);  // Empty dependency array ensures this runs only once

  return (
    <div className="container">
      <h2>Files List</h2>
      <div className="files-container">
        {files.map((file, index) => (
          <div key={index} className="file-item">
            <img
              onClick={() => alert(`Image clicked: ${file.name}`)}
              src={`data:${file.mimetype};base64,${file.data}`}  
              alt={file.name}
              className="file-image"
            />
          </div>
        ))}
      </div>
    </div>
  );
};

export default MusicList;
