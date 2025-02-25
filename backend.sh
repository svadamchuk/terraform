#!/bin/bash

# Функция для вывода справки
usage() {
    echo "Usage: $0 <command>"
    echo "Commands:"
    echo "  create - Initialize and apply terraform backend configuration"
    echo "  delete - Destroy terraform backend infrastructure"
    echo "  view   - Show terraform backend state"
    exit 1
}

# Проверка наличия параметра
if [ $# -ne 1 ]; then
    usage
fi

# Обработка команд
case "$1" in
    "create")
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
        ;;

    "delete")
        # переходим в backend-setup и уничтожаем бэкенд
        cd backend-setup
        terraform destroy -auto-approve
        cd ..

        echo "Infrastructure destroyed successfully!"
        ;;

    "view")
        # Показываем состояние бэкенда
        echo -e "\nBackend infrastructure state:"
        cd backend-setup
        terraform show
        cd ..
        ;;

    *)
        echo "Error: Invalid command '$1'"
        usage
        ;;
esac
