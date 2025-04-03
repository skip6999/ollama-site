

# === CONFIG ===
GIT_USER="skip6999"
REPO_NAME="ollama-site"              # change this to your real repo name
TOKEN="ghp_yourActualTokenHere"    # replace with your real token
PROJECT_PATH="/home/jnsn549/ollama_site"
LOG_FILE="$PROJECT_PATH/.pushlog"

# === START ===

# Fix ownership if root-owned (permission rescue)
echo "🔧 Checking and fixing file permissions..."
sudo chown -R $USER:$USER "$PROJECT_PATH"
echo "📦 Preparing Git repo for push..."

# Make sure the path exists
mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH" || { echo "❌ Failed to enter project directory"; exit 1; }

# Initialize if not already
if [ ! -d ".git" ]; then
    git init
    echo "✅ Initialized empty Git repo"
fi

# Drop a default .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
    cat <<EOL > .gitignore
__pycache__/
*.pyc
*.log
.env
certs/
postgres_data/
backups/
static/
*.sqlite3
*.db
.vscode/
.idea/
.DS_Store
EOL
    echo "📄 Created default .gitignore"
fi

# Drop a default README if it doesn't exist
if [ ! -f "README.md" ]; then
    cat <<

![GitHub Repo stars](https://img.shields.io/github/stars/$GIT_USER/$REPO_NAME?style=social)
![GitHub last commit](https://img.shields.io/github/last-commit/$GIT_USER/$REPO_NAME)
![GitHub license](https://img.shields.io/github/license/$GIT_USER/$REPO_NAME)
EOF > README.md
# $REPO_NAME

This project is auto-deployed using a Git-powered bash script from `$PROJECT_PATH`.

🛠️ Managed by: $GIT_USER
🚀 Pushed with love and coffee.
🗓️ Initialized on: $(date '+%Y-%m-%d')
EOF
    echo "📘 Created default README.md"
fi

# Add remote
REMOTE_URL="https://$GIT_USER:$TOKEN@github.com/$GIT_USER/$REPO_NAME.git"
git remote remove origin 2>/dev/null
git remote add origin "$REMOTE_URL"
echo "🔗 Remote set to: $REMOTE_URL"

# Add and commit
git add .
COMMIT_MSG="Initial commit"
git commit -m "$COMMIT_MSG" || echo "ℹ️ Nothing to commit (maybe already committed)"

# Set default branch and push
git branch -M main
git push -u origin main

# Log the push

# Log WiFi SSID + signal strength if available
SSID=$(iwgetid -r)
SIGNAL=$(grep "$SSID" /proc/net/wireless | awk '{print int($3)}')
if [ -n "$SSID" ]; then
    echo "📶 Connected to SSID: $SSID with signal: $SIGNAL dBm" >> "$LOG_FILE"
fi
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$TIMESTAMP] $COMMIT_MSG pushed to $REPO_NAME on branch main" >> "$LOG_FILE"

# Create or update CHANGELOG.md
CHANGELOG_FILE="$PROJECT_PATH/CHANGELOG.md"
LATEST_HASH=$(git rev-parse --short HEAD)
echo -e "## $(date '+%Y-%m-%d')
- Commit: $LATEST_HASH - $COMMIT_MSG" >> "$CHANGELOG_FILE"
echo "📝 CHANGELOG updated"

# Victory message
echo -e "🖖 Logical push complete, Captain.\n🗂️ Push log saved to $LOG_FILE\n🚀 Project live at: https://github.com/$GIT_USER/$REPO_NAME"

# Hold terminal open (optional for GUI users)
read -p "👀 Press enter to close..."
