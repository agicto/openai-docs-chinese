#!/bin/bash

set -e
set -x

echo "Hello from the script"

# 添加 Node.js 到全局环境变量
export PATH="/usr/bin:$PATH"
ln -s /usr/node/bin/node /usr/bin/node

# 添加必要的变量和路径配置
APP_NAME="openaicto"
APP_PATH="/item/openaicto"
PM2_PATH="/usr/node/bin/pm2"
PNPM_PATH="/usr/node/bin/pnpm"
NODE_PATH="/usr/node/bin/node"

# 进入项目目录
echo "Entering the project directory: $APP_PATH"
cd $APP_PATH

# 检查是否已经初始化 PM2
if $PM2_PATH status $APP_NAME | grep -q "online"; then
  echo "PM2 process $APP_NAME already running. Skipping start..."
else
  # 第一次启动，添加 Next.js 项目到 PM2
  echo "PM2 process $APP_NAME not found. Starting for the first time..."
  echo "Current PM2 processes:"
  $PM2_PATH list

  echo "Starting $APP_NAME with PM2..."
  $PM2_PATH start npm --name $APP_NAME -- start
  sleep 5 # Wait for the Next.js app to start before proceeding
  $PM2_PATH save # Synchronize the process list
fi


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

# 使用 pm2 重启应用程序
echo "Restarting $APP_NAME with PM2..."
$PM2_PATH restart $APP_NAME

echo "Script executed successfully"