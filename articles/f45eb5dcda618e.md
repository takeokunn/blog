---
title: "aws-for-fluent-bitのログ1件のデータサイズが大きいと分割されてしまう問題の調査と解決"
emoji: "😎"
type: "tech"
topics:
  - "aws"
  - "firelens"
  - "fluentbit"
published: true
published_at: "2022-12-11 05:33"
publication_name: "openlogi"
---

この記事は、[OPENLOGIアドベントカレンダー2022 11日目](https://qiita.com/advent-calendar/2022/openlogi)の記事です。

いきなり宣伝なのですが、近日イベントあるので是非是非参加してください。

————————————
【オープンロジイベント情報】
<12/15(木)19:30〜>
「CTO・VPoEぶっちゃけトーク！　〜失敗から学ぶエンジニア組織論〜」
過去の失敗談をセキララに語りつつ、オープンロジでどんな組織をつくっていくかが語られる予定なので、ご都合合う方は是非ご参加ください！
https://openlogi.connpass.com/event/265230/
————————————

11月くらいからお世話になっており、主にSREの仕事と基盤開発などをさせてもらっています。

今回は業務で問題になった「aws-for-fluent-bitのログ1件のデータサイズが大きいと分割されてしまう問題」について、自分なりに調査深堀したことについて纏めていこうと思います。

## TL;DR

aws-for-fluent-bitのmultiline filterのpartial_message modeを使ったら解決した。
https://github.com/aws-samples/amazon-ecs-firelens-examples/tree/mainline/examples/fluent-bit/filter-multiline-partial-message-mode

## 経緯

弊社ではメインのサービスをEC2で動かしているのだが、10年もののシステムなので肥大化しています。

マイクロサービス化(というのかはわからないが)を進めており、「認証周り」や「通知周り」などシステムの切り出しをしていて、どんどんECSへ移行するべく準備をしているところです。
マイクロサービス化をするにあたって重要になってくるのは「ロギング周り」というのは想像に難くないと思います。どのコンテナからどういうログが流れてきたのかを色付けする必要が出てきます。

AWS FireLensを導入すると非常に簡単にECSからのログにメタ情報を付与することができます。

[詳解 FireLens – Amazon ECS タスクで高度なログルーティングを実現する機能を深く知る](https://aws.amazon.com/jp/blogs/news/under-the-hood-firelens-for-amazon-ecs-tasks/)

![](https://storage.googleapis.com/zenn-user-upload/5e33832f4514-20221211.png)

ECSのlog driverの記述を `awsfirelens` にして向け先を指定だけで導入が完了するので便利ですね。
ただ、fluent-bit(fluentd)について書かれているのだが、AWS FireLens自体がしているのは「ECSのログをよしなにメタ情報を付加してよしなに流す」ということだけなので注意が必要です。
また、FireLensではAWSが用意してくれていること以上のことはできなく、2022/12現在はlogにその他の情報を付与することができないです。(要確認)

雑図ですが、弊社では以下のような構成にしています。

![](https://storage.googleapis.com/zenn-user-upload/2bce60837faa-20221211.png)

図のfluent-bitとはaws-for-fluent-bitのことなので注意。

error logは直接fluent-bitに流しつつ、middleware含めcontainer内の標準出力は全て一度FireLensを経由して自前のfluent-bitに流すようにしています。
error logをFireLensに流さないのは、FireLensではtag付けができなかったり不便なのでlaravelから直接fluent-bitに送るようにしています。

## 今回の問題

大きめのstdoutをFireLensに流した上でfluent-bitで受け取ると、fluent-bitでは分割された状態で受け取ってしまうという問題がありました。

[AWS ECS on Fargate + FireLens で大きなログが扱いやすくなった話 - DeNA ENGINEERING](https://engineering.dena.com/blog/2022/08/firelens/)でも同じ問題を取り上げています。

> FireLens を通じてコンテナのログをルーティングする場合、16 KB 以上のログは分割された状態でログルーティング用のコンテナに到達します。構造化ログを実現するためにアプリケーションが JSON などの形式でログを出力している場合、ログを分割される前の状態に復元する必要があります。

つまり、16KB以上のlogを流すと分割されてしまうということです。

実際に手元で再現する手順は以下です。
「16KBの0 + "hello"」という文字列を流してみると確かに分割されていることが確認できます。

docker-compose.yml:
```yaml
version: '3'

services:
  app:
    image: busybox
    command: sh -c 'sleep 1; printf "%016384dHello\n" 0'
    logging:
      driver: fluentd
      options:
        fluentd-async: 'true'
  fluent-bit:
    image: public.ecr.aws/aws-observability/aws-for-fluent-bit:stable
    ports:
      - 24224:24224
    command: timeout 2 /fluent-bit/bin/fluent-bit --quiet -i forward -o stdout
```

command:
```
$ docker compose up | grep fluent-bit
fluent-bit-sandbox-fluent-bit-1  | [0] 8fa1f8d7ac2c: [1670702182.000000000, {"partial_ordinal"=>"1", "partial_last"=>"false", "container_id"=>"8fa1f8d7ac2c0e432d1f97a5cc2f5c8b6724a1ea359bf24fa7349143215de0c3", "container_name"=>"/fluent-bit-sandbox-app-1", "source"=>"stdout", "log"=>"0000000000/* 中略 */00000000000", "partial_message"=>"true", "partial_id"=>"4f4ed3edcee8aee2e7c552179df0b857a5f04ac71f95d74ded99b0801bc56ac8"}]
fluent-bit-sandbox-fluent-bit-1  | [1] 8fa1f8d7ac2c: [1670702182.000000000, {"partial_message"=>"true", "partial_id"=>"4f4ed3edcee8aee2e7c552179df0b857a5f04ac71f95d74ded99b0801bc56ac8", "partial_ordinal"=>"2", "partial_last"=>"true", "container_id"=>"8fa1f8d7ac2c0e432d1f97a5cc2f5c8b6724a1ea359bf24fa7349143215de0c3", "container_name"=>"/fluent-bit-sandbox-app-1", "source"=>"stdout", "log"=>"Hello"}]
```

## aws-for-fluent-bitとは

aws-for-fluent-bitとはawsが提供しているfluent-bit docker imageのことです。

ECRからもDockerHubからも落とすことが出来ることができます。
https://gallery.ecr.aws/aws-observability/aws-for-fluent-bit
https://hub.docker.com/r/amazon/aws-for-fluent-bit

中身としては、fluent-bitをベースにaws integrationを盛り込んだimageを作っているものです。
https://github.com/aws/aws-for-fluent-bit/blob/mainline/Dockerfile

READMEにも記述がありますが、fluent-bitをforkしたものではないので、fluent-bitとaws-for-fluent-bitにはversionには大きく乖離があります。
2022年12月はfluent-bitは1.9.10だが、aws-for-fluent-bitは2.29.0です。
https://github.com/aws/aws-for-fluent-bit#versioning-faq

## 解決方法

aws側もこの問題を認識しているようで対応策を用意してくれています。

```conf
[FILTER]
    name                  multiline
    match                 *
    multiline.key_content log
    # partial_message mode is incompatible with option multiline.parser
    mode                  partial_message
```
https://github.com/aws-samples/amazon-ecs-firelens-examples/tree/mainline/examples/fluent-bit/filter-multiline-partial-message-mode

`partial_message` を使えるのは `v2.24.0` からなので古いイメージを使っていると使えないが、今のaws-for-fluent-bitの最新が `v2.29.0` なのでstableを使っておけば問題ないでしょう。

https://github.com/aws/aws-for-fluent-bit/releases/tag/v2.24.0

```shell
$ docker run --platform=linux/amd64 --rm 600171456083.dkr.ecr.ap-northeast-1.amazonaws.com/fraise/notification/fluent-bit:stable

AWS for Fluent Bit Container Image Version 2.25.1Fluent Bit v1.9.3
* Copyright (C) 2015-2022 The Fluent Bit Authors
* Fluent Bit is a CNCF sub-project under the umbrella of Fluentd
* https://fluentbit.io
```

aws-for-fluent-bitの対応というよりは実際のところはfluent-bitの対応であり、コードリーディングまではできていませんが、多分このPRで対応をしてくれているんだと思います。
https://github.com/fluent/fluent-bit/pull/5285

## おわりに

fluent-bitやFireLensについて触ったことが今まで無かったので非常に良い機会でした。
自分のlogging周りの知見の少なさや、fluent-bitやFire Lensの可能性について知れました。
fluent-bit自体のコードを追いきれてないので引き続きコードリーディングをしていきたいと思います。