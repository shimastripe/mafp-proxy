@echo off

call npm install
SETLOCAL
SET PATH=node_modules\.bin;node_modules\hubot\node_modules\.bin;%PATH%

SET HUBOT_SLACK_BOTNAME=
SET HUBOT_SLACK_TEAM=
SET HUBOT_SLACK_TOKEN=

SET PORT=2000
SET HUBOT_PROXY_MODE=proxy
SET CHATBOT_URL=http://localhost:3000

node_modules\.bin\hubot.cmd %*
