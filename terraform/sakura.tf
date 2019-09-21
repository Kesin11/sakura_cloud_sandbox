# 対象ゾーンを指定
provider sakuracloud {
  zone = "is1b" # 石狩
  # token  = "your API token" # from ENV SAKURACLOUD_ACCESS_TOKEN
  # secret = "your API secret" # from ENV SAKURACLOUD_ACCESS_TOKEN_SECRET
}

# 公開鍵(さくらのクラウド上で生成)
resource "sakuracloud_ssh_key_gen" "key" {
  name = "coupon_test"
}

# 生成した秘密鍵をローカルマシン上に保存
resource "local_file" "private_key" {
  content  = "${sakuracloud_ssh_key_gen.key.private_key}"
  filename = "id_rsa_sakura_cloud"

  # パーミッションの調整
  provisioner "local-exec" {
    command = "chmod 600 ${self.filename}"
  }
}

# パブリックアーカイブ(OS)のID参照用のデータリソース定義
data "sakuracloud_archive" "ubuntu" {
  os_type = "ubuntu"
}

# ディスク定義
resource "sakuracloud_disk" "disk01" {
  name              = "disk01"
  plan              = "ssd"
  size              = 40
  source_archive_id = "${data.sakuracloud_archive.ubuntu.id}"

  tags              = ["terraform"]
}

# サーバー定義
resource "sakuracloud_server" "server01" {
  name  = "server01"
  core = 2
  memory = 2
  disks = ["${sakuracloud_disk.disk01.id}"]

  ssh_key_ids     = ["${sakuracloud_ssh_key_gen.key.id}"]
  disable_pw_auth = true

  tags = ["terraform", "ubuntu"]
}

# サーバへのSSH接続を表示するアウトプット定義
output "ssh_to_server" {
  value = "ssh -i ${local_file.private_key.filename} ubuntu@${sakuracloud_server.server01.ipaddress}"
}