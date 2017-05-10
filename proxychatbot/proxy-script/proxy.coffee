Rx = require 'rx'
mongoose = require '../lib/mongoose'
path = require "path"
exec = require('child-process-promise').exec
Git = require "../lib/git"

git = new Git()
CLONE_URL = process.env.GITHUB_CLONE_URL or ''
repoPath = "tmp/repository/"
localPath = path.resolve repoPath
Checkstyle = mongoose.model 'Checkstyle'
FalsePositiveWarning = mongoose.model 'FalsePositiveWarning'
Rx.Observable::promiseWait = (func) ->
  this.concatMap (x) -> func x

module.exports = class ProxyMessage
  constructor: (@options)->

  proxy: (raw, cb)->
    git.cloneOrOpenRepo CLONE_URL, localPath, "origin/master"
    .then =>
      ob = Rx.Observable.from(raw.split '\n')

      ob
      .map (raw)=> @parseCheckStyle raw
      .filter (line)-> line unless null
      .promiseWait (warning)=> @saveCurrentWarning warning
      .groupBy (x)-> x.file
      .promiseWait (grouped)=> @execGitBlame grouped.key
      .concatMap (pair)=> @parseGitBlame pair[0], pair[1]
      .reduce ((acc, x)=> @aggregate acc, x[0], x[1]), {}
      .concatMap (blameList)=> @join ob, blameList
      .promiseWait (pair)=> @isFalsePositiveWarning pair[0], pair[1]
      .filter (x)-> x[1]
      .reduce ((acc, x)=> acc += "\n\n#{@formatMessage x[0]}"), "[result]"
      .subscribe (msg)-> cb msg
    .catch (err)-> console.error err

  parseCheckStyle: (line) ->
    obj = {}
    regexp = new RegExp /\[(WARN|ERROR)\] (.*?):(\d+)(:(\d+))?: (.*) \[(.*)\]/, 'i'
    match = line.match regexp
    if match is null
      return null
    obj =
      signal: match[1]
      file: match[2].split(repoPath)[1]
      lineno: parseInt(match[3], 10)
      sub_lineno: parseInt(match[5], 10) or 0
      detail: match[6]
      type: match[7]

  saveCurrentWarning: (warning)->
    Checkstyle.update {file: warning.file, lineno: warning.lineno, sub_lineno: warning.sub_lineno, detail: warning.detail}, warning, {upsert: true}
    .then -> return warning
    .catch (err)-> console.log err

  execGitBlame: (filename)->
    options =
      cwd: localPath
      maxBuffer: 1024 * 500
    exec "git blame -f -s -n -M -C #{filename}", options
    .then (res)->
      console.error stderr if res.stder
      [filename, res.stdout]
    .catch (err)-> console.error err

  parseGitBlame: (groupKey, stdout)->
    Rx.Observable.from stdout.split '\n'
    .map (y)->
      regexp = new RegExp /(\S*)\s+(\S*)\s+(\d+)\s+(.*)/, 'i'
      d = y.match regexp
      return null unless d
      {commit: d[1], file: d[2], lineno: d[3]}
    .filter (line)-> line
    .reduce (acc, x)->
      acc.push x
      acc
    , []
    .map (arr)->
      [groupKey, arr]

  aggregate: (acc, filename, blame)->
    acc[filename] = blame
    acc

  join: (observable, blameList)->
    observable
    .map (raw)=> @parseCheckStyle raw
    .filter (line)-> line unless null
    .map (warning)->
      blame = blameList[warning.file][warning.lineno - 1]
      [warning, {commit: blame.commit, lineno: blame.lineno, file: blame.file, detail: warning.detail}]

  isFalsePositiveWarning: (warning, query)->
    FalsePositiveWarning.find query
    .then (docs)-> [warning, docs.length is 0]

  formatMessage: (msg)->
    num = "#{msg.lineno}"
    num += ":#{msg.sub_lineno}" if msg.sub_lineno isnt 0
    "[#{msg.signal}]\n#{msg.file}:#{num} [#{msg.type}]\n#{msg.detail}"
