#!/bin/bash

# Function to display help
usage() {
    echo "Usage: $0 <command>"
    echo "Commands:"
    echo "  create - Initialize and apply terraform backend configuration"
    echo "  delete - Destroy terraform backend infrastructure"
    echo "  view   - Show terraform backend state"
    exit 1
}

# Check if parameter exists
if [ $# -ne 1 ]; then
    usage
fi

# Process commands
case "$1" in
    "create")
        # Navigate to backend-setup directory
        cd backend-setup
        # Initialize and apply backend configuration
        terraform init -reconfigure
        terraform apply -auto-approve

        # Get values and save them
        BUCKET_NAME=$(terraform output -raw bucket_name)
        DYNAMO_TABLE=$(terraform output -raw dynamodb_table_name)

        # Return to root directory
        cd ..

        # Initialize main project with new backend
        terraform init -backend-config=backend.hcl -reconfigure

        echo "Backend initialized successfully!"
        echo "Bucket: $BUCKET_NAME"
        echo "DynamoDB table: $DYNAMO_TABLE"
        ;;

    "delete")
        # Navigate to backend-setup and destroy backend
        cd backend-setup
        terraform destroy -auto-approve
        cd ..

        echo "Infrastructure destroyed successfully!"
        ;;

    "view")
        # Show backend state
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
