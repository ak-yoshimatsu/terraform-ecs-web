# ECS × FastAPI Terraform

FastAPI アプリケーションを ECS Fargate で動かすための Terraform コードです。

## 構成

```
Internet
    │
    ▼ HTTP:80
  [ ALB ]
    │
    ▼ HTTP:8080
[ ECS Fargate ]（プライベートサブネット）
    │
    ▼
  [ ECR ]（イメージ取得）
```

## リソース一覧

| モジュール | 作成されるリソース |
|-----------|------------------|
| network   | VPC、パブリック/プライベートサブネット（各2AZ）、IGW、NAT GW、ルートテーブル |
| alb       | ALB、ターゲットグループ（IPタイプ）、リスナー、ALB用SG |
| security  | ECSタスク用SG（ALBからのポート8080のみ許可） |
| ecr       | ECRリポジトリ |
| ecs       | ECSクラスター、タスク定義、サービス、IAMロール、CloudWatch Logsグループ |

## 事前準備

1. AWS CLIのセットアップ
   ```bash
   aws configure
   ```

2. ECRへのDockerイメージのプッシュ
   Terraformを `apply` 後、出力される `ecr_repository_url` に対してイメージをプッシュしてください。

   ```bash
   # ECRにログイン
   aws ecr get-login-password --region ap-northeast-1 | \
     docker login --username AWS --password-stdin <ecr_repository_url>

   # イメージをビルド・タグ付け・プッシュ
   docker build -t fastapi-container .
   docker tag fastapi-container:latest <ecr_repository_url>:latest
   docker push <ecr_repository_url>:latest
   ```

## 使い方

```bash
# 初期化
terraform init

# 変更内容の確認
terraform plan

# デプロイ
terraform apply

# 削除
terraform destroy
```

## 動作確認

```bash
# ALBのDNS名を確認
terraform output alb_dns_name

# APIにアクセス
curl http://<alb_dns_name>/
curl http://<alb_dns_name>/hello/world
```

## 注意事項

- NAT Gatewayは各AZに1台ずつ（計2台）作成されるため、起動中は費用が発生します
- 動作確認後は `terraform destroy` でリソースを削除してください
