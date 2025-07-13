#!/bin/bash
set -e

echo "🚀 Setting up Ubuntu development environment..."

# Error handling - with more verbose output
trap 'echo "❌ Error occurred at line $LINENO. Exit code: $?"; echo "Command: $BASH_COMMAND"' ERR

# Add verbose output
set -x

# Git configuration
echo "📝 Configuring Git..."
git config --global core.editor "vim" || true
git config --global init.defaultBranch main || true

# Install additional development tools that were moved from Dockerfile
echo "🔧 Installing development tools..."
sudo apt-get update && sudo apt-get install -y \
    jq \
    mysql-client \
    php php-cli php-fpm php-mbstring php-xml php-bcmath php-json php-mysql php-zip php-curl \
    composer || echo "     ⚠️  Some packages failed to install"

# Install Node.js via nvm
echo "📦 Installing Node.js..."
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"

# Download and install nvm
echo "   - Downloading nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Load nvm - with explicit error handling
echo "   - Loading nvm..."
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
    echo "   - nvm loaded successfully"
else
    echo "   - ❌ nvm.sh not found at $NVM_DIR/nvm.sh"
    exit 1
fi

if [ -s "$NVM_DIR/bash_completion" ]; then
    source "$NVM_DIR/bash_completion"
fi

# Add nvm to bashrc if not already present
if ! grep -q "NVM_DIR" ~/.bashrc; then
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
fi

# Install and use Node.js LTS
echo "   - Installing Node.js LTS..."
if command -v nvm >/dev/null 2>&1; then
    nvm install --lts
    nvm use --lts
    nvm alias default node
    
    # Install Yarn
    npm install -g yarn
    
    # Verify Node.js installation
    echo "   - Node.js version: $(node --version)"
    echo "   - npm version: $(npm --version)"
    echo "   - Yarn version: $(yarn --version)"
else
    echo "   - ❌ nvm command not found"
    exit 1
fi

# Install CLI tools with error handling
echo "🤖 Installing development CLI tools..."

# Check if npm is available
if command -v npm >/dev/null 2>&1; then
    echo "   - npm is available, proceeding with installations..."
    
    # Install Claude Code CLI
    echo "   - Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code || echo "     ⚠️  Claude Code CLI not available or requires authentication"

    # Install other development tools
    echo "   - Installing other development tools..."
    npm install -g typescript prettier eslint || echo "     ⚠️  Some tools failed to install"
else
    echo "   - ❌ npm not available, skipping CLI tool installations"
fi

# Create workspace directories
echo "📁 Setting up workspace..."
mkdir -p ~/workspace/projects
mkdir -p ~/workspace/scripts

# Setup logging
echo "📊 Setting up logging..."
mkdir -p /workspace/devcontainer_ubuntu/.devcontainer/logs || true
touch /workspace/devcontainer_ubuntu/.devcontainer/logs/setup.log || true
chmod 666 /workspace/devcontainer_ubuntu/.devcontainer/logs/setup.log || true
echo "$(date): Development container setup started" >> /workspace/devcontainer_ubuntu/.devcontainer/logs/setup.log || true

# Install Python packages
echo "🐍 Installing Python packages..."
if command -v pip3 &> /dev/null; then
    pip3 install --user requests pytest black flake8 || echo "     ⚠️  Some Python packages failed to install"
else
    echo "     ⚠️  pip3 not found, skipping Python packages"
fi

# Add motd script to bashrc if not already present
if ! grep -q "source /etc/profile.d/motd.sh" ~/.bashrc; then
    echo 'source /etc/profile.d/motd.sh' >> ~/.bashrc
fi

# Final message
echo ""
echo "✅ Ubuntu development environment setup complete!"
echo "🎉 Installed tools:"
echo "   - Node.js ($(node --version 2>/dev/null || echo 'Not installed'))"
echo "   - npm ($(npm --version 2>/dev/null || echo 'Not installed'))"
echo "   - Yarn ($(yarn --version 2>/dev/null || echo 'Not installed'))"
echo "   - Claude Code CLI ($(claude --version 2>/dev/null || echo 'Not available'))"
echo "   - PHP ($(php --version 2>/dev/null | head -1 || echo 'Not installed'))"
echo "   - Composer ($(composer --version 2>/dev/null || echo 'Not installed'))"
echo "   - MySQL client"
echo "   - Development tools (TypeScript, ESLint, Prettier)"
echo "   - Python development tools"
echo ""
echo "⚠️  Note: Some CLI tools may require additional authentication or may not be publicly available."

# Log completion
echo "$(date): Development container setup completed successfully" >> /workspace/devcontainer_ubuntu/.devcontainer/logs/setup.log || true

# Exit successfully
exit 0
