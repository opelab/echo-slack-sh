echo-slack.sh
=================

セットアップ
---------------

### 1. make configuration file


${HOME}/.config/slack-${ORG}-${CHANNEL}.rc

```text:
URL_SLACK_WEBHOOK='Your Incoming Webhook's URL'
```

${HOME}/.config/slack-example-general.rc(sample):

```text:
URL_SLACK_WEBHOOK='https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXX/xxxxxxxxxxxxxxxxxxxxxxxx'
```


Usage
--------

```
echo "おはよう! # !/bin/sh "'```'$(env LANG=ja_JP.UTF-8 date)'```' |\
  echo-slack.sh -o example -c general -i sunrise -n "おはようshellbot"
```

