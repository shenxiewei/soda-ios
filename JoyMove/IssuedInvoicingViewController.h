//
//  IssuedInvoicingViewController.h
//  JoyMove
//
//  Created by cty on 16/4/20.
//  Copyright © 2016年 xin.liu. All rights reserved.
//

#import "BaseViewController.h"

@interface IssuedInvoicingViewController : BaseViewController

@property (nonatomic,strong) NSString *count;
@property (nonatomic,strong) NSMutableArray *orderIds;

@property (nonatomic,copy) void (^popViewController)();


@end
