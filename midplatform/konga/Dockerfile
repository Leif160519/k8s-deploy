FROM pantsel/konga:latest

# 设置工作目录（容器内路径）
WORKDIR /app

# 直接安装最新 pg 驱动（无需 package.json）
RUN npm install pg@latest --save
