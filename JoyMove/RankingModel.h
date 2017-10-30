//
//  RankingModel.h
//  JoyMove
//
//  Created by 赵霆 on 16/6/12.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingModel : NSObject

/** 公里数 */
@property (nonatomic, copy) NSString *mileage;
/** 电话 */
@property (nonatomic, copy) NSString *mobileNo;
/** 头像 */
@property (nonatomic, copy) NSString *photo;
/** 👍数 */
@property (nonatomic, copy) NSString *praise;
/** 排名 */
@property (nonatomic, copy) NSString *rank;

- (RankingModel *)initWithDictionary:(NSDictionary *)dic;

@end
