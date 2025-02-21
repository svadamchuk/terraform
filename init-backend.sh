#!/bin/bash

# Переходим в директорию backend-setup
cd backend-setup

# Инициализируем и применяем конфигурацию бэкенда
terraform init -reconfigure
terraform apply -auto-approve

# Получаем значения и сохраняем их
BUCKET_NAME=$(terraform output -raw bucket_name)
DYNAMO_TABLE=$(terraform output -raw dynamodb_table_name)

# Возвращаемся в корневую директорию
cd ..

# Инициализируем основной проект с новым бэкендом
terraform init -backend-config=backend.hcl -reconfigure

echo "Backend initialized successfully!"
echo "Bucket: $BUCKET_NAME"
echo "DynamoDB table: $DYNAMO_TABLE"
