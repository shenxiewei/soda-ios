//
//  MyCar.h
//  JoyMove
//
//  Created by Soda on 2017/9/18.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCar : NSObject

@property(nonatomic, copy)NSString *imgURL;
@property(nonatomic, copy)NSString *licenseNum;
@property(nonatomic, copy)NSString *carType;
@property(nonatomic, assign)double effectiveTime;
@property(nonatomic, assign)double expireTime;
@property(nonatomic, assign)double serverTime;
@property(nonatomic, assign)CLLocationCoordinate2D lastCoord;
@property(nonatomic, assign)BOOL isFree;
@property(nonatomic, copy)NSString *phoneNum;
@property(nonatomic, copy)NSString *userName;
@property(nonatomic, copy)NSString *retalID;
@property(nonatomic, copy)NSString *vimNum;
@property(nonatomic, assign) NSInteger isShare;

@property(nonatomic, copy)NSString *car_img_l;
@property(nonatomic, copy)NSString *car_img_m;
@property(nonatomic, copy)NSString *car_img_s;

+ (MyCar *)shareIntance;

- (void)loadCar:(NSDictionary *)params;
- (void)resetCar;

@end
