//
//  MyCarTBViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/9/11.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface MyCarTBViewModel : SDCViewModel

@property(nonatomic,copy)NSArray *desArray;
@property(nonatomic,copy)NSArray *desImgArray;
@property(nonatomic,copy)NSArray *dataArray;

@property(nonatomic, strong)RACCommand *refreshDataCommand;
@property(nonatomic, strong)RACSubject *refreshEndSubject;

@end
