//
//  CTMediator+ModuleFramework.m
//  gingu-framework
//
//  Created by Soda on 2017/8/2.
//  Copyright © 2017年 Soda. All rights reserved.
//

#import "CTMediator+ModuleFramework.h"

@implementation CTMediator (ModuleFramework)
- (UIViewController *)CTMediator_viewControllerTarget:(NSString *)targetName actionName:(NSString *)actionName params:(NSDictionary *)params
{
    UIViewController *viewController = [self performTarget:targetName
                                                    action:actionName
                                                    params:params
                                         shouldCacheTarget:NO
                                        ];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}
@end
