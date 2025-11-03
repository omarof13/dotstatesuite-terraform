# 🚀 .Stat Suite Terraform Deployment (Azure Ubuntu VM)

This package automatically creates and configures an **Azure Ubuntu VM** with:
- Remote Desktop (xRDP + Xfce)
- Docker + Docker Compose
- Firefox preinstalled
- Cloned `.Stat Suite` demo environment
- Auto-started containers

---

## 🧰 Prerequisites (Windows Machine)

### 1️⃣ Azure CLI

Azure CLI is required to authenticate with Azure.  
You need administrator rights to install it.

#### ⚙️ Steps
1. Download manually:
   👉 [https://aka.ms/installazurecliwindows](https://aka.ms/installazurecliwindows)
2. Save the file (e.g., `AzureCLI.msi`)
3. Double-click to install Azure CLI.
4. After installation, open **PowerShell** and verify:
   ```powershell
   az version
   ```

---

### 2️⃣ Terraform

Terraform must be downloaded manually.  
Download from:
👉 [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)

Unzip `terraform.exe` and place it in **the same folder** as the Terraform files:
```
main.tf
variables.tf
outputs.tf
cloud-init.yaml
```

Verify installation:
```powershell
terraform.exe -version
```

---

### 3️⃣ Login to Azure

```powershell
az login
```

A browser window will open. Sign in with your Azure credentials (MFA supported).

---

### 4️⃣ Find Your Subscription ID

```powershell
az account list --output table
```
Copy your **SubscriptionId** and update **main.tf**:
```hcl
subscription_id = "YOUR-SUBSCRIPTION-ID-HERE"
```

---

## ⚙️ Deploy the Environment

1. Open PowerShell in the folder containing `terraform.exe`
2. Initialize Terraform:
   ```powershell
   .\terraform.exe init
   ```
3. Apply the configuration:
   ```powershell
   .\terraform.exe apply -auto-approve
   ```

⏱️ Wait about **10–15 minutes** for Azure to finish setup.  
Afterwards, Terraform displays your VM public IP:
```
Outputs:

vm_public_ip = "4.205.212.9"
```

---

## 🌐 Access the VM

### SSH
```powershell
ssh dotstatuser@<public-ip>
```

### Remote Desktop (RDP)
- Launch **Remote Desktop Connection (mstsc.exe)**
- Enter your public IP  
- Username: `dotstatuser`  
- Password: `ChangeMe123!`

In Ubuntu desktop, open Terminal and test:
```bash
docker ps
firefox &
```

---

## 🧾 Destroy the Environment

To delete all created Azure resources:
```powershell
.	erraform.exe destroy -auto-approve
```

---

**Author:** Amarof Jalal  
**Version:** November 2025  
**Environment:** Terraform + Azure CLI (Windows)
