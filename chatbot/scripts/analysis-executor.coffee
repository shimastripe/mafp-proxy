# Description:
#   Returns the result of static code analysis
#
# Dependencies:
#   None
#
# Commands:
#   analysis <toolName> (Ex. checkstyle)
#
# Author:
#   Go Takagi

module.exports = (robot) ->

  robot.hear /analysis (.+)/, (res) ->
    toolname = res.match[1]

    Tool = {}
    try
      Tool = require "../analysis-script/#{toolname}"
    catch err
      robot.logger.error err

    options = {}
    t = new Tool options
    t.exec (msg) -> res.send msg
