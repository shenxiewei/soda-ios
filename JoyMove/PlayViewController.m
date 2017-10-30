//
//  PlayViewController.m
//  JoyMove
//
//  Created by ethen on 15/5/26.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "PlayViewController.h"
#import "Macro.h"

@interface PlayViewController ()<UIScrollViewDelegate> {
    
    UIScrollView *_scrollView;
    UIImageView *_tipImageView;
    NSTimer *_timer;
    BOOL isHyperplasia;
}
@end

@implementation PlayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    [self initNavigationItem];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [_scrollView flashScrollIndicators];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.015f target:self selector:@selector(handleTimer) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
    
    _scrollView.delegate = nil;
}

#pragma mark - UI

- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *device = @"";
    if (kIphone6plus) {
        
        device = @"1242";
    }else if (kIphone6) {
        
        device = @"750";
    }else {
        
        device = @"640";
    }
    NSString *imgName = [NSString stringWithFormat:@"howItWorks_%@", device];
    
    UIImage *image = UIImageName(imgName);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, image.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kScreenWidth, image.size.height);
    [_scrollView addSubview:imageView];
    [self.view addSubview:_scrollView];
    
    UIImage *tipImage = UIImageName(@"howItWorksTip");
    _tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-tipImage.size.width)/2, kScreenHeight-20-tipImage.size.height, tipImage.size.width, tipImage.size.height)];
    _tipImageView.image = tipImage;
    [self.view addSubview:_tipImageView];
}

- (void)initNavigationItem {
    
    [self.baseView removeFromSuperview];
    
    self.title = NSLocalizedString(@"How to use", nil);
    [self setNavBackButtonStyle:BVTagBack];
    [self setNavBackButtonTitle:@""];
}

- (void)handleTimer {
    
    if (_tipImageView.alpha>=1.2f) {
        
        isHyperplasia = NO;
    }else if (_tipImageView.alpha<=.0f) {
        
        isHyperplasia = YES;
    }else {
        
        ;
    }
    
    if (isHyperplasia) {
        
        _tipImageView.alpha += .02f;
    }else {
        
        _tipImageView.alpha -= .02f;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y>=(scrollView.contentSize.height-kScreenHeight)) {
        
        _tipImageView.hidden = YES;
    }else {
        
        _tipImageView.hidden = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    /*
     if (decelerate) {
     
     NSLog(@"%f", scrollView.contentOffset.x);
     NSLog(@"%f", scrollView.contentSize.width);
     if (scrollView.contentOffset.x > (scrollView.frame.size.width*(_imageNameArray.count-1))) {
     
     [self hide];
     }
     }
     */
}

@end
