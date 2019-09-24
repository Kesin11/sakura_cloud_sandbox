# さくらクラウドのサーバーを建てる練習 + renovate セルフホスティング
## terraform
さくらクラウドのサーバーをterraformで構築する。  
パケットフィルタだけはterraformで構築後にwebから設定。

```
cd terraform
terraform apply
```

自動生成された秘密鍵の `id_rsa_sakura_cloud` がterraform/以下に保存される

## ansible
構築したサーバーのプロビジョニング

Pythonのvenvでインストールするansibleから実行する

```
# HostName sakura_cloudを作成してterraformのipアドレスを登録しておく
vim ~/.ssh/config

# ansibleの用意
python3 -m venv venv
venv/bin/pip3 install -r requirements.txt

# 疎通確認
venv/bin/ansible -i hosts sakura_cloud -m ping

# 本番はubuntuユーザー、test-kitchenではkitchenユーザーとして実行する
# そのため事前にサーバーにsshしてsudoresの設定をしておく
ssh ubuntu@sakura_cloud -i terraform/id_rsa_sakura_cloud
# ssh先で以下のsudoers設定を作成する
$ sudo visudo -f /etc/sudoers.d/ubuntu
```
ubuntu	ALL=(ALL) NOPASSWD: ALL
```

# 実行
venv/bin/ansible-playbook -i hosts playbook.yml --private-key=terraform/id_rsa_sakura_cloud
```

## test-kitchen
playbookのテスト

本物のサーバーではなく、dockerコンテナに対して実行する

```
# test-kitchenをセットアップ
bundle install --path=vendor
# 実行
bundle exec kitchen test -d never
```

## renovate セルフホスティング
see: https://github.com/renovatebot/renovate/blob/master/docs/development/self-hosting.md

セルフホスティング用のconfig.js追加と、まだalpha版のruby gemsに対応するためワークアラウンドを入れたDockerfileを自前で用意しています。  
ruby gemsについては詳しくはDockerfileを参照。

```bash
# build
docker build -t my/renovate:latest .

# run
docker run -e=RENOVATE_TOKEN=${GITHUB_AUTH_TOKEN} my/renovate
```