//
//  HYTestXMLParse.m
//  HYWebRequestDemo
//
//  Created by Jiangrx on 6/2/16.
//  Copyright © 2016 汇元网. All rights reserved.
//


#import "HYTestXMLParse.h"
@interface HYTestXMLParse ()<NSXMLParserDelegate>

{
    NSMutableString * _strTem;
    NSMutableDictionary * _params;
}
@property (nonatomic,strong)NSXMLParser *parser;

@end

@implementation HYTestXMLParse

- (id)initWithData:(NSData*)data
{
    if (self = [super init]) {
        
        _parser = [[NSXMLParser alloc] initWithData:data];
        [_parser setDelegate:self];
    }
    return self;
}

- (void)startParse
{
    [_parser parse];
}

#pragma mark - NSXMLParserDelegate Methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _params = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _strTem = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [_strTem appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"HasError"]) {
        
        [_params setObject:_strTem forKey:@"HasError"];
    }
    else if ([elementName isEqualToString:@"Message"]) {
        [_params setObject:_strTem forKey:@"Message"];
    }
    else if ([elementName isEqualToString:@"TokenID"]) {
        [_params setObject:_strTem forKey:@"TokenID"];
        
    }
    else if ([elementName isEqualToString:@"bill_info"]) {
        [_params setObject:_strTem forKey:@"bill_info"];
    }
    else if ([elementName isEqualToString:@"AgentBillID"]) {
        [_params setObject:_strTem forKey:@"AgentBillID"];
    }
    else if ([elementName isEqualToString:@"AgentID"]) {
        [_params setObject:_strTem forKey:@"AgentID"];
    }
    else if ([elementName isEqualToString:@"token_id"]) {
        [_params setObject:_strTem forKey:@"token_id"];
    }
    else if ([elementName isEqualToString:@"error"]) {
        [_params setObject:_strTem forKey:@"error"];
    }
    else if ([elementName isEqualToString:@"return_code"]) {
        [_params setObject:_strTem forKey:@"return_code"];
    }
    else if ([elementName isEqualToString:@"appid"]) {
        [_params setObject:_strTem forKey:@"appid"];
    }
    else if ([elementName isEqualToString:@"mch_id"]) {
        [_params setObject:_strTem forKey:@"mch_id"];
    }
    else if ([elementName isEqualToString:@"device_info"]) {
        [_params setObject:_strTem forKey:@"device_info"];
    }
    else if ([elementName isEqualToString:@"nonce_str"]) {
        [_params setObject:_strTem forKey:@"nonce_str"];
    }
    else if ([elementName isEqualToString:@"sign"]) {
        [_params setObject:_strTem forKey:@"sign"];
    }
    else if ([elementName isEqualToString:@"return_msg"]) {
        [_params setObject:_strTem forKey:@"return_msg"];
    }
    else if ([elementName isEqualToString:@"result_code"]) {
        [_params setObject:_strTem forKey:@"result_code"];
    }
    else if ([elementName isEqualToString:@"prepay_id"]) {
        [_params setObject:_strTem forKey:@"prepay_id"];
    }
    else if ([elementName isEqualToString:@"result_code"]) {
        [_params setObject:_strTem forKey:@"result_code"];
    }
    else if ([elementName isEqualToString:@"trade_type"]) {
        [_params setObject:_strTem forKey:@"trade_type"];
    }
    
    _strTem = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (self.block) {
        self.block(_params);
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (self.block) {
        self.block(_params);
    }
}

@end
