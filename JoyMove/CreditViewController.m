//
//  CreditViewController.m
//  JoyMove
//
//  Created by 赵霆 on 15/12/11.
//  Copyright © 2015年 xin.liu. All rights reserved.
//

#import "CreditViewController.h"
#import "IntegralMallViewController.h"
#import "WebViewController.h"

@interface CreditViewController ()
/** 积分数字 */
@property (weak, nonatomic) IBOutlet UILabel *creditNumber;
/** 兑换按钮 */
@property (weak, nonatomic) IBOutlet UIButton *convertBtn;
/** 菊花 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *lodaing;
/** 积分规则 */
@property (weak, nonatomic) IBOutlet UIButton *convertRule;
@property (weak, nonatomic) IBOutlet UILabel *myCredit;

@end

@implementation CreditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 基础设置
    self.title = NSLocalizedString(@"Points", nil);
    self.baseView.alpha = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBackButtonStyle:BVTagBack];
    // 控件初始状态
    self.creditNumber.hidden = YES;
    self.convertBtn.hidden = YES;
    [self.convertBtn setTitle:NSLocalizedString(@"Exchange", nil) forState:UIControlStateNormal];
    [self.convertBtn addTarget:self action:@selector(pushPointStore) forControlEvents:UIControlEventTouchUpInside];
    [self.lodaing startAnimating];
    // 字号自动调整
    self.creditNumber.adjustsFontSizeToFitWidth = YES;
    //积分规则
    [self.convertRule setTitle:NSLocalizedString(@"Points policy", nil) forState:UIControlStateNormal];
    self.convertRule.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.convertRule addTarget:self action:@selector(convertRuleClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.myCredit.text = NSLocalizedString(@"My Points", nil);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 请求积分数字
    [self requstForBonusPoint];
}

- (void)convertRuleClick
{
    WebViewController *webVc = [[WebViewController alloc] init];
    webVc.view.frame = [UIScreen mainScreen].bounds;
    webVc.title = NSLocalizedString(@"Points policy", nil);
    [webVc loadUrl:kURL(kE2EUrlJiFenShuoMing)];
    [self.navigationController pushViewController:webVc animated:YES];

}

- (void)pushPointStore
{
    IntegralMallViewController *integralMallVc = [[IntegralMallViewController alloc] init];
    [self.navigationController pushViewController:integralMallVc animated:YES];
}

- (void)requstForBonusPoint
{
    [LXRequest requestWithJsonDic:@{} andUrl:kURL(kUrlPonusPoint) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            if (result == JMCodeSuccess) {
                
                [self.lodaing stopAnimating];
                self.lodaing.hidden = YES;
                self.creditNumber.hidden = NO;
                self.convertBtn.hidden = NO;
                self.creditNumber.text = [NSString stringWithFormat:@"%@", (response(@"total"))] ;
                
            }
            else if (result==12000)
            {
                [self createNoNetWorkViewWithReloadBlock:^{
                    
                }];
            }
            else
            {
                NSString *message = response[@"errMsg"];
                message = message&&message.length?message:JMMessageNoErrMsg;
            }
        }else{

        }
        
    }];
}

@end
