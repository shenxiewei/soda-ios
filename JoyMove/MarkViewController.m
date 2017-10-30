//
//  MarkViewController.m
//  JoyMove
//
//  Created by 赵霆 on 16/3/22.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "MarkViewController.h"
#import "MarKWordView.h"
#import "MyCar.h"
#import "FMShare.h"

@interface MarkViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIButton *rightBtn;
/* stars and count **/
@property (nonatomic, strong) UIButton *star0;
@property (nonatomic, strong) UIButton *star1;
@property (nonatomic, strong) UIButton *star2;
@property (nonatomic, strong) UIButton *star3;
@property (nonatomic, strong) UIButton *star4;

@property (nonatomic, strong) MarKWordView *markView;
@property (nonatomic, assign) NSInteger startCount;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSArray *labelsArray;
@property (nonatomic, strong) NSArray *allLabelsArray;


@end

@implementation MarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Appraise", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.baseView removeFromSuperview];
    
    [self requestForLabels];
    [self initNavigation];


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

- (void)requestForLabels
{
    NSDictionary *dic = @{@"ting":@"diao"};
    
    [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlUserFeelingLabels) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
        
        if (success) {
            
            _allLabelsArray = response[@"levels"];
            
        }else{
            _allLabelsArray = @[];
        }
        
        // 请求完成后再初始化UI
        [self initUI];
    }];
}

- (void)initNavigation
{
    UIButton *leftBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 35, 35);
    leftBtn.tag = 1;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [leftBtn setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 35);
    rightBtn.tag = 2;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [rightBtn setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)initUI
{
    
    // string
    UILabel *totalStr = [[UILabel alloc] initWithFrame:CGRectMake(17, 64, kScreenWidth, 47)];
    totalStr.text = NSLocalizedString(@"Overall", nil);
    totalStr.font = [UIFont systemFontOfSize:15];
    totalStr.adjustsFontSizeToFitWidth = YES;
    totalStr.textColor = UIColorFromSixteenRGB(0x868686);
    [self.view addSubview:totalStr];
    // line
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 47, kScreenWidth, 0.5)];
    lineOne.backgroundColor = UIColorFromSixteenRGB(0xb7b7b7);
    [self.view addSubview:lineOne];
    
    // stars
    _star0 = [[UIButton alloc] init];
    [self initStarWithButton:_star0 andNumber:0];
    _star1 = [[UIButton alloc] init];
    [self initStarWithButton:_star1 andNumber:1];
    _star2 = [[UIButton alloc] init];
    [self initStarWithButton:_star2 andNumber:2];
    _star3 = [[UIButton alloc] init];
    [self initStarWithButton:_star3 andNumber:3];
    _star4 = [[UIButton alloc] init];
    [self initStarWithButton:_star4 andNumber:4];
    
    
    _markView = [[MarKWordView alloc] init];
    [_markView creatMarkViewWithFrame:CGRectMake(17, CGRectGetMaxY(lineOne.frame), kScreenWidth - 34, 0) andStringArray:_allLabelsArray];
    _markView.height = _markView.heightForSelf;
    _labelsArray = _markView.markArray;
    [self.view addSubview:_markView];
    
    // line
    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_markView.frame), kScreenWidth, 0.5)];
    lineTwo.backgroundColor = UIColorFromSixteenRGB(0xb7b7b7);
    [self.view addSubview:lineTwo];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineTwo.frame), kScreenWidth, 94)];
    _textView.font = [UIFont systemFontOfSize:15];
    _textView.textColor = UIColorFromSixteenRGB(0x868686);
    _textView.text= NSLocalizedString(@"your suggest", nil);
    _textView.textContainerInset = UIEdgeInsetsMake(11, 13, 11, 17);
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    // line
    UIView *lineThree = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), kScreenWidth, 0.5)];
    lineThree.backgroundColor = UIColorFromSixteenRGB(0xb7b7b7);
    [self.view addSubview:lineThree];
    
    if ([UserData share].isRentForMonth) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(10.0 ,CGRectGetMaxY(lineThree.frame)+40.0, (self.view.frame.size.width-20.0),40.0);
        shareButton.backgroundColor = UIColorFromSixteenRGB(0xf87a63);
        shareButton.titleLabel.textColor = [UIColor whiteColor];
        [shareButton setTitle:@"分享" forState:UIControlStateNormal];
        shareButton.layer.cornerRadius = 5.0;
        [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareButton];
    }
}

- (void)initStarWithButton:(UIButton *)button andNumber:(NSInteger)number
{
    CGFloat marginX = 0;
    CGFloat starWH = 30.0;
    button.frame = CGRectMake(60 + number * (marginX + starWH), 64 + 7, starWH, starWH);
    [button setImage:[UIImage imageNamed:@"markStar_sel"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"markStar"] forState:UIControlStateSelected];
    button.tag = number;
    button.selected = YES;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

//导航栏返回、取消点击事件
- (void)navButtonClicked:(UIButton *)button {
    
    if (button.tag == 1) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }else{
    
        NSDictionary *dic = @{@"orderId":[NSString stringWithFormat:@"%ld", (long)[OrderData orderData].orderId],
                              @"star":[NSString stringWithFormat:@"%ld", (long)_startCount],
                              @"label":_labelsArray,
                              @"Comment":_textView.text};
        
        [LXRequest requestWithJsonDic:dic andUrl:kURL(KUrlUserFeeling) completeHandle:^(BOOL success, NSDictionary *response, NSInteger result) {
            
            if (success) {
                if (result == JMCodeSuccess) {
                    
                    [self showSuccess:NSLocalizedString(@"Appraise success", nil)];
                    [self.navigationController popToRootViewControllerAnimated:YES];

                }
            }
        }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([_textView.text isEqualToString:NSLocalizedString(@"your suggest", nil)]) {
        
        _textView.text = @"";
    }else{
        
    }
}

- (void)buttonClick:(UIButton *)button
{
    // star显示逻辑
    if (button.tag == 0) {
        _star0.selected = YES;
        _star1.selected = NO;
        _star2.selected = NO;
        _star3.selected = NO;
        _star4.selected = NO;
        _startCount = 1;
    }else if (button.tag == 1){
        _star0.selected = YES;
        _star1.selected = YES;
        _star2.selected = NO;
        _star3.selected = NO;
        _star4.selected = NO;
        _startCount = 2;
    }else if (button.tag == 2){
        _star0.selected = YES;
        _star1.selected = YES;
        _star2.selected = YES;
        _star3.selected = NO;
        _star4.selected = NO;
        _startCount = 3;
    }else if (button.tag == 3){
        _star0.selected = YES;
        _star1.selected = YES;
        _star2.selected = YES;
        _star3.selected = YES;
        _star4.selected = NO;
        _startCount = 4;
    }else if (button.tag == 4){
        _star0.selected = YES;
        _star1.selected = YES;
        _star2.selected = YES;
        _star3.selected = YES;
        _star4.selected = YES;
        _startCount = 5;
    }
    
}

- (void)shareAction
{
      [FMShare shareRentForMonthActivityURL:[NSString stringWithFormat:@"%@?id=%@&carId=%@",kUrlShareCarHtml,[MyCar shareIntance].retalID,[MyCar shareIntance].vimNum] title:@"免费领车体验劵" content:[NSString stringWithFormat:@"苏打智能共享车(%@)，我“享”你，包险包养，你只负责开，剩下我们来！",[MyCar shareIntance].licenseNum] image:@"http://static.sodacar.com/package/wxShareIcon.jpg#"];
}
@end
