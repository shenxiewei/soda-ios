//
//  SDCViewController.m
//  JoyMove
//
//  Created by Soda on 2017/4/24.
//  Copyright © 2017年 xin.liu. All rights reserved.
//

#import "SDCViewController.h"
#import "SDCNavController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface SDCViewController ()
{
    UITapGestureRecognizer *_tapRecognizer;
}
@end

@implementation SDCViewController

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    SDCViewController *vc = [super allocWithZone:zone];
    
    @weakify(vc)
    [[vc rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        
        @strongify(vc)
        [vc sdc_addSubviews];
        [vc sdc_bindViewModel];
    }];
    
    [[vc rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        
    }];
    
    return vc;
}

- (instancetype)initWithViewModel:(id<SDCViewModelProtocol>)viewModel {
    
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    
    //添加手势，为了关闭键盘的操作
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    _tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapRecognizer];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view removeGestureRecognizer:_tapRecognizer];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RAC
/**
 *  添加控件
 */
- (void)sdc_addSubviews {}

/**
 *  绑定
 */
- (void)sdc_bindViewModel {}


#pragma mark - touch
- (void)viewTapped:(UITapGestureRecognizer*)tap1
{
    [self.view endEditing:YES];
}

@end
