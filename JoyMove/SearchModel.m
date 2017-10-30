//
//  SearchModel.m
//  JoyMove
//
//  Created by ethen on 15/3/24.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "SearchModel.h"
#import "Macro.h"

@implementation SearchModel

- (SearchModel *)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    if (self) {
        
        self.name = dictionary[@"name"] != [NSNull null] ? dictionary[@"name"] : @"(空)";
        self.latitude = kDoubleFormObject(dictionary[@"latitude"]);
        self.longitude = kDoubleFormObject(dictionary[@"longitude"]);
        self.url = dictionary[@"url"] != [NSNull null] ? dictionary[@"url"] : @"";
    }
    
    return self;
}

- (NSDictionary *)dictionary {
    
    NSString *url = self.url&&self.url.length ? self.url : @"";
    return @{@"name":self.name,
             @"latitude":@(self.latitude),
             @"longitude":@(self.longitude),
             @"url":url};
}

@end
