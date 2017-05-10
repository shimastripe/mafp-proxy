urljoin = require 'url-join'
jokeList = (require '../data/joke').joke_list
replyList = (require '../data/joke').reply_list

ADDRESS = process.env.HEROKU_URL or 'http://localhost:8080'

class Util
  constructor: ->

  # static
  @getPath = (path...)->
    urljoin ADDRESS, path...

module.exports = Util
