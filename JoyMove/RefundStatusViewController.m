//
//  RefundStatusViewController.m
//  JoyMove
//
//  Created by Soda on 2017/3/10.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "RefundStatusViewController.h"
#import "TimeLineView.h"
#import "TradeDetailViewController.h"

@interface RefundStatusViewController ()

@end

@implementation RefundStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.baseView removeFromSuperview];
    self.title = @"退款状态";
    [self setNavBackButtonStyle:BVTagBack];
    
    UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacer.width = -10;
    
    UIButton *cancelNavigationItemButton = [UIButton buttonWithType: UIButtonTypeCustom];
    cancelNavigationItemButton.frame = CGRectMake(0, 0, 44, 44);
    cancelNavigationItemButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cancelNavigationItemButton setTitle:@"明细" forState:UIControlStateNormal];
    [cancelNavigationItemButton setTitleColor:UIColorFromRGB(226, 123, 105) forState:UIControlStateNormal];
    [cancelNavigationItemButton addTarget:self action:@selector(tradeDetail) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView: cancelNavigationItemButton];
    self.navigationItem.rightBarButtonItems = @[rightSpacer, rightButtonItem];
    
    if (self.tradeID == nil) {
        [self loadRefundStatus:nil];
    }else
    {
        [self loadRefundStatus:@{@"id":@([self.tradeID integerValue])}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRefundStatus:(NSDictionary *)params
{
    JMWeakSelf(self);
    [LXRequest requestWithJsonDic:params andUrl:kURL(kUrlRefundRecords) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (JMCodeSuccess == result) {
                [weakself initTimeLine:response];
            }
            else {
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
                [weakself showError:message];
            }
        }else {
            
            [weakself showError:JMMessageNetworkError];
        }
    }];
}

- (void)initTimeLine:(NSDictionary *)params
{
    UILabel *amoutLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 84.0, [UIScreen mainScreen].bounds.size.width, 30.0)];
    amoutLbl.text = [NSString stringWithFormat:@"退款金额 %@元",params[@"records"][0][@"amount"]];
    //amoutLbl.textColor = [UIColor lightGrayColor];
    amoutLbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:amoutLbl];
    
    NSArray *array = params[@"records"];
    NSData *data = [(array[0])[@"timeline"] dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *timelineArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    NSMutableArray *statusArray = [[NSMutableArray alloc] initWithCapacity:timelineArray.count];
    NSMutableArray *timeArray = [[NSMutableArray alloc] initWithCapacity:timelineArray.count];
    NSMutableArray *descriptionArray = [[NSMutableArray alloc] initWithCapacity:timelineArray.count];
    
    for (int i = 0; i < timelineArray.count; i++) {
        NSDictionary *dict = timelineArray[i];
        [descriptionArray addObject:dict[@"description"]];
        [timeArray addObject:[self timeStamp:[dict[@"time"] doubleValue]*0.001]];
        [statusArray addObject:[self refundStatus:[dict[@"state"] integerValue]]];
    }
    
    
    TimeLineView *timeline = [[TimeLineView alloc] initWithStatusArray:statusArray DescriptionArray:descriptionArray TimeArray:timeArray Frame:CGRectMake(20.0, amoutLbl.frame.origin.y+amoutLbl.frame.size.height+10.0, [UIScreen mainScreen].bounds.size.width-40.0, [UIScreen mainScreen].bounds.size.height-(amoutLbl.frame.origin.y+amoutLbl.frame.size.height+10.0))];
    [self.view addSubview:timeline];
    
    //注册
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height-10.0-40.0, kScreenWidth-20, 40);
    registerBtn.backgroundColor = UIColorFromRGB(226, 123, 105);
    [registerBtn setTitle:[statusArray lastObject] forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    registerBtn.layer.cornerRadius = 4;
    registerBtn.layer.masksToBounds = YES;
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[registerBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //registerBtn.tag = LVTagRegister;
    [self.view addSubview:registerBtn];
}

- (void)tradeDetail
{
    TradeDetailViewController *vc = [[TradeDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)refundStatus:(NSInteger)status
{
    if (status == 0) {
        return @"待审核";
    }else if (status == 1)
    {
        return @"已退款";
    }else if (status == 2)
    {
        return @"退款中";
    }else if (status == 3)
    {
        return @"审核未通过";
    }else if (status == 4)
    {
        return @"退款失败";
    }
    return @"异常";
}

- (NSString *)timeStamp:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
    
}
@end
