## 用法

`chmod +x hit.rb`

### 参数

* access_key
* secret_key
* 交易对
* 买入价
* 卖出价
* 开始交易时间 - unix时间戳形式

unix 时间戳转换工具 http://tool.chinaz.com/Tools/unixtime.aspx

### 用例

`./hit.rb 'xxx', 'xxx', 'btcusdt', '100.1', '120.5', '1519758090'`


## Client 代码相关参数

* Client 的 status 参数状态为 0 和 1。0 代表可以买入，1 代表可以卖出。
* symbol_pair 交易对，例如：'btcusdt'
* bid_price 买入价，例如："100.1"
* ask_price 买入价，例如："100.1"
