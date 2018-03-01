# 获取账户ID
## 用法

首先 `chmod +x get_account.rb`

### 参数

* access_key
* secret_key

### 用例

`./hit.rb 'e2xxxxxx-99xxxxxx-84xxxxxx-7xxxx' 'b0xxxxxx-c6xxxxxx-94xxxxxx-dxxxx'`

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
* 交易对
* 买入价
* 卖出价
* 开始交易时间 - unix时间戳形式

unix 时间戳转换工具 http://tool.chinaz.com/Tools/unixtime.aspx

### 用例

`./hit.rb 'xxx' 'xxx' '3192742' 'btcusdt' '100.1' '120.5' '1519758090'`
