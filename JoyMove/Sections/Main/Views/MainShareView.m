//
//  MainShareView.m
//  JoyMove
//
//  Created by Soda on 2017/10/19.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MainShareView.h"
#import "MainShareViewModel.h"
#import "IndicatorLoadingView.h"

#import "PackagePromotionView.h"
#import "TabShareView.h"

#import "MyCar.h"

@interface MainShareView ()

@property (strong, nonatomic) MainShareViewModel *mainShareViewModel;

@end

@implementation MainShareView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)sdc_setupViews
{
    
}

- (void)sdc_bindViewModel
{
    //[self.viewModel.packageCommand execute:nil];
    //1、查看套餐
    
    [self.mainShareViewModel.packageSubject subscribeNext:^(NSDictionary *params) {
        [[MyCar shareIntance] loadCar:params];
        
        [[IndicatorLoadingView sharedIndicatorLoadingView] dismiss];
        
        TabShareView *view = [[TabShareView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:view];
    }];
    
}

#pragma mark - public
- (void)reloadData
{
     [[IndicatorLoadingView sharedIndicatorLoadingView] show:self];
    @weakify(self)
    [[self.mainShareViewModel.packageCommand execute:nil] subscribeError:^(NSError *error) {
        @strongify(self)
        [[IndicatorLoadingView sharedIndicatorLoadingView] dismiss];
        
        PackagePromotionView *view = [[PackagePromotionView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:view];
    }];
}

- (void)removeAllChildren
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark - lazyLoad

- (MainShareViewModel *)mainShareViewModel
{
    if (!_mainShareViewModel) {
        _mainShareViewModel = [[MainShareViewModel alloc] init];
    }
    return _mainShareViewModel;
}
@end
