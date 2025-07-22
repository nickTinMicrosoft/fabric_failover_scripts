# Microsoft Fabric Disaster Recovery Toolkit (Exploration Only)

This repo contains **PowerShell** and **Python** scripts for **exploring disaster recovery strategies** with Microsoft Fabric workspaces and artifacts. It demonstrates how to export and import Fabric artifacts (Lakehouses, Pipelines, Dataflows, Reports, Notebooks, etc.) using the **Fabric REST API**.

> 🚨 **Important**:  
> These scripts are for **exploration/demo purposes only**.  
> They are **not intended for production use** without appropriate oversight, error handling, logging, security validation, and Microsoft support validation.

---

## 🔧 Scripts Overview

| Script                          | Language    | Purpose                                     |
|---------------------------------|-------------|---------------------------------------------|
| `Backup-All-Artifacts.ps1`      | PowerShell  | Backs up artifacts from a Fabric workspace  |
| `Restore-All-Artifacts.ps1`     | PowerShell  | Restores artifacts into a new workspace     |
| `backup_and_restore.ipynb`      | Python      | Full backup + restore automation (incl. workspace creation) |
| `delta_sync.ipynb`              | PySpark     | Performs delta data sync between lakehouses |
| `Sync-Delta.ps1`                | PowerShell  | Invokes delta sync via Spark CLI            |

---

## 📦 Artifacts Supported

These scripts currently support exporting and importing:

- ✅ Lakehouses
- ✅ Pipelines
- ✅ Dataflows
- ✅ Notebooks
- ✅ Warehouses
- ✅ Reports
- ✅ Taskflows

> 📌 Some artifacts may not be fully exportable depending on the current version of Fabric's REST API and regional availability.

---

## ⚙️ Setup

### PowerShell Prerequisites

- [Azure PowerShell module](https://learn.microsoft.com/powershell/azure/install-az-ps)
- App Registration with:
  - `Directory.Read.All`
  - `Item.Read.All` / `Item.ReadWrite.All` permissions (delegated or app)

### Python Prerequisites

- Python 3.8+
- `msal`, `requests`
- Spark (for delta sync)
- Service Principal credentials

---

## 🚀 Usage

### 1. Backup (PowerShell)

```bash
.\Backup-FabricArtifacts.ps1 `
  -TenantId "<tenant>" `
  -ClientId "<client>" `
  -ClientSecret "<secret>" `
  -SubscriptionId "<subId>" `
  -ResourceGroup "<resource-group>" `
  -WorkspaceName "<workspace-name>" `
  -Region "West US"
