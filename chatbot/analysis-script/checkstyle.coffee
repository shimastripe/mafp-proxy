# 1度出たエラーは返さない (file, lineno, detail一致判断)
AnalysisExecutor = require './adapter/base'
path = require "path"
exec = require('child_process').exec
Git = require "../lib/git"

CLONE_URL = process.env.GITHUB_CLONE_URL or ''
localPath = path.resolve "tmp/repository"
checkstylePath = path.resolve "checkstyle/checkstyle-7.4-all.jar"

git = new Git()

module.exports = class CheckStyleExecutor extends AnalysisExecutor
  constructor: (@options) ->
    super 'checkstyle', @options

  exec: (cb)->
    git.cloneOrOpenRepo CLONE_URL, localPath, "origin/master"
    .then =>
      options =
        cwd: localPath
        maxBuffer: 1024 * 500
    
      exec 'java -jar ' + checkstylePath + ' -c /google_checks.xml src/main/java', options, (err, stdout, stderr)=>
        console.error  err if err
        console.error  stderr if stderr
        cb stdout
    
    .catch (err)-> console.error err