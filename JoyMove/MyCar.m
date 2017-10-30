//
//  MyCar.m
//  JoyMove
//
//  Created by Soda on 2017/9/18.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "MyCar.h"

static MyCar *_mycar = nil;

@implementation MyCar
+ (MyCar *)shareIntance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mycar = [[MyCar alloc] init];
    });
    
    return _mycar;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadCar:(NSDictionary *)params
{
    self.licenseNum = params[@"licenseNum"];
    self.effectiveTime = [params[@"effectiveTime"] doubleValue];
    self.expireTime = [params[@"expireTime"] doubleValue];
    self.serverTime = [params[@"currentTime"] doubleValue];
    self.imgURL = params[@"carImg"];
    self.carType = params[@"carType"];
    self.isFree = [params[@"isFree"] boolValue];
    self.phoneNum = params[@"userMobile"];
    self.userName = params[@"userName"];
    self.retalID = params[@"id"];
    self.vimNum = params[@"vinNum"];
    self.isShare = [params[@"isShare"] integerValue];
    NSArray *location = params[@"location"];
    self.lastCoord = CLLocationCoordinate2DMake([location[1] doubleValue], [location[0] doubleValue]);
    
    if (self.imgURL) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[self.imgURL componentsSeparatedByString:@"."]];
        NSString *tmp = array[array.count-2] ;
        NSString *img_name_L = [tmp stringByAppendingString:@"_L"];
        [array replaceObjectAtIndex:array.count-2 withObject:img_name_L];
        self.car_img_l = [self get_img_url:array];
        NSString *img_name_M = [tmp stringByAppendingString:@"_M"];
        [array replaceObjectAtIndex:array.count-2 withObject:img_name_M];
        self.car_img_m = [self get_img_url:array];
        NSString *img_name_S = [tmp stringByAppendingString:@"_S"];
        [array replaceObjectAtIndex:array.count-2 withObject:img_name_S];
        self.car_img_s = [self get_img_url:array];
    }
    
    
}

- (NSString *)get_img_url:(NSArray *)array
{
    NSString *tmp = array[0];
    for (int i = 1;i < array.count;i++) {
        NSString *string = array[i];
        tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@".%@",string]];
    }
    return tmp;
}

- (void)resetCar
{
    self.isShare = 0;
    self.licenseNum = nil;
    self.effectiveTime = 0.0;
    self.expireTime = 0.0;
    self.imgURL = nil;
    self.carType = nil;
    self.isFree = NO;
    self.phoneNum = 0;
    self.userName = nil;
    self.retalID = nil;
    self.lastCoord = CLLocationCoordinate2DMake(0.0,0.0);
}
@end
