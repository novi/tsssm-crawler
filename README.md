# tsssm-crawler

[![Build Status](https://travis-ci.org/novi/tsssm-crawler.svg?branch=master)](https://travis-ci.org/novi/tsssm-crawler)

(Japanese version is available.)

[Tokyo Server-Side Swift Meetup #4](http://tokyo-ss-swift.connpass.com/event/33727/) のデモコードです。

## 準備 (OS X)

ローカル環境にMySQL(MariaDB)が必要です。

```sh
$ brew install mariadb
$ mysql.server start 
```

で起動できます。デモのプログラムのMySQLの接続先設定は[これ](https://github.com/novi/tsssm-crawler/blob/master/Sources/CrawlerConfig/Config.swift)になっています。(Homebrewで入れた場合多分デフォルト)

このRSSクローラーを動かすには、データベースとテーブルが必要になるのでそれぞれ作っておきます。

```sh
$ mysql -u root -e "CREATE DATABASE IF NOT EXISTS crawler_demo DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_bin;"
$ mysql -u root でコンソールにログインして以下の3テーブルを作成
```

```sql
USE crawler_demo;
```

```sql
CREATE TABLE `articles` (
  `article_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `rss_id` int(10) unsigned NOT NULL,
  `title` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `link` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `guid` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `description` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `published_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`article_id`),
  UNIQUE KEY `guid_uni` (`guid`(200))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
```

```sql
CREATE TABLE `collect_status` (
  `rss_id` int(11) unsigned NOT NULL,
  `latest_status` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `error_message` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `latest_status_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `next_updates` datetime NOT NULL DEFAULT '2001-01-01 00:00:00',
  PRIMARY KEY (`rss_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
```

```sql
CREATE TABLE `rss` (
  `rss_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `url` mediumtext COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rss_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
```

## ビルドと実行方法

Swift 3のSnapshot DEVELOPMENT-SNAPSHOT-2016-06-06-a に対応しています。swiftenvを使うとSnapshotのバージョンを切り替えられるので便利です。

```sh
$ swiftenv install DEVELOPMENT-SNAPSHOT-2016-06-06-a
$ swiftenv global DEVELOPMENT-SNAPSHOT-2016-06-06-a
```

makeでビルドします。

```
$ cd tsssm-crawler
$ make
```

サーバー側で走らせるクローラーは

```
$ .build/debug/RSSCrawler
```

で実行します。

Xcodeでは、クローラーの実行とデバッグ、ビューワーの実行とデバッグができます。 `TSSSMCrawler.xcworkspace` を開いてください。

テストは

```
$ mysql -u root -e "CREATE DATABASE IF NOT EXISTS test DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_bin;"
$ make test
```

で走ります。( `test` という名前のデータベースが必要なので最初に作っておく) 

Xcodeでも `CrawlerBase` というスキーマを選択してテスト(⌘U)が実行できます。

### 使い方

このデモには

* RSSCrawler (サーバー側で実行するデーモン)
* RSSManager (Macで動く管理App)

があります。 `RSSCrawler` はデーモンなので常に起動しておきます。

`RSSManager` を立ち上げてみましょう。初期状態では登録しているRSSが空なので一つ追加してみます。(現状はRSS2形式のみ対応)

Newを押して、[Yahooニュース](http://headlines.yahoo.co.jp/rss/list)のRSSを一つ追加してみましょう。

```
Title: Yahoo! ニュース トピックストップ
URL: http://news.yahoo.co.jp/pickup/rss.xml
```

`RSSCrawler` が裏で動いていれば、数秒でRSSの内容が読み込まれてデータベースに保存されます。

今追加したRSSを選択してShow Articlesで記事が表示されるはずです。
