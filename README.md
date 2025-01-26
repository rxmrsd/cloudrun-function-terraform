# はじめに

Cloud FunctionsからリブランドされたCloud Run Functionを，Terraformを用いて利用した際，少しトリッキーなことをしたので記載します．おそらく今後対応されるかと思います．
Cloud FunctionsがCloud Runに統合されたことにより，Direct VPC Egressを使用したVPC接続をすることができるようになりました．
リブランディングにより，Cloud Runの持つ以下の特徴を活用できるようになりました．

- Direct VPC Egressによるプライベートネットワーク接続
- リクエスト駆動型の自動スケーリング

個人的には，従来のCloud Run ServiceとCloud Functionsのいいとこ取りをした印象です．

# お題

今回は，内部接続のみを許可したCloud Run Serviceに，Cloud Run Functionがアクセスするケースを想定します．このとき，Cloud Run FunctionがDirect VPC Egress経由でアクセスする場合を考えます．構成図としては以下です．

![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3618319/0b9616cf-3cc6-13e3-7a90-0acb21065fb4.png)


# ※コンソール上では簡単に実現可能
コンソール上で，Cloud Run Functionで，Direct VPC Egressを有効にすることは簡単に実現できます．


![image.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3618319/cd9b7cd8-c7c3-1d61-4347-1dfda46e2eec.png)


# Terraformはまだ非対応

コンソール上で，上記の構成を実現することは容易にできました．しかし，これをTerraformに書き起こす際,少しひねりを加えなければ実現できませんでした．

Direct VPC Egressに接続する設定が，まだTerraformにはリリースされておりませんでした．対応としては，Terraform実行の内部でgcloudコマンドを実行するようにしています．


```terraform
resource "null_resource" "function-1-vpc-egress" {
  depends_on = [module.cloud_function_v2]

  triggers = {
    detached = "false"
    reapply = module.cloud_function_v2.function_uri
  }

  provisioner "local-exec" {
    command = <<-EOT
      gcloud beta run services update ${var.function_name} \
      --network=${var.network_name} \
      --subnet=${var.direct_subnet_name} \
      --network-tags=function-1 \
      --vpc-egress all-traffic  \
      --region ${var.region}
    EOT
  }
}
```


# 結果


```bash
curl -X GET https://asia-northeast1-${project_id}.cloudfunctions.net/function-v2
```
```bash
{"response":{"backend_status":"ok"},"status":"success"}
```


# まとめ

Cloud Run FunctionとDirect VPC Egressを組み合わせたアーキテクトを構築する際，Terraformでは少しひねりを加える必要がありました．将来的には以下のようなパラメータが対応されると予想しています．

```terraform
resource "google_cloudfunctions2_function" "v2" {
  vpc_access{
    egress = "ALL_TRAFFIC"
    network_interfaces {
      network = "default"
      subnetwork = "default"
      tags = ["tag1", "tag2", "tag3"]
    }
  }
}

```


今回使用したコードは[こちら](https://github.com/rxmrsd/cloudrun-function-terraform)に公開しています．



# 参考
- [Cloud Functions is now Cloud Run functions — event-driven programming in one unified serverless platform](https://cloud.google.com/blog/products/serverless/google-cloud-functions-is-now-cloud-run-functions?hl=en)
- [hashicorp issue](https://github.com/hashicorp/terraform-provider-google/issues/16076)