echo-slack.js
=================

セットアップ
---------------

### 1. make configuration file


${HOME}/.config/slack-${ORG}-${CHANNEL}.rc

```text:
exports.url        = "Your Incoming Webhook's URL";
```

conf.js(sample):

```text:
URL_SLACK_WEBHOOK='https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/xxxxxxxxxxxxxxxxxxxxxxxx'
```


Usage
--------

```
echo "おはよう! # !/bin/sh "'```'$(env LANG=ja_JP.UTF-8 date)'```' |\
  echo-slack.sh -o example -c general -i sunrise -n "おはようshellbot"
```

