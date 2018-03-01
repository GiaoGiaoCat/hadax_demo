# 获取账户ID
## 用法

首先 `chmod +x get_account.rb`

### 参数

* access_key
* secret_key

### 用例

`./get_account.rb 'access key goes here' 'secret key goes here'`

返回

```
{"status":"ok","data":[{"id":3192742,"type":"spot","subtype":"","state":"working"},....]}
```

数字 **3192742** 就是下一步操作需要的 **账户ID**。

# 交易
## 用法

首先 `chmod +x hit.rb`

### 参数

依次为：

* access_key
* secret_key
* 账户ID
* 法币 - usdt/btc/eth
* 货币 - 想要购买的电子货币，例如 ht/iost/eth
* 买入价
* 卖出价
* 购买数量
* 开始交易时间 - unix时间戳形式

unix 时间戳转换工具 http://tool.chinaz.com/Tools/unixtime.aspx

### 用例

`./hit.rb 'xxx' 'xxx' '2098712' 'usdt' 'ht' '2.2725' '2.2720' 1 '1519758090'`


### screen 用法
```
screen

Hold a session open on a remote server. Manage multiple windows with a single SSH connection.

- Start a new screen session:
  screen

- Start a new named screen session:
  screen -S session_name

- Start a new daemon and log the output to screenlog.x:
  screen -dmLS session_name command

- Show open screen sessions:
  screen -ls

- Reattach to an open screen:
  screen -r session_name

- Detach from inside a screen:
  Ctrl + A, D

- Kill a detached screen:
  screen -X -S session_name quit

```
