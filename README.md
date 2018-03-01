# 获取账户ID
## 用法

首先 `chmod +x get_account.rb`

### 参数

* access_key
* secret_key

### 用例

`./get_account.rb 'e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx' 'b0xxxxxx-c6xxxxxx-94xxxxxx-dxxxx'`

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
