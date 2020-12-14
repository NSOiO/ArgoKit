#!/bin/sh

current_dir=$(pwd)
script_dir=$(dirname $0)
dir="$current_dir/$script_dir/ArgoKit View.xctemplate"

path=~/Library/Developer/Xcode/Templates/File\ Templates/User\ Interface
mkdir  -p "${path}" && cp -r "$dir" "$path"

if [ $? -eq 0 ]; then
   echo "✅ArgoKitPreView 配置脚本执行成功！"
else
   echo "\033[31m❗️ArgoKitPreView 配置脚本执行失败! \033[0m"
fi
