<?php
	
	$seller_id = "13366655137";
	$partner = "2088702240557723";
	$key = "5ze1yn7tv8ytfx0pb1r7spdnnahjksbg";

	$data.= "&partner=\"$partner\"";
	$data.= "&notify_url=\"".urlencode("http://test.api.miliani.com/")."\"";
	$data.= "&service=\"mobile.securitypay.pay\"";
	$data.= "&_input_charset=\"UTF-8\"";
	$data.= "&payment_type=\"1\"";
	$data.= "&seller_id=\"$seller_id\"";
	$data.= "&it_b_pay=\"3h\"";

	//读取私钥文件
    $priKey = file_get_contents("config/alipay/quick/key/rsa_private_key.pem");

    //转换为openssl密钥，必须是没有经过pkcs8转换的私钥
    $res = openssl_get_privatekey($priKey);

    //调用openssl内置签名方法，生成签名$sign
    openssl_sign($data, $sign, $res);

    //释放资源
    openssl_free_key($res);

    //base64编码
    $sign = base64_encode($sign);

    $data.= "&sign=\"".urlencode($sign)."\"";
    $data.= "&sign_type=\"RSA\"";
?>