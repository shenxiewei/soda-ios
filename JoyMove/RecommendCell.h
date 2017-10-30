//
//  RecommendCell.h
//  JoyMove
//
//  Created by 刘欣 on 15/4/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UITableViewCell

@property (nonatomic,assign) NSString *route;
@property (nonatomic,assign) NSString *title;

- (void)updateRecommendCell;
- (float)height;

@end
