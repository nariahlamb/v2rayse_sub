#!/bin/zsh

# 提供你的 Gist 页面 URL
ORI_GIST_URL="https://gist.github.com/ye4241/1c93c56cd514a757cb8239b52bae3c68"

gist_url=$ORI_GIST_URL
regex="https://gist.github.com/([^/]+)/([^/]+)"
if [[ $gist_url =~ $regex ]]; then
  username="${BASH_REMATCH[1]}"
  gist_id="${BASH_REMATCH[2]}"
else
  echo "Invalid Gist URL"
  exit 1
fi

# 下载Gist页面的HTML内容
html_content=$(curl -s "$gist_url")

# 提取所有的raw文件链接
raw_links=$(echo "$html_content" | grep 'href=' | grep "$username" | grep "$gist_id" | sed -n 's/.*href="\([^"]*\).*/\1/p' | grep '\.yaml$' | sed 's/^/https:\/\/gist.githubusercontent.com/')

sub_url=$(echo $raw_links | grep '\.yaml$')
echo "raw gist url: $sub_url"

# 拼接完整的raw文件URL并打印
echo "$raw_links" | while read -r line ; do
  echo $(basename $line .yaml)
  echo "$line"
done
