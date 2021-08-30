#!/bin/sh

current_dir=$(pwd)
script_dir=$(dirname $0)
dir="$current_dir/$script_dir/ArgoKit Compnent.xctemplate"

path=~/Library/Developer/Xcode/Templates/File\ Templates/User\ Interface
dest_path="$path/ArgoKit Compnent.xctemplate"
if [[ -e $dest_path ]]; then
    rm -rf "$dest_path"
    if [ $? -eq 0 ]; then
        echo $dest_path" exists, remove it before renew"
    else
        echo $dest_path" exists, remove it failed"
    fi
fi

mkdir  -p "${path}" && cp -r "$dir" "$path"

if [ $? -eq 0 ]; then
   echo "✅ArgoKitCompnent  配置脚本执行成功！"
else
   echo "\033[31m❗️ArgoKitCompnent 配置脚本执行失败! \033[0m"
fi



script_dir=$(dirname $0)
dir="$current_dir/$script_dir/ArgoKit View.xctemplate"

path=~/Library/Developer/Xcode/Templates/File\ Templates/User\ Interface
dest_path="$path/ArgoKit View.xctemplate"
if [[ -e $dest_path ]]; then
    rm -rf "$dest_path"
    if [ $? -eq 0 ]; then
        echo $dest_path" exists, remove it before renew"
    else
        echo $dest_path" exists, remove it failed"
    fi
fi

mkdir  -p "${path}" && cp -r "$dir" "$path"

if [ $? -eq 0 ]; then
   echo "✅ArgoKit View   配置脚本执行成功！"
else
   echo "\033[31m❗️ArgoKitPreView 配置脚本执行失败! \033[0m"
fi
