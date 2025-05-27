Here's how to structure a **Terraform CI/CD pipeline using GitHub Actions**, where:

* **CI** (`plan`): Validates and plans the infrastructure.
* **CD** (`apply`): Applies the plan to deploy infrastructure (ideally on a protected branch like `main` or through PR approval).

---

## ✅ GitHub Actions for Terraform CI/CD

### 📁 Project Structure (example)

```
.
├── .github
│   └── workflows
│       ├── terraform-plan.yml
│       └── terraform-apply.yml
├── main.tf
├── variables.tf
├── terraform.tfvars
└── backend.tf
```

---

### 🔹 `terraform-plan.yml` (CI - Plan on PR)

```yaml
name: Terraform Plan

on:
  pull_request:
    branches:
      - main

jobs:
  terraform-plan:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.5.0

    - name: Terraform Init
      run: terraform init

    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan -out=tfplan

    - name: Upload Plan as Artifact
      uses: actions/upload-artifact@v3
      with:
        name: tfplan
        path: tfplan
```

---

### 🔹 `terraform-apply.yml` (CD - Apply on merge to main)

```yaml
name: Terraform Apply

on:
  push:
    branches:
      - main

jobs:
  terraform-apply:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.5.0

    - name: Terraform Init
      run: terraform init

    - name: Download Terraform Plan
      uses: actions/download-artifact@v3
      with:
        name: tfplan
        path: .

    - name: Terraform Apply
      run: terraform apply -auto-approve tfplan
```

---

### 🔐 Recommendations:

* Use **backend.tf** to configure remote state (e.g., Azure Storage, AWS S3).
* Use **OIDC** with GitHub Actions or store credentials in **GitHub Secrets**.
* Protect `main` branch and enable manual approvals for sensitive applies.
* Consider using `terraform workspace` for environment-specific deployments.

---

Let me know if you'd like this to be environment-specific (e.g., dev/staging/prod) or if you need examples using Azure backend.
