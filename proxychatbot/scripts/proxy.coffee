module.exports = (robot) ->
  robot.hear /.*/i, (res) ->
    res.send res.message.text
