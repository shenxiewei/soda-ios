//
//  MessageCellMode.h
//  JoyMove
//
//  Created by 刘欣 on 15/3/31.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCellMode : NSObject

@property(nonatomic,copy)NSString *message;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *messageTitle;

- (MessageCellMode *)initWithDitionary:(NSDictionary *)dic;

- (NSDictionary *)dictionary;

@end
