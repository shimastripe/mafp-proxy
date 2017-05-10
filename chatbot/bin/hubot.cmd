@echo off

call npm install
SETLOCAL
SET PATH=node_modules\.bin;node_modules\hubot\node_modules\.bin;%PATH%

SET HUBOT_SLACK_BOTNAME=
SET HUBOT_SLACK_TEAM=
SET HUBOT_SLACK_TOKEN=

SET PORT=3000
SET HUBOT_PROXY_MODE=chat
SET PROXYCHATBOT_URL=http://localhost:2000

SET MONGODB_URI=mongodb://localhost/local_hubot
SET GITHUB_TOKEN=
SET GITHUB_CLONE_URL=

node_modules\.bin\hubot.cmd %*
