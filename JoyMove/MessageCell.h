//
//  MessageCell.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/31.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property(nonatomic,copy)NSString *messageTitle;
@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *date;

- (void)updateMessageCells;
- (float)height;

@end
