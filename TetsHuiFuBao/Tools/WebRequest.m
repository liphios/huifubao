//
//  WebRequest.m
//  HeePaySDKDemo
//
//  Created by Jiangrx on 6/30/14.
//  Copyright (c) 2014 Jiangrx. All rights reserved.
//

#import "WebRequest.h"

#import "HYHeePayModel.h"
#import "ViewController.h"
#import "HYTestXMLParse.h"
#import <CommonCrypto/CommonDigest.h>

#define kVersion            @"2" // 表示新接口版本 ，“1”： 表示旧接口版本 。
#define  kPayInitURL        @"https://pay.heepay.com/Phone/SDK/PayInit.aspx"
#define  kQueryURL          @"https://pay.heepay.com/Phone/SDK/PayQuery.aspx"
#define  kSignKey           @"1BF2FF57A4C941CCA39D8A09" // 测试密钥，部署到正式环境下，务必替换。
#define  kAgentId           @"1664502" //测试商户号，部署到正式环境下，务必替换。

@interface WebRequest ()

@property (nonatomic,copy)NSString * agent_bill_id;

@end

@implementation WebRequest


//判断是否为空
- (BOOL)isNullOrEmpty:(NSString *)str
{
    if (!str) {
        return YES;
    }
    else if ([str isEqual:[NSNull null]]){
        
        return YES;
    }
    else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

-(NSString *)getSystemTimeString
{
    NSDate * data = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * timeString = [formatter stringFromDate:data];
    return timeString;
}

-(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

- (NSString *)getServerHost:(NSString *)methodName
{
    if ([methodName isEqualToString:@"INIT"]) {
        return kPayInitURL;
    }
    else if ([methodName isEqualToString:@"Query"]){
        return kQueryURL;
    }
    return @"error";
}

- (NSString *)generateSignParams:(NSDictionary *)preSignParams andPreSignKeys:(NSArray *)allKeys
{
    //参与签名的key
    NSMutableString * preSignStr = [NSMutableString string];
    for (NSString * key in allKeys) {
        
        NSString * value = [preSignParams objectForKey:key];
        if ([self isNullOrEmpty:value]) {
            continue;
        }
        [preSignStr appendFormat:@"%@=%@&",key,value];
    }
    [preSignStr appendFormat:@"%@=%@",@"key",kSignKey];
    
    NSLog(@"presign :: %@",preSignStr);
    return [self md5: preSignStr];
}

- (void)createPrePayOrder:(NSString *)agent_bill_id paymentAmt:(NSString *)pay_amt paymentType:(NSString *)pay_type
{
    self.agent_bill_id = agent_bill_id;
    
    HYHeePayModel * payModel = [[HYHeePayModel alloc] init];
    payModel.version = kVersion;
    payModel.agent_id = kAgentId;
    payModel.agent_bill_time = [self getSystemTimeString];
    payModel.agent_bill_id = agent_bill_id;
    payModel.pay_type = pay_type;
    payModel.pay_amt = pay_amt;
    payModel.user_ip = @"192.168.2.100";
    payModel.notify_url = @"http://www.baidu.com";
    payModel.user_identity = @""; //这个参数可不传，但是如果传了，必须要参与签名，顺序放在user_ip 之后。
    payModel.bank_card_no = @""; //银行4要素 ，快捷支付使用。其他支付可不传
    payModel.bank_user = @"";
    payModel.cert_no = @"";
    payModel.mobile = @"";
    payModel.goods_name = @"iPhone 6s Plus";
    payModel.goods_num = @"1";
    payModel.goods_note = @"国行 白色";
    payModel.remark = @"iPhone6s";
    payModel.return_url = @"www.baidu.com";
    
    NSArray * allKeys = @[@"version",@"agent_id",@"agent_bill_id",@"agent_bill_time",@"pay_type",@"pay_amt",@"notify_url",@"user_ip",@"user_identity",@"bank_card_no",@"bank_user",@"cert_no",@"mobile"];
    
    payModel.sign = [self generateSignParams:[payModel dictionaryRepresentation] andPreSignKeys:allKeys];
    NSDictionary * params = [payModel dictionaryRepresentation];
    [self sendRequestWithParamsStr:params methodName:@"INIT"];
}

- (void)queryPaymentStatusWithAgentBillID:(NSString *)agent_bill_id
{
    
    HYHeePayModel * payModel = [[HYHeePayModel alloc] init];
    payModel.version = @"1"; //查询接口版本号必须是1
    payModel.agent_id = kAgentId;
    payModel.agent_bill_id = agent_bill_id;
    payModel.agent_bill_time = [self getSystemTimeString];

    NSArray * allKeys = @[@"version",@"agent_id",@"agent_bill_id"];
    payModel.sign = [self generateSignParams:[payModel dictionaryRepresentation] andPreSignKeys:allKeys];
    NSDictionary * params = [payModel dictionaryRepresentation];
    [self sendRequestWithParamsStr:params methodName:@"Query"];
}

- (void)sendRequestWithParamsStr:(NSDictionary *)paramsDic methodName:(NSString *)methodName
{
    NSMutableString * paramsStr = [NSMutableString string];
    
    for (NSString *key  in paramsDic.allKeys) {
        NSString * value = [paramsDic objectForKey:key];
        if ([self isNullOrEmpty:value]) {
            continue;
        }
        [paramsStr appendFormat:@"%@=%@&",key,value];
    }
    [paramsStr substringToIndex:paramsStr.length - 1];
    NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * encodeParams = [paramsStr stringByAddingPercentEscapesUsingEncoding:gb2312];
    NSLog(@"\n\nencodeParams:: %@\n",encodeParams);
    
    NSMutableURLRequest * theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self getServerHost:methodName]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0f];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue: @"application/x-www-form-urlencoded;charset=GB2312" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[encodeParams dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:theRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __weak WebRequest * weakSelf = self;
            if (connectionError) {
                  weakSelf.errorBlocks([connectionError localizedDescription]);
            }
            else {
                
                NSString * xmlString = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
                NSLog(@"xml String ::%@",xmlString);
                
                HYTestXMLParse * parser = [[HYTestXMLParse alloc] initWithData:data];
                parser.block = ^(NSDictionary * params){
                    
                    NSString * error = params[@"error"];
                    if (![self isNullOrEmpty:error]) {
                        weakSelf.errorBlocks(error);
                    }
                    else {
                        
                        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
                        if ([methodName isEqualToString:@"INIT"]) {
                            
                            [dic setObject:self.agent_bill_id forKey:@"agent_bill_id"];
                            [dic setObject:kAgentId forKey:@"agent_id"];
                        }
                        if (weakSelf.successBloks) {
                            weakSelf.successBloks(dic);
                        }
                    }
                };
                [parser startParse];
            }
        });
    }];
}


@end
