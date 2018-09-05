# 意識低めのMagento2 on Docker
できるだけ手軽にMagento2の開発環境を構築する実験

## 動作環境

- [Docker](https://docs.docker.com/docker-for-mac/install/), [Docker-compose](https://docs.docker.com/compose/install/#install-compose) and [Docker-sync](https://github.com/EugenMayer/docker-sync/wiki/docker-sync-on-OSX)
- Magento ./src に展開するか `docker-sync.yml` を編集

```
    src: '/Magento/source/path' # Magentoソースディレクトリに変更
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
