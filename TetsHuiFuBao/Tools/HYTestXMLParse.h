//
//  HYTestXMLParse.h
//  HYWebRequestDemo
//
//  Created by Jiangrx on 6/2/16.
//  Copyright © 2016 汇元网. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HYTestXMLParserBlock)(NSDictionary *params);

@interface HYTestXMLParse : NSObject

@property (nonatomic,copy) HYTestXMLParserBlock block;

- (id)initWithData:(NSData*)data;
- (void)startParse;

@end
