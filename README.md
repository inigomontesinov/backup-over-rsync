# 🚀 Rsync Sync Docker

This repository contains a **Docker container** that synchronizes a **remote folder** with a **local folder** using **rsync** over **SSH**.

👉 **Deletes local files that are not in the remote folder.**  
👉 **Runs automatically with cron (configurable).**  
👉 **Supports SSH key authentication.**  
👉 **Configurable with environment variables.**  

---

## 📁 Project Structure  

```
/backup-over-rsync
│── Dockerfile       # Container build
│── sync.sh          # Rsync script
│── start.sh         # Cron setup and container startup
│── .github/workflows/docker-publish.yml  # GitHub Actions for Docker Hub
│── README.md        # Documentation
```

---

## 🚀 Installation & Usage  

### 🔹 **1️⃣ Build the Docker Image**  
```bash
docker build -t backup-over-rsync .
```

### 🔹 **2️⃣ Run the Container with Custom Configuration**  
```bash
docker run -d \
  --name backup-over-rsync \
  -v ~/.ssh/id_rsa:/root/.ssh/id_rsa \   # Mount SSH key
  -v /local/folder:/local/folder \       # Mount local folder
  -e REMOTE_USER="user" \                # Remote SSH user
  -e REMOTE_HOST="192.168.1.1" \         # Remote host IP
  -e REMOTE_PATH="/remote/folder" \      # Remote folder to sync
  -e CRON_SCHEDULE="0 * * * *" \         # Run every hour
  -e ENABLE_GZIP="true"
  backup-over-rsync
```

### 🔹 **3️⃣ Check Logs**  
```bash
docker logs backup-over-rsync
```

---

## ⚙️ Environment Variable Configuration  

| Variable                 | Description                                      | Default Value       |
|-------------------------|--------------------------------------------------|---------------------|
| `REMOTE_USER`           | SSH user for remote access                      | `user`              |
| `REMOTE_HOST`           | Remote server IP or hostname                    | `192.168.1.1`       |
| `REMOTE_PATH`           | Path of the remote folder to sync               | `/remote/folder`    |
| `LOCAL_PATH`            | Path of the local folder to sync                | `/local/folder`     |
| `FINAL_DESTINATION_PATH`| Path where compressed backups will be stored    | `/local/folder`     |
| `SERVICE`               | Name of the service for backup naming           | `SERVICE`           |
| `BACKUP_ROTATION`       | Number of backups to keep before deletion       | `7`                 |
| `ENABLE_GZIP`           | Runs gzip after tar                             | `true`              |
| `CRON_SCHEDULE`         | Sync frequency in cron format                   | `0 * * * *` (hourly) |

---

## 🛠 Maintenance  

### 🔹 **Stop and remove the container**  
```bash
docker stop backup-over-rsync && docker rm backup-over-rsync
```

### 🔹 **Update the image and restart**  
```bash
docker build -t backup-over-rsync .
docker stop backup-over-rsync && docker rm backup-over-rsync
docker run -d --name backup-over-rsync [options...]
```

---

## 📌 Important Notes  
- **Ensure SSH key authentication works before running the container:**  
  ```bash
  ssh user@192.168.1.1
  ```
  If prompted for a password, add your public key to the remote server:  
  ```bash
  ssh-copy-id user@192.168.1.1
  ```

- **The `--delete` option in `rsync` will remove local files that are not in the remote folder.**  
  ⚠ **Use with caution.**  

---

## 📜 License  
This project is under the **MIT** license. Feel free to contribute! 😃  

---

🚀 **Created to simplify remote folder synchronization with Docker.**  

If you have improvements or suggestions, open an **Issue** or a **Pull Request**! 🎉

