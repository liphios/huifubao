//
//  WebRequest.h
//  HeePaySDKDemo
//
//  Created by Jiangrx on 6/30/14.
//  Copyright (c) 2014 Jiangrx. All rights reserved.
//

#define WebRequest_QUERY                   @"query"
#define WebRequest_INIT                    @"init"

#import <Foundation/Foundation.h>

typedef void (^WebRequestSuccessBlocks)(NSDictionary * params);
typedef void (^WebRequestErrorBlocks) (NSString *errorMessage);

@interface WebRequest : NSObject

@property (nonatomic,copy) NSString * methodName;
@property (nonatomic,copy) WebRequestSuccessBlocks successBloks;
@property (nonatomic,copy) WebRequestErrorBlocks errorBlocks;

- (void)createPrePayOrder:(NSString *)agent_bill_id paymentAmt:(NSString *)pay_amt paymentType:(NSString *)pay_type;
- (void)queryPaymentStatusWithAgentBillID:(NSString *)agent_bill_id;

@end
