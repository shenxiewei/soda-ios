//
//  SearchModel.h
//  JoyMove
//
//  Created by ethen on 15/3/24.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, strong) NSString *url;

- (SearchModel *)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
