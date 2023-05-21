#!/bin/bash

# This Azure CLI script helps prepare everything you need to run Terraform in GitHub Actions. It Sets up:

    # Storage Account and Container to store Terraform State remotely.
    # Creates a Service Principal and then assigns contributor at tenant root. Note: you may wish to reduce this scope for your deployment down to single Subscriptions etc!
    # Please change the variables to suit your requirements!
 
az login


########################################
# Set the below
########################################

export location="uksouth"                                           # This sets the Resource Group and Storage Account location.
export rgname="example-rg-name"                                              # This sets the Resource Group name the Storage Account will be deployed into.
export strname="oowghexample"                                  # This sets the Storage Account name - note this must be unique!
export containername="tfstate"                                      # This sets the Container name.
export envtag="Environment=TFStorage"                               # This sets the Environment Tag applied to the Resource Group and Storage Account.
export spname="tfdeploy"                                            # This sets the Service Principal Name
# Below Subscription should be the Management Subscription
export mansub="xxxx-xxxx-xxxx-xxxx-xxxx"                # This is the ID of the Subscription to deploy the Resource Group and Storage Account into. 

########################################

# Creates Resource Group and Storage Account for TF State File Storage
az account set -s $mansub
az group create --location $location --name $rgname --tags $envtag 
az storage account create --location $location --resource-group $rgname --name $strname --tags $envtag --https-only --sku Standard_LRS --encryption-services blob --subscription $mansub
export storageacckey=$(az storage account keys list --resource-group $rgname --account-name $strname --query '[0].value' -o tsv)
az storage container create --name $containername --account-name $strname --account-key $storageacckey

# Creates Service Principal for TF to use and gives access at root. 
export spid= az ad sp create-for-rbac -n $spname --role Owner --scopes  /subscriptions/$mansub

########################################
# Information to setup GitHub Secrets and Terraform backend configuration is output by the script below. 
########################################
Write-Output "
Below are the details of the storage account that will need to be in the Terraform Backend Configuration:
Resource Group: $rgname
Storage Account: $strname
Container Name: $containername

Below are the details of the Service Principal that will need to be in the GitHub Repo Secrets:
ARM_CLIENT_ID: "$spid.appid"
ARM_CLIENT_SECRET: "$spid.password"
ARM_TENANT_ID: "$spid.tenant"
ARM_SUBSCRIPTION_ID: $mansub"