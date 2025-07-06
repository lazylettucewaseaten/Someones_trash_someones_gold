import React, { useState, useEffect } from 'react';
import io from 'socket.io-client';

const socket = io('http://localhost:8000'); // Connect to the server (defaults to localhost:3000)

const ChatApp = () => {
  const [user, setUser] = useState('');
  const [message, setMessage] = useState('');
  const [messages, setMessages] = useState([]);

  // Handle incoming messages
  useEffect(() => {
    // Listen for previous messages from the server
    socket.on('previousMessages', (messages) => {
      setMessages(messages);
    });

    // Listen for new messages from the server
    socket.on('newMessage', (message) => {
      console.log('New message received:', message);  // For debugging
      setMessages((prevMessages) => [...prevMessages, message]);
    });

    // Cleanup the socket connection on component unmount
    return () => {
      socket.off('previousMessages');
      socket.off('newMessage');
    };
  }, []);

  const sendMessage = () => {
    if (user && message) {
      // Emit the new message to the server
      socket.emit('newMessage', { user, content: message });
      setMessage(''); // Clear the message input
    }
  };

  return (
    <div>
      <h1>WebSocket Chat</h1>

      <div>
        <input
          type="text"
          placeholder="Your name"
          value={user}
          onChange={(e) => setUser(e.target.value)}
        />
      </div>

      <div>
        <textarea
          placeholder="Type a message"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
        />
      </div>

      <button onClick={sendMessage}>Send</button>

      <ul id="messages" style={{ listStyleType: 'none', padding: 0 }}>
        {messages.map((msg, index) => (
          <li key={index} style={{ marginBottom: '10px' }}>
            {msg.user}: {msg.content}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ChatApp;
