# 意識低めのMagento2 on Docker v2.4
できるだけ手軽にMagento2の開発環境を構築する実験
参考: [Magento2.4 - 開発環境構築手順書](https://claves.notepm.jp/page/34d8cac0c1)

## 動作環境

- [Docker](https://docs.docker.com/docker-for-mac/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Mutagen Compose](https://github.com/mutagen-io/mutagen-compose)
- Magento `.env` を編集して `APP_PATH` と一致させる

```
APP_PATH=./src # Magentoソースディレクトリに変更
```

- ポート番号は必要な場合は適宜修正 ホスト:コンテナの形式
```
    ports:
      - "32770:80"
```


## 使い方
- Mutagen-Composeを起動 `mutagen-compose up -d`

| 項目 | 内容 |
|:--|:--|
| Database Server Host | `db` |
| Database Server Username | `root` |
| Database Server Password | なし |
| Database Name | `magento` |

- コンテナに入る
```
# mutagen-compose exec -u ユーザー コンテナ名 bash
mutagen-compose exec -u magento web /bin/bash
mutagen-compose exec -u root web /bin/bash
```

### Magento インストール

- ホスト名、ポート番号、管理者ログイン情報は適宜修正

```
php bin/magento setup:install \
--base-url=http://magento2.test:32770/ \
--db-host=db \
--db-name=magento \
--db-user=root \
--admin-firstname=Magento \
--admin-lastname=User \
--admin-email=example@claves.co.jp \
--admin-user=admin \
--admin-password=Passw0rd! \
--language=ja_JP \
--currency=JPY \
--timezone=Asia/Tokyo \
--use-rewrites=1 \
--backend-frontname=momoadmin \
--search-engine=elasticsearch8 \
--elasticsearch-enable-auth=1 \
--elasticsearch-username=elastic \
--elasticsearch-host=https://es01 \
--elasticsearch-port=9200 \
--elasticsearch-password=PleaseChangeMe 
```

### セッションとキャッシュにredisを使用するよう設定

```
php bin/magento setup:config:set --session-save=redis --session-save-redis-host=redis-session --session-save-redis-log-level=3 --session-save-redis-db=0
php bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-db=0
php bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1
```