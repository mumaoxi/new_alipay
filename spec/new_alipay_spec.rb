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

  it 'verify rsa' do
    result = NewAlipay.verify_rsa?({
                                       discount: "0.00",
                                       payment_type: 1,
                                       subject: '100元购买90天（送100元话费）',
                                       trade_no: "2015071500001000790060999348",
                                       buyer_email: "15201280641",
                                       gmt_create: '2015-07-15 14:36:09',
                                       notify_type: 'trade_status_sync',
                                       quantity: 1,
                                       out_trade_no: '20150715143551584527',
                                       seller_id: '2088702240557723',
                                       notify_time: '2015-07-15 14:36:09',
                                       body: '100元购买90天（送100元话费）',
                                       trade_status: 'TRADE_FINISHED',
                                       is_total_fee_adjust: 'N',
                                       total_fee: 0.01,
                                       gmt_payment: '2015-07-15 14:36:09',
                                       seller_email: "13366655137",
                                       gmt_close: '2015-07-15 14:36:09',
                                       price: 0.01,
                                       buyer_id: "2088702589222795",
                                       notify_id: "60f971a318cda430a44165a0560f33fb6e",
                                       use_coupon: 'N',
                                       sign_type: 'RSA',
                                       sign: "c8aFTwlc286JxXOWpZVCNQZfVuzE19gtbuiTXjRj9gTSHM825zFLRiKkaRxRszGK9oFcNzwigDTlKSs9LacpgHA8p5pzqttpl0VT0E/giAQo9Ey4JkdGSUV+F1GFZNtdYUyQusXuP101lmJuuUMM2Z3pA5CcZZjEPiLEURGZpSQ="
                                   })
    puts "\nverify:#{result}\n"

    expect(result).to eq(true)
  end
end