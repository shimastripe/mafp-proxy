# mafp-proxy

Reimplementation of mafp on ChatBot as ProxyChatBot-ChatOps model.

## Installation & Usage

### ChatBot

```
$ cd chatbot
// Set the environment variables specified in Configuration
$ ./bin/hubot -a proxy
```

### ProxyChatBot

```
$ cd proxychatbot
// Set the environment variables specified in Configuration
$ ./bin/hubot -a proxy
```

## Configuration

### ChatBot

Set the environment variables specified in Configuration.

Env variable        | Description                              |                         Default | Required
------------------- | :--------------------------------------- | ------------------------------: | -------:
HUBOT_SLACK_BOTNAME | You can specify a ChatBot name.          |                           hubot |       no
HUBOT_SLACK_TEAM    | You can specify a team name in Slack.    |                                 |       no
HUBOT_SLACK_TOKEN   | The token that the Slack give you.       |                                 |      yes
PORT                | port of host server                      |                            3000 |       no
HUBOT_PROXY_MODE    | You can specify ChatBot or ProxyChatBot. |                                 |      yes
PROXYCHATBOT_URL    | You can specify a webhook URL.           |         <http://localhost:2000> |       no
MONGODB_URI         | You can specify a database uri.          | mongodb://localhost/local_hubot |       no
GITHUB_TOKEN        | The token that the GitHub give you.      |                                 |      yes
GITHUB_CLONE_URL    | You can specify a GitHub Repository URL. |                                 |      yes

### ProxyChatBot

Set the environment variables specified in Configuration.

Env variable        | Description                              |                         Default | Required
------------------- | :--------------------------------------- | ------------------------------: | -------:
HUBOT_SLACK_BOTNAME | You can specify a ChatBot name.          |                           hubot |       no
HUBOT_SLACK_TEAM    | You can specify a team name in Slack.    |                                 |       no
HUBOT_SLACK_TOKEN   | The token that the Slack give you.       |                                 |      yes
PORT                | port of host server                      |                            2000 |       no
HUBOT_PROXY_MODE    | You can specify ChatBot or ProxyChatBot. |                                 |      yes
CHATBOT_URL         | You can specify a webhook URL.           |         <http://localhost:3000> |       no
MONGODB_URI         | You can specify a database uri.          | mongodb://localhost/local_hubot |       no
GITHUB_TOKEN        | The token that the GitHub give you.      |                                 |      yes
GITHUB_CLONE_URL    | You can specify a GitHub Repository URL. |                                 |      yes
