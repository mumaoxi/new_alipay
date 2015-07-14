# coding: utf-8
require 'new_alipay'

describe NewAlipay do

  it 'alipay app pay test' do
    NewAlipay.seller_email='13366655137'
    NewAlipay.partner='2088702240557723'
    NewAlipay.key='5ze1yn7tv8ytfx0pb1r7spdnnahjksbg'


    rsa= NewAlipay.mobile_trade_create({
                                           notify_url: 'http://test.api.miliani.com/',
                                           out_trade_no: "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{Random.rand(1000)}",
                                           subject: 'test',
                                           body: 'test',
                                           total_fee: 0.01
                                       })
    puts rsa
    expect(rsa.nil?).to eq(false)
  end
end