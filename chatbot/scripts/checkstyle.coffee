mongoose = require '../lib/mongoose'
Checkstyle = mongoose.model 'Checkstyle'
FalsePositiveWarning = mongoose.model 'FalsePositiveWarning'

module.exports = (robot)->
