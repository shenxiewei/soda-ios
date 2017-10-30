//
//  BaseModel.m
//  JoyMove
//
//  Created by ethen on 15/3/16.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (SEL)getSetterSelWithAttibuteName:(NSString *)attributeName {
    
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:", capital, [attributeName substringFromIndex:1]];
    
    return NSSelectorFromString(setterSelStr);
}

@end
