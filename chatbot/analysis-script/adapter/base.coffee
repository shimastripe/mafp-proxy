module.exports = class AnalysisExecutor
  constructor: (@name, @options={})->
    @url = "/tool/#{@name}"

  exec: (cb)->
    http.post @url, @options, (req, res)=>
    cb req.body