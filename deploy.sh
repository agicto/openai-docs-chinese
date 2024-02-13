#!/bin/bash

set -e
set -x

echo "Hello from the script"

# 添加 Node.js 到全局环境变量
export PATH="/usr/bin:$PATH"

# Check if the current shell is zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
  # Switch to zsh within a subshell
  (
    exec zsh

    echo "Hello from zsh"

    # Check if the symbolic link already exists
    if [ ! -e /usr/bin/node ]; then
      # Create the symbolic link
      ln -s /usr/node/bin/node /usr/bin/node
    else
      echo "Symbolic link /usr/bin/node already exists. Skipping ln."
    fi

  )  # End of subshell
else
  echo "Already in zsh. Skipping switch and commands."
fi

# 添加必要的变量和路径配置
APP_NAME="openaicto"
APP_PATH="/item/openaicto"
PM2_PATH="/usr/node/bin/pm2"
PNPM_PATH="/usr/node/bin/pnpm"
NODE_PATH="/usr/node/bin/node"

# 进入项目目录
echo "Entering the project directory: $APP_PATH"
cd $APP_PATH

# 切换到主分支
echo "Switching to the main branch..."
git checkout main

# 拉取最新代码
echo "Pulling the latest code from the main branch..."
git pull origin main

# 使用 pnpm 安装依赖
echo "Installing dependencies with pnpm..."
$PNPM_PATH install

# 使用 pnpm 构建项目
echo "Building the project with pnpm..."
$PNPM_PATH run build

# 检查 PM2 是否已经启动应用程序
echo "Checking if $APP_NAME is already running with PM2..."
if $PM2_PATH show $APP_NAME > /dev/null 2>&1; then
  echo "$APP_NAME is already running. Restarting with PM2..."
  $PM2_PATH restart $APP_NAME
else
  echo "$APP_NAME is not running. Starting with PM2..."
  $PM2_PATH start npm --name "$APP_NAME" -- start
fi


echo "Script executed successfully"
