    #!/bin/bash

    # source ./.env
    source "$(dirname "$0")/.env"

    # Now you can access the variables directly
    echo "Subnet: $SUBNET"
    echo "Gateway: $GATEWAY"
    echo "Parent: $PARENT"