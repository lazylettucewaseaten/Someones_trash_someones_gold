class UnauthenticatedError extends Error {
    constructor(message) {
      super(message);
      this.statusCode = 401; // Unauthorized
    }
  }
  
  module.exports = UnauthenticatedError;
  //Expiry Date Display
  //Host