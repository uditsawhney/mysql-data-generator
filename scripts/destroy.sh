#!/bin/bash

# Delete Kind cluster
echo "Deleting Kind cluster..."
kind delete cluster --name mysql-data-generator

echo "Destroy complete!"
