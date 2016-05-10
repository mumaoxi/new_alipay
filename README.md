# NewAlipay

支付宝快捷支付+支付宝批量付款

## Status
代码 已经打包发布到 RubyGems.

[![image](https://ruby-china-files.b0.upaiyun.com/photo/5982eaaa64f467d9dbda03ad4f40ea27.png)](https://rubygems.org/gems/new_alipay)


## Installation

Add this line to your application's Gemfile:


```ruby
gem 'new_alipay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install new_alipay

## Usage

###移动支付
####配置文件
将以下代码写入`config/initializers/new_alipay.rb`
```ruby
NewAlipay.seller_email='133xxxxyyyy'
NewAlipay.partner='2088xxxxxxxxxx'
NewAlipay.key='324234kuwerwerwerweewxxxxxxx'
```
####创建订单
```ruby
rsa= NewAlipay.mobile_trade_create({
                                           notify_url: 'http://test.yourserver.com/',
                                           out_trade_no: "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{Random.rand(1000)}",
                                           subject: 'test',
                                           body: 'test',
                                           total_fee: 0.01
                                       })
#=>输出创建的支付订单的签名字符串
```
####校验参数(RSA方式)
```ruby
result = NewAlipay.verify_rsa?({
                                       discount: "0.00",
                                       payment_type: 1,
                                       subject: '100元购买90天（送100元话费）',
                                       trade_no: "20150715000010007900xxxxxx",
                                       buyer_email: "152xxxxwwww",
                                       gmt_create: '2015-07-15 14:36:09',
                                       notify_type: 'trade_status_sync',
                                       quantity: 1,
                                       out_trade_no: '20150715143551584527',
                                       seller_id: '2088xxxxxxxxx',
                                       notify_time: '2015-07-15 14:36:09',
                                       body: '100元购买90天（送100元话费）',
                                       trade_status: 'TRADE_FINISHED',
                                       is_total_fee_adjust: 'N',
                                       total_fee: 0.01,
                                       gmt_payment: '2015-07-15 14:36:09',
                                       seller_email: "133xxxxyyyy",
                                       gmt_close: '2015-07-15 14:36:09',
                                       price: 0.01,
                                       buyer_id: "208870xxxxxxyyyyy",
                                       notify_id: "60f9sd2a318ds12a44165a056xxxxxxx",
                                       use_coupon: 'N',
                                       sign_type: 'RSA',
                                       sign: "xxxxx/yygiAQo9Ey4JkdGSUV+F1xxxxM2Z3pA5C32423cZZjEPiLEURGZpSQ="
                                   })
puts "\nverify:#{result}\n"
#=>true
```

###批量付款
####配置文件
将以下代码写入`config/initializers/new_alipay.rb`
```ruby
NewAlipay.seller_email='133xxxxyyyy'
NewAlipay.partner='2088xxxxxxxxxx'
NewAlipay.key='324234kuwerwerwerweewxxxxxxx'
NewAlipay.account_name='xxxx公司/你的真实姓名'
```
####批量付款（获取url）
```ruby

 request_url = NewAlipay::BatchTrans.submit({
                                           notify_url: 'http://test.yourserver.com/callback',
                                           batch_fee: 0.01,
                                           batch_num: 1,
                                           detail_data: "#{NewAlipay::BatchTrans.random_trade_no(26)}^152xxxxyyyy^某某^0.01^测试支付"

                                       })
```
####验证付款结果
```ruby
request_result = NewAlipay::BatchTrans.verify_notify?({
                                                      _input_charset: 'utf-8',
                                                      batch_fee: 0.01,
                                                      account_name: 'xxxx公司',
                                                      partner: '208890xxxxyyyy',
                                                      batch_no: '20160331xxxxxx',
                                                      sign: 'bc98542c95d33b08752qweq2a1ce162c8d',
                                                      detail_data: '201603316694019891235827213^152xxxxyyyy^xxxx^0.01^测试支付&email=yyyyxxx@qq.com&notify_url=http://test.yourserver.com/',
                                                      pay_date: '2016-03-31',
                                                      batch_num: 1,
                                                      service: 'batch_trans_notify',
                                                      sign_type: 'MD5'
                                                  })
puts request_result
#=>true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/new_alipay/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
