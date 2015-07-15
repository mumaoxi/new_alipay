require 'rails'
require "new_alipay/version"
require "faraday"
require 'openssl'
require 'base64'

module NewAlipay
  class << self
    attr_accessor :seller_email, :partner, :key, :rsa_private_key_path
  end
  module_function

  #移动支付：创建支付订单
  def mobile_trade_create(config)
    parameters = {
        "partner" => "\"#{self.partner}\"",
        "seller_id" => "\"#{self.seller_email}\"",
        "out_trade_no" => "\"#{config[:out_trade_no]}\"",
        "subject" => "\"#{config[:subject]}\"",
        "body" => "\"#{config[:body]}\"",
        "total_fee" => "\"#{config[:total_fee]}\"",
        "notify_url" => "\"#{config[:notify_url]}\"",
        "service" => "\"mobile.securitypay.pay\"",
        "payment_type" => "1",
        "_input_charset" => "\"utf-8\"",
        "it_b_pay" => "30m",
        "return_url" => "\"m.alipay.com\""
    }
    signing_str = parameters.inject([]) { |memo, (key, v)| memo << "#{key}=#{v}"; memo }.join("&")
    rsa_sign(signing_str)
  end

  #rsa签名
  def rsa_sign(signing_str)
    #读取私钥文件
    private_key_content = File.read(self.rsa_private_key_path || "./config/alipay/quick/key/rsa_private_key.pem")

    p private_key_content
    private_key = OpenSSL::PKey::RSA.new private_key_content
    digest = OpenSSL::Digest::SHA1.new
    sign = Base64::encode64(private_key.sign(digest, signing_str))
    signing_str+= "&sign=\"#{url_encode(sign)}\""
    signing_str+ "&sign_type=\"RSA\""
  end

  def url_encode(s)
    URI.escape(s.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

end
