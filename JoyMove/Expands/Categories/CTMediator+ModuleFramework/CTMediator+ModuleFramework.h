//
//  CTMediator+ModuleFramework.h
//  gingu-framework
//
//  Created by Soda on 2017/8/2.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import <CTMediator/CTMediator.h>

@interface CTMediator (ModuleFramework)

- (UIViewController *)CTMediator_viewControllerTarget:(NSString *)targetName
                                           actionName:(NSString *)actionName
                                               params:(NSDictionary *)params;
@end
