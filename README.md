# Repository Template

Vending GitHub for a programme.

[vending.yml](vending/vending.yml)

```bash
gh auth login
```

```bash
clear && terraform plan -out main.tfplan
terraform apply main.tfplan
```

To upgrade to be able to destroy repos

```bash
 BROWSER=false gh auth refresh -h github.com -s delete_repo
```
