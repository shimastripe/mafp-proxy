module.exports = (robot) ->
  robot.hear /.*/i, (res) ->
    Tool = {}
    try
      Tool = require "../proxy-script/proxy.coffee"
    catch err
      console.log err
      return res.send "proxy-script is not found..."

    # TODO Preparation of means for passing option
    options = {}
    t = new Tool options
    t.proxy res.message.text, (msg) -> res.send msg
