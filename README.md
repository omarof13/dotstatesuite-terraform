# 🚀 .Stat Suite Terraform Deployment (Azure Ubuntu VM)

This package automatically creates and configures an **Azure Ubuntu VM** with:
- Remote Desktop (xRDP + Xfce)
- Docker + Docker Compose
- Cloned `.Stat Suite` demo environment
- Auto-started containers

---

## 🧰 Prerequisites (Windows Machine)

### 1️⃣ Terraform
You already have `terraform.exe` included in this repo.

### 2️⃣ Install Azure CLI
Run these commands in **PowerShell** (as Administrator):

```powershell
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
az version
```

### 3️⃣ Login to Azure
```powershell
az login
```

A browser window will open — sign in with your Azure credentials.

### 4️⃣ Find your subscription ID
```powershell
az account list --output table
```
Copy the `SubscriptionId` you want to use.

Then edit **main.tf** and paste it here:
```hcl
subscription_id = "YOUR-SUBSCRIPTION-ID-HERE"
```

---

## ⚙️ Deploy the Environment

1. Open PowerShell or CMD in this folder.

2. Initialize Terraform:
```powershell
terraform init
```

3. Apply the configuration:
```powershell
terraform apply -auto-approve
```

⏱️ Wait about **10–15 minutes** for Azure to create and configure the VM.

When complete, Terraform will output your public IP address:
```
Outputs:

vm_public_ip = "4.205.212.9"
```

---

## 🌐 Access the VM

### SSH
```powershell
ssh jalal@<public-ip>
```

### Remote Desktop (RDP)
- Open **Remote Desktop Connection (mstsc.exe)**
- Enter the public IP (from Terraform output)
- Username: `jalal`
- Password: `ChangeMe123!`

Once logged in, open a terminal inside Ubuntu and test:
```bash
docker ps
firefox &
```

---

## 🧾 Destroy the Environment

When you’re done testing:
```powershell
terraform destroy -auto-approve
```

This will delete all Azure resources created by Terraform.

---

**Author:** Amarof Jalal  
**Version:** November 2025
