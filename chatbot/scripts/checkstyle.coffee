path = require "path"
Git = require "../lib/git"
exec = require('child_process').exec
mongoose = require '../lib/mongoose'
Checkstyle = mongoose.model 'Checkstyle'
FalsePositiveWarning = mongoose.model 'FalsePositiveWarning'
repoPath = "tmp/repository"
localPath = path.resolve repoPath

module.exports = (robot)->

  robot.hear /ignore (\S*) (\S*)$/, (res) ->
    file = res.match[1]
    lineno = parseInt res.match[2].split(':')[0]
    sub_lineno = parseInt res.match[2].split(':')[1] or 0

    options =
      cwd: localPath
      maxBuffer: 1024 * 500

    exec "git blame -f -s -n -M -C -L #{lineno},+1 #{file}", options, (err, stdout, stderr)->
      console.error err if err
      console.error stderr if stderr

      d = stdout.split ' ', 3

      Checkstyle.find {file: file, lineno: lineno, sub_lineno: sub_lineno}
      .then (docs) ->
        return res.send "`#{file} #{lineno}` is not warned" if docs.length is 0

        fpw =
          commit: d[0]
          file: d[1]
          lineno: parseInt(d[2], 10)
          detail: docs[0].detail

        FalsePositiveWarning.update {file: fpw.file, lineno: fpw.lineno, detail: fpw.detail}, fpw, {upsert: true}, (err) ->
          return console.log err if err
          res.send "register `#{file} #{lineno}` in false-positive alert list"
