//
//  SDCSegmentedcontrol.m
//  JoyMove
//
//  Created by Soda on 2017/10/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCSegmentedcontrol.h"

@interface SDCSegmentedcontrol ()
{
    NSMutableArray *_btns;
}

@end

@implementation SDCSegmentedcontrol

- (instancetype)initWithIems:(NSArray *)items
{
    self = [super init];
    if (self) {
        _btns = [[NSMutableArray alloc] initWithCapacity:items.count];
        
        self.normalColor = [UIColor blackColor];
        self.selectedColor = [UIColor whiteColor];
        
        self.titleNoramlColor = [UIColor whiteColor];
        self.titleSelectedColor = [UIColor blackColor];
        
        [self loadButtons:items];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    JMWeakSelf(self);
    
    for (int i = 0; i < _btns.count; i++) {
        UIButton *btn = _btns[i];
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakself.mas_width).multipliedBy(1.0/_btns.count);
            
            make.top.mas_equalTo(@0);
            make.bottom.mas_equalTo(@0);
            if (i > 0) {
                UIButton *lastBtn = _btns[i-1];
                
                make.left.equalTo(lastBtn.mas_right).with.offset(0);
            }else
            {
                make.left.mas_equalTo(@(0));
                
            }
        }];
    }

}

#pragma mark - getter & setter
- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    [[NSUserDefaults standardUserDefaults] setInteger:_selectedIndex forKey:kSelectedIndex];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self resetButtons];
    
    UIButton *btn = _btns[_selectedIndex];
    btn.backgroundColor = self.selectedColor;
    [btn setEnabled:NO];
}

- (void)setTitleNoramlColor:(UIColor *)titleNoramlColor
{
    _titleNoramlColor = titleNoramlColor;
    for (UIButton *temp in _btns) {
        [temp setTitleColor:_titleNoramlColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor
{
    _titleSelectedColor = titleSelectedColor;
    for (UIButton *temp in _btns) {
        [temp setTitleColor:_titleSelectedColor forState:UIControlStateDisabled];
    }
}

#pragma mark - event response
- (void)btnAction:(UIButton *)btn
{
    NSInteger index = [_btns indexOfObject:btn];
    self.selectedIndex = index;
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(SDCSegmentControlClickedIndex:)]) {
            [self.delegate SDCSegmentControlClickedIndex:index];
        }
    }
}

#pragma mark - private
- (void)loadButtons:(NSArray *)items
{
    for (int i = 0; i < items.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btns addObject:btn];
    }
}

- (void)resetButtons
{
    //reset
    for (UIButton *temp in _btns) {
        temp.backgroundColor = self.normalColor;
        [temp setEnabled:YES];
    }
}
@end
