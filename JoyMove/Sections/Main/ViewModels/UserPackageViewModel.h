//
//  UserPackageViewModel.h
//  JoyMove
//
//  Created by Soda on 2017/10/13.
//  Copyright © 2017年 ting.zhao. All rights reserved.
//

#import "SDCViewModel.h"

@interface UserPackageViewModel : SDCViewModel

@property(nonatomic, strong) RACCommand *checkPackageCommand;

@end
