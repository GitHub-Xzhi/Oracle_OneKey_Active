#!/bin/bash

# 定义颜色
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
cur_dir=$(pwd)

# 定义路径
log_file="/root/anti-recycling/Oracle_OneKey_Active.log"
download_file="/root/anti-recycling/vultr.com.1000MB.bin"

# Check root
[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1

# 检查log文件
if [ -f "$log_file" ]; then
    echo "日志文件存在"
else
    echo "日志文件不存在，开始创建"
    touch "$log_file"
fi

sleep 3

# 循环下载
while true; do
    sleep 3
    clear

    # Check folder
    if [ -d "/root/anti-recycling/" ]; then
        echo -e " ${green} 文件夹存在 ${plain} "
    else
        echo -e " ${green} 文件夹不存在,自动创建 ${plain} "
        mkdir /root/anti-recycling
    fi

    # Check file and download
    if [ -f "$download_file" ]; then
        echo -e " ${green} 自动清除上次残留 ${plain} "
        rm -f "$download_file"
    else
        echo -e " ${green} 无残留，开始跑网络 ${plain} "
    fi

    # 检查文件行数
    line_count=$(wc -l <"$log_file")
    # 如果文件行数大于90行，才执行删除操作
    if [ $line_count -gt 90 ]; then
        # 为了节约空间，删除日志前90行内容
        sed -i '1,90d' "$log_file"
    fi

    time=$(date "+%Y-%m-%d %H:%M:%S")
    echo "${time} Start Download " >>"$log_file"

    wget --limit-rate=10M https://nj-us-ping.vultr.com/vultr.com.1000MB.bin -O "$download_file"

    clear
    rm -f /root/nohup.out
    echo -e " ${green} 下载完成，等待2520S(42Min)继续运行 ${plain} "
    time=$(date "+%Y-%m-%d %H:%M:%S")
    echo "${time} start wait " >>"$log_file"

    # 为了节约空间，立即删除下载的文件
    rm -f "$download_file"
    sleep 2520
    time=$(date "+%Y-%m-%d %H:%M:%S")
    echo "${time} ==================== " >>"$log_file"
done
