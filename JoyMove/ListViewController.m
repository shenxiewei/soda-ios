//
//  ListViewController.m
//  JoyMove
//
//  Created by ethen on 15/5/4.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController (){
    
    NSArray *_buttonImageArray;
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    [self initNavigationItem];
}

#pragma mark - Interface

- (void)setButtonImageArray:(NSArray *)array {
    
    _buttonImageArray = array;
}

#pragma mark - UI

- (void)initUI {
    
    self.view.backgroundColor = KBackgroudColor;
    
    for (NSInteger i=0; i<_buttonImageArray.count; i++) {
        
        UIImage *image = UIImageName(_buttonImageArray[i]);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 64+7+46*i, kScreenWidth-10, 40)];
        imageView.tag = i;
        imageView.image = [image stretchableImageWithLeftCapWidth:150 topCapHeight:0];
        [self.view addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(listButtonClicked:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
    }
}

- (void)initNavigationItem {
    
    [self setNavBackButtonStyle:BVTagBack];
}

#pragma mark - Action

- (void)buttonClicked:(UIButton *)button {
    
    ;
}

- (void)listButtonClicked:(UITapGestureRecognizer *)tap {
    
    //由子类实现
}

@end
