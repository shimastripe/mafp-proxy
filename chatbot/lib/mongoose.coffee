MONGODB_URI = process.env.MONGODB_URI
unless MONGODB_URI?
  return console.log 'Required MONGODB_URI env.'

mongoose = require 'mongoose'

if mongoose.connection.readyState is 0
  mongoose.connect(MONGODB_URI)
  console.log "Mongodb connected."

  mongoose.Promise = global.Promise
  mongoose.model 'Checkstyle', {signal: String, file: String, lineno: Number, sub_lineno: Number, detail: String, type: String}
  mongoose.model 'FalsePositiveWarning', {commit: String, file: String, lineno: Number, detail: String}

module.exports = mongoose
