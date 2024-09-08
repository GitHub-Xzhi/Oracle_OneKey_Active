#!/bin/bash

# 定义颜色
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
cur_dir=$(pwd)

# Vultr 在全球有 15 个数据中心，大家可以通过以下的测试链接来检测以下，自己所在区域使用哪个数据中心速度最快。
# test_link="https://fra-de-ping.vultr.com/vultr.com.1000MB.bin"  # 法兰克福（德国)
# test_link="https://par-fr-ping.vultr.com/vultr.com.1000MB.bin"  # 巴黎（法国)
# test_link="https://ams-nl-ping.vultr.com/vultr.com.1000MB.bin"  # 阿姆斯特丹（荷兰）
# test_link="https://lon-gb-ping.vultr.com/vultr.com.1000MB.bin"  # 伦敦（英国）
# test_link="https://nj-us-ping.vultr.com/vultr.com.1000MB.bin"  # 纽约（美国）
# test_link="https://il-us-ping.vultr.com/vultr.com.1000MB.bin"  # 芝加哥（美国）
# test_link="https://ga-us-ping.vultr.com/vultr.com.1000MB.bin"  # 亚特兰大（美国）
# test_link="https://fl-us-ping.vultr.com/vultr.com.1000MB.bin"  # 迈阿密（美国）
# test_link="https://tx-us-ping.vultr.com/vultr.com.1000MB.bin"  # 达拉斯（美国）
# test_link="https://wa-us-ping.vultr.com/vultr.com.1000MB.bin"  # 西雅图（美国）
# test_link="https://sjo-ca-us-ping.vultr.com/vultr.com.1000MB.bin"  # 硅谷（美国）
test_link="https://lax-ca-us-ping.vultr.com/vultr.com.1000MB.bin"  # 洛杉矶（美国）
# test_link="https://syd-au-ping.vultr.com/vultr.com.1000MB.bin"  # 悉尼（澳大利亚）
# test_link="https://hnd-jp-ping.vultr.com/vultr.com.1000MB.bin"  # 东京（日本）
# test_link="https://sgp-ping.vultr.com/vultr.com.1000MB.bin"  # 新加坡

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
    # 如果文件行数大于270行，才执行删除操作
    if [ $line_count -gt 270 ]; then
        # 为了节约空间，删除日志前90行内容
        sed -i '1,90d' "$log_file"
    fi

    time=$(date "+%Y-%m-%d %H:%M:%S")
    echo "${time} Start Download " >>"$log_file"

    wget --limit-rate=10M "$test_link" -O "$download_file"

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
