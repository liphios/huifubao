//
//  ViewController.m
//  TetsHuiFuBao
//
//  Created by 李鹏辉 on 16/8/5.
//  Copyright © 2016年 李鹏辉. All rights reserved.
//

#import "ViewController.h"
#import <HeePay/HYSDKManager.h>

@interface ViewController ()<HeepaySDKManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];

}
//初始化界面
- (void)initView{

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor purpleColor];
    btn.frame = self.view.frame;
    [btn setTitle:@"支付" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}
- (NSString *)generateOrderStr
{
    srand((unsigned)time(0));
    NSString * orderStr = [NSString stringWithFormat:@"%ld",time(0)];
    return orderStr;
}
//点击了支付按钮
- (void)clickBtn:(UIButton *)btn{

            /***** 启动 HeepaySDK相关代码 ****/

            HYPayReqModel * payRequModel = [[HYPayReqModel alloc] init];
            payRequModel.token_id = @"";//支付的id 后台返回
            payRequModel.agent_id = @"";//汇付宝ID,6位 后台返回
            payRequModel.agent_bill_id = @"";//订单号ID 后台返回
            payRequModel.pay_type = 0;
            payRequModel.schemeStr = @""; //项目名称
            payRequModel.rootViewController = self; //快捷必传。
            
            [HYSDKManager sendPayRequest:payRequModel delegate:self payResultBlock:^(HYPayResponModel *payResponModel) {
                
                if (payResponModel.payResult == HYPayResultSuccess) {
                    NSLog(@"成功");
                }
                else if (payResponModel.payResult == HYPayResultFail){
                    NSLog(@"失败");
                }
                else if (payResponModel.payResult == HYPayResultCancel){
                    NSLog(@"取消支付");
                }
                else if(payResponModel.payResult == HYPayResultDealing){
                    NSLog(@"单据处理中");
                }
                else if(payResponModel.payResult == HYPayResultError){
                    NSLog(@"错误：%@",payResponModel.message);
                }
               
        }];
}


//SDK 已经启动，
- (void)heepaySDKDidPresent
{
    NSLog(@"启动成功");
}

//SDK 已经退出。
- (void)heepaySDKDidDismiss
{
    //可以在这里做一些SDK卸载之后内存释放的操作。。
    NSLog(@"退出成功");
}

- (void)heepaySDKOpenFailure
{
    NSLog(@"唤起SDK失败");
}


//如果想看步骤介绍，可以去简书搜索 汇付宝支付即可

@end
