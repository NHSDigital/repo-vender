#! /bin/bash

clear && terraform plan -out main.tfplan
terraform apply main.tfplan
