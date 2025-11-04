# 🚀 .Stat Suite Terraform Deployment (Azure Ubuntu VM)

This package automatically creates and configures an **Azure Ubuntu VM** with:
- Remote Desktop (xRDP + Xfce)
- Docker + Docker Compose
- Firefox preinstalled
- Cloned `.Stat Suite` demo environment
- Auto-started containers

---

## 🌩️ Deploy Using Azure Portal Cloud Shell (Recommended)

Azure Cloud Shell is a browser-based environment **already pre-installed with Terraform, Azure CLI, and Git**.  
No installation or setup is required — just your Azure account.

---

### ⚙️ Steps

1. Go to the **Azure Portal**:  
   👉 [https://portal.azure.com](https://portal.azure.com)

2. Click the **Cloud Shell** icon at the top-right corner (looks like `>_`).

3. When prompted, select **Bash**.

4. The first time, Azure will ask to create a **storage account**.  
   Click **Create storage** and wait until Cloud Shell is ready.

---

### 📦 Clone the Repository

```bash
git clone https://github.com/omarof13/dotstatesuite-terraform.git
cd dotstatesuite-terraform
```

---

### 🧾 Check and Select Your Azure Subscription

List all your subscriptions:
```bash
az account list --output table
```

Check which one is currently active:
```bash
az account show --output table
```

If needed, switch to another subscription:
```bash
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
```

---

### 🛠️ Edit Your Terraform Configuration

Open `main.tf` to insert your Subscription ID:
```bash
nano main.tf
```

Find this line:
```hcl
subscription_id = "YOUR-SUBSCRIPTION-ID-HERE"
```

Replace it with your actual Subscription ID.

Save the file (Ctrl + O, then Enter) and exit (Ctrl + X).

---

### 🚀 Deploy the Environment

Initialize Terraform:
```bash
terraform init
```

Apply the configuration:
```bash
terraform apply -auto-approve
```

Terraform will display:

```
Outputs:

vm_public_ip = "4.205.212.9"
```

📝 **Note:** The VM uses **cloud-init** for automatic setup. After Terraform completes, please wait approximately **5 minutes** for cloud-init to finish configuring the machine before it will be available for RDP.

---

### 🌐 Access the VM

#### 🔹 SSH
```bash
ssh dotstatuser@<public-ip>
```

To start the .Stat Suite demo, run the following command as the dotstatuser:
```bash
~/dotstatsuite/demo/start.sh
```

**Note:** If you get a "Permission denied" error, make the script executable first:
```bash
chmod +x ~/dotstatsuite/demo/start.sh
```

#### 🔹 Remote Desktop (RDP)
1. Open **Remote Desktop Connection (mstsc.exe)** on your computer  
2. Enter the VM’s public IP  
3. Credentials:  
   - **Username:** `dotstatuser`  
   - **Password:** `ChangeMe123!`

Inside Ubuntu, you can verify services:
```bash
docker ps
firefox &
```

---

### 🧹 Destroy the Environment

When you’re done, clean up all Azure resources:
```bash
terraform destroy -auto-approve
```

---

**Repository:** [github.com/omarof13/dotstatesuite-terraform](https://github.com/omarof13/dotstatesuite-terraform)  
**Author:** Amarof Jalal  
**Version:** November 2025  
**Environment:** Azure Cloud Shell + Terraform  
