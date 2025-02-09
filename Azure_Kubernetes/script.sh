#!/bin/sh

# This is the shell script for creating AKS cluster, ACR Repo and a namespace
#Create Resource Group

AKS_RESOURCE_GROUP=im-dev-cc-aks-rg
AKS_REGION=canadacentral
# Set Cluster Name

AKS_CLUSTER=im-dev-aks-cluster

# set ACR name

ACR_NAME=imdevacr89
echo $AKS_RESOURCE_GROUP, $AKS_REGION, $AKS_CLUSTER, $ACR_NAME

# Create Resource Group

az group create --location ${AKS_REGION} --name ${AKS_RESOURCE_GROUP} || { echo "Failed to create resource group"; exit 1; }

# Create AKS cluster with two worker nodes

az aks create --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --node-count 2 --generate-ssh-keys || { echo "Failed to create AKS cluster"; exit 1; }

# Create Azure Container Registry

az acr create --resource-group ${AKS_RESOURCE_GROUP} --name ${ACR_NAME} --sku Standard --location ${AKS_REGION} || { echo "Failed to create ACR"; exit 1; }

#Providing required permission for downloading Docker image from ACR into AKS Cluster

az aks update -n ${AKS_CLUSTER} -g ${AKS_RESOURCE_GROUP} --attach-acr ${ACR_NAME} || { echo "Failed to attach ACR to AKS cluster"; exit 1; }

# Configure Kube Credentials

az aks get-credentials --name ${AKS_CLUSTER}  --resource-group ${AKS_RESOURCE_GROUP} || { echo "Failed to get AKS credentials"; exit 1; }

# Create a namespace in AKS cluster for Helm deployment

kubectl create namespace helm-deployment || { echo "Failed to create namespace"; exit 1; }