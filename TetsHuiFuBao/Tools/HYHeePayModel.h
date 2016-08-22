//
//  HYHeePayModel.h
//  HYWebRequestDemo
//
//  Created by Jiangrx on 5/23/16.
//  Copyright © 2016 汇元网. All rights reserved.
//

#import "BaseModel.h"

@interface HYHeePayModel : BaseModel

@property (nonatomic,copy) NSString * pay_amt;
@property (nonatomic,copy) NSString * goods_name;
@property (nonatomic,copy) NSString * goods_note ;
@property (nonatomic,copy) NSString * remark;
@property (nonatomic,copy) NSString * user_ip;
@property (nonatomic,copy) NSString * pay_type;
@property (nonatomic,copy) NSString * user_identity;
@property (nonatomic,copy) NSString * version;
@property (nonatomic,copy) NSString * return_url;
@property (nonatomic,copy) NSString * notify_url;
@property (nonatomic,copy) NSString * agent_bill_time;
@property (nonatomic,copy) NSString * agent_bill_id;
@property (nonatomic,copy) NSString * goods_num;
@property (nonatomic,copy) NSString * bank_card_no;
@property (nonatomic,copy) NSString * bank_user;
@property (nonatomic,copy) NSString * cert_no;
@property (nonatomic,copy) NSString * mobile;
@property (nonatomic,copy) NSString * sign;
@property (nonatomic,copy) NSString * agent_id;
@property (nonatomic,copy) NSString * is_test; // 是否是测试环境，1测试，值为空时，不参与签名。
@property (nonatomic,copy) NSString * is_phone;// 是否是手机支付。扫码支付不用传此参数。
@property (nonatomic,copy) NSString * is_frame;//微信手机端支付是，1 使用微信公众号支付，0 WAP支付，支付宝不传次参数。

@end
