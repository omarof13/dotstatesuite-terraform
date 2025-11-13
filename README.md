# 🚀 .Stat Suite Terraform Deployment (Azure Ubuntu VM)

This package automatically creates and configures an **Azure Ubuntu VM** with:
- Remote Desktop (xRDP + Xfce)
- Docker Engine + Docker Desktop GUI
- Firefox preinstalled
- Cloned `.Stat Suite` demo environment
- Ready-to-run containers and tools

---

## 🌩️ Deploy Using Azure Portal Cloud Shell (Recommended)

Azure Cloud Shell is a browser-based environment **already pre-installed with Terraform, Azure CLI, and Git**.  
No installation or setup is required — just your Azure account.

---

### ⚙️ Steps

1. Go to the **Azure Portal**:  
   👉 https://portal.azure.com

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

Save the file (`Ctrl + O`, then `Enter`) and exit (`Ctrl + X`).

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

Terraform will display something like:

```text
Outputs:

vm_public_ip = "4.205.212.9"
```

---

## ⏱️ Wait for Cloud-Init to Finish (via SSH)

Before using Remote Desktop, you must wait for **cloud-init** to fully configure the VM.

1. From your local machine, open a terminal and SSH into the VM:

   ```bash
   ssh dotstatuser@<VM_PUBLIC_IP>
   ```

   Default password:
   ```text
   ChangeMe123!
   ```

2. Once connected, check cloud-init status:

   ```bash
   cloud-init status
   ```

   Repeat (or use `cloud-init status --wait`) until it shows:

   ```text
   status: done
   ```

3. When cloud-init is done, reboot the VM:

   ```bash
   sudo reboot
   ```

   Your SSH session will disconnect. Wait a short moment for the VM to restart.

After this reboot, the environment (Docker groups, KVM, Docker Desktop, etc.) is fully ready for your first graphical login.

---

## 🌐 Access the VM via Remote Desktop (RDP)

1. Open **Remote Desktop Connection (mstsc.exe)** on your computer.  
2. Enter the VM’s public IP (`vm_public_ip` from Terraform output).  
3. Credentials:
   - **Username:** `dotstatuser`  
   - **Password:** `ChangeMe123!`

Inside the XFCE desktop environment, you’ll find:
- **Firefox** for browsing  
- **Terminal** ready for Docker and Git commands  

---

## 🐳 Starting Docker Desktop GUI

Once logged in via RDP into the XFCE session:

1. Open the XFCE **Applications** menu.
2. Go to **Development**.
3. Click **Docker Desktop**.

On the **first launch**, Docker Desktop will:

- Prompt you to **accept the license agreement** — click **Accept**.  
- Ask to **sign in or create a Docker account** — you can **skip this step** by closing the dialog.

After a few seconds, the **Docker Desktop whale icon** will appear in the XFCE taskbar.  
You can then manage containers from the Docker Desktop GUI or through the CLI.

---

## 📊 Running the .Stat Suite Demo

Navigate to the cloned demo directory:

```bash
cd ~/dotstatesuite/demo
./start.sh
```

This command starts all required services and initializes the local `.Stat Suite` demo environment.

---

### 🧩 First-Time Initialization

After the initial startup completes, enter the **SFS (Structure File Store)** container to initialize the schema index:

```bash
docker exec -it sfs bash
yarn dist:schema
exit
```

Once done, your environment is fully ready for use!

---

## 🧹 Destroy the Environment

When you’re done, clean up all Azure resources:

```bash
terraform destroy -auto-approve
```

---

**Repository:** https://github.com/omarof13/dotstatesuite-terraform  
**Author:** Amarof Jalal  
**Version:** November 2025  
**Environment:** Azure Cloud Shell + Terraform
