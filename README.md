# 意識低めのMagento2 on Docker
できるだけ手軽にMagento2の開発環境を構築する実験

## 動作環境

- [Docker](https://docs.docker.com/docker-for-mac/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Docker-sync](https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-OSX)
- Magento ./src に展開するか `docker-sync.yml` を編集

```
    src: '/Magento/source/path' # Magentoソースディレクトリに変更
```

- ポート番号は必要な場合は適宜修正 ホスト:コンテナの形式
```
    ports:
      - "32770:80"
```


## 使い方
- Docker-syncを起動 `docker-sync start`
- Docker-composeを起動 `docker-compose up -d`

| 項目 | 内容 |
|:--|:--|
| Database Server Host | `db` |
| Database Server Username | `root` |
| Database Server Password | なし |
| Database Name | `magento` |

- コンテナに入る
```
# docker-compose exec -u ユーザー コンテナ名 bash
docker-compose exec -u magento web bash
```

### Magento インストール

- ホスト名、ポート番号、管理者ログイン情報は適宜修正

```
php bin/magento setup:install --base-url=http://magento2.test:32770/ --db-host=db --db-name=magento --db-user=root --admin-firstname=Magento --admin-lastname=User --admin-email=user@example.com --admin-user=admin --admin-password=admin123 --language=ja_JP --currency=JPY --timezone=Asia/Tokyo --use-rewrites=1 --backend-frontname=admin
```

### セッションとキャッシュにredisを使用するよう設定

```
php bin/magento setup:config:set --session-save=redis --session-save-redis-host=redis-session --session-save-redis-log-level=3 --session-save-redis-db=0
php bin/magento setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-db=0
php bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1
```