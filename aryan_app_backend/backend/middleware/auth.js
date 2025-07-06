const jwt = require('jsonwebtoken');
const UnauthenticatedError = require('../errors/UnauthenticatedError'); // Use your custom error class

const authenticationMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;

  // Check if the Authorization header is missing or malformed
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next(new UnauthenticatedError('No token provided'));
  }

  const token = authHeader.split(' ')[1]; // Split by space and take the token part

  try {
    // Verify the token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    // console.log('Decoded Token:', decoded);
    res.send({email:decoded.email})
    next();
  } catch (error) {
    console.error('Token verification failed:', error);
    return next(new UnauthenticatedError('Not authorized to access this route'));
  }
};

module.exports = authenticationMiddleware;
