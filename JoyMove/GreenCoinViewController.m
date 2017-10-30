//
//  GreenCoinViewController.m
//  JoyMove
//
//  Created by 刘欣 on 15/7/2.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "GreenCoinViewController.h"
#import "WebViewController.h"

@interface GreenCoinViewController ()<WebViewDelegate>

@end

@implementation GreenCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"绿币";
    [self setNavBackButtonStyle:BVTagBack];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UI

- (void)initUI {

    [self.baseView removeFromSuperview];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    scrollView.backgroundColor = KBackgroudColor;
    scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight-64+1);
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    //绿币明细
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame = CGRectMake(0, 0, 60, 44);
    [detailButton setTitle:@"绿币明细" forState:UIControlStateNormal];
    [detailButton setTitleColor:UIColorFromRGB(100, 100, 100) forState:UIControlStateNormal];
    detailButton.titleLabel.font = UIFontFromSize(12);
    [detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self setNavRightButton:detailButton];
    
    //绿币图标
    UIImage *greenCoinImage = [UIImage imageNamed:@"greenCoin"];
    CGFloat width = greenCoinImage.size.width;
    CGFloat height = greenCoinImage.size.height;
    UIImageView *greenCoinImageView = [[UIImageView alloc] init];
    greenCoinImageView.frame = CGRectMake((kScreenWidth-width)/2, 115-64, width, height);
    greenCoinImageView.image = greenCoinImage;
    [scrollView addSubview:greenCoinImageView];
    
    //我的绿币
    UILabel *myGreenCoinLabel = [[UILabel alloc] init];
    myGreenCoinLabel.frame = CGRectMake(0, 225-64, kScreenWidth, 20);
    myGreenCoinLabel.font = [UIFont systemFontOfSize:14];
    myGreenCoinLabel.textColor = UIColorFromRGB(87, 87, 87);
    myGreenCoinLabel.text = @"我的绿币";
    myGreenCoinLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:myGreenCoinLabel];
    
    //绿币数额
    UILabel *greenCoinLabel = [[UILabel alloc] init];
    greenCoinLabel.frame = CGRectMake(0, 245-64, kScreenWidth, 30);
    greenCoinLabel.font = [UIFont systemFontOfSize:24];
    greenCoinLabel.textColor = UIColorFromRGB(39, 38, 54);
    greenCoinLabel.text = @"¥10.00";
    greenCoinLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:greenCoinLabel];
    
    //使用规则
    UIButton *ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ruleButton.frame = CGRectMake((kScreenWidth-60)/2, kScreenHeight-64-35, 60, 20);
    ruleButton.titleLabel.alpha = 0.54f;
    [ruleButton setTitle:@"绿币使用规则" forState:UIControlStateNormal];
    [ruleButton setTitleColor:UIColorFromRGB(87, 87, 87) forState:UIControlStateNormal];
    ruleButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [ruleButton addTarget:self action:@selector(ruleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:ruleButton];
}

#pragma mark - Action

//绿币明细
- (void)detailButtonClick {

    NSLog(@"绿币明细");
}

//使用规则
- (void)ruleButtonClick {
    
    WebViewController *webViewController = [[WebViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webViewController];
    webViewController.view.frame = [UIScreen mainScreen].bounds;
    [webViewController setHideAgreeButton:YES];
    webViewController.title = @"绿币使用说明";
    webViewController.delegate = self;
    [webViewController loadUrl:kURL(kE2EUrlJiFenShuoMing)];
    
    [self presentViewController:navi animated:YES completion:nil];
    
}
@end
