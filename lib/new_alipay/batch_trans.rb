module NewAlipay
  module BatchTrans

    #支付宝网关地址（新）
    ALIPAY_GATEWAY_NEW = 'https://mapi.alipay.com/gateway.do?'

    #HTTPS形式消息验证地址
    HTTPS_VERIFY_URL = 'https://mapi.alipay.com/gateway.do?service=notify_verify&'

    # HTTP形式消息验证地址
    HTTP_VERIFY_URL = 'http://notify.alipay.com/trade/notify_query.do?'

    module_function

    #返回随机交易密码
    def random_trade_no(length=26)
      Time.new.strftime('%Y%m%d')+(length-8).times.inject('') { |acc, i| acc+=('0'..'9').to_a[(i+Random.rand(1000))%10]; acc }
    end

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
          "batch_no" => random_trade_no(24),
          "batch_fee" => para_temp[:batch_fee],
          "batch_num" => para_temp[:batch_num],
          "detail_data" => para_temp[:detail_data],
          "_input_charset" => "utf-8"
      }
      signing_str_array = parameters.inject([]) { |memo, (key, v)| memo << "#{key}=#{v}"; memo }
      sorted_signing_str_array = signing_str_array.sort! { |m, n| m.to_s <=> n.to_s }
      sign = Digest::MD5.hexdigest(sorted_signing_str_array.join('&')+NewAlipay.key)

      sorted_signing_str_array << "sign=#{sign}" << 'sign_type=MD5'

      yield parameters.symbolize_keys.merge({:sign => sign, :sign_type => 'MD5'}) if block_given?

      "#{ALIPAY_GATEWAY_NEW}#{sorted_signing_str_array.join('&')}"
    end

    #params.except(*request.env.keys.push(:route_info))
    # @param post_params 除去系统变量的参数
    def verify_notify?(post_params)
      verifing_sign = Digest::MD5.hexdigest(post_params.reject { |p| [:sign, :sign_type].include?(p) }
                                                .inject([]) { |memo, (key, v)| memo << "#{key}=#{v}"; memo }
                                                .sort! { |m, n| m.to_s <=> n.to_s }.join('&')+NewAlipay.key)
      verifing_sign == post_params[:sign]

      begin
        conn = Faraday.new(:url => 'https://mapi.alipay.com') do |faraday|
          faraday.request :url_encoded # form-encode POST params
          faraday.response :logger # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        end
        response = conn.get '/gateway.do', {:service => 'notify_verify', partner: NewAlipay.partner, notify_id: post_params[:notify_id]}
        response.body.to_s == 'true'
      rescue Exception => e
        false
      end
    end
  end
end