# さくらクラウドのサーバーを建てる練習
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
python3 venv venv
venv/bin/pip3 install -r requirements.txt

# 疎通確認
venv/bin/ansible -i hosts sakura_cloud -m ping
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
bundle exec kitchen converge
```
