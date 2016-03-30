module NewAlipay
  module BatchTrans

    #支付宝网关地址（新）
    ALIPAY_GATEWAY_NEW = 'https://mapi.alipay.com/gateway.do?'

    module_function
    # 建立请求，以表单HTML形式构造（默认）
    # @param  para_temp 请求参数数组
    # @return 提交表单HTML文本
    def submit(para_temp)
      parameters = {
          "service" => "batch_trans_notify",
          "partner" => NewAlipay.partner,
          "notify_url" => para_temp[:notify_url],
          "email" => NewAlipay.seller_email,
          "account_name" => NewAlipay.account_name,
          "pay_date" => Time.new.strftime('%Y-%m-%d'),
          "batch_no" => Time.new.strftime('%Y%m%d')+16.times.inject('') { |acc, i| acc+=('0'..'9').to_a[(i+Random.rand(1000))%10]; acc },
          "batch_fee" => para_temp[:batch_fee],
          "batch_num" => para_temp[:batch_num],
          "detail_data" => para_temp[:detail_data],
          "_input_charset" => "utf-8"
      }
      signing_str_array = parameters.inject([]) { |memo, (key, v)| memo << "#{key}=#{v}"; memo }
      sorted_signing_str_array = signing_str_array.sort! { |m, n| m.to_s <=> n.to_s }
      sign = Digest::MD5.hexdigest(sorted_signing_str_array.join('&')+NewAlipay.key)

      sorted_signing_str_array << "sign=#{sign}" << 'sign_type=MD5'

      "#{ALIPAY_GATEWAY_NEW}#{sorted_signing_str_array.join('&')}"
    end

  end
end