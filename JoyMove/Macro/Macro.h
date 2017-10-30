//
//  Macro.h
//  JoyMove
//
//  Created by ethen on 15/3/11.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#ifndef JoyMove_Macro_h
#define JoyMove_Macro_h

#import "Config.h"
#import "CodeMacro.h"
#import "ColorMacro.h"
#import "URLMacro.h"
#import "UtilsMacro.h"
#import "UserData.h"
#import "OrderData.h"
#import "UIView+TZExtension.h"
#import "NSDate+TZExtension.h"


#define ShareTitle                          @"苏打出行"
#define ShareContentStr                     @"BANG！我跑步，我骑车，我用绿色Soda共享车！我是Sodar %@"
#define ShareRedirectUri                    @"www.sodacar.com/share.html"
#define RegistrationVoiceprintAlertMessage  @"声纹识别是你在支付、押金提现时可选择的交易密码形式之一，启用后更加安全便捷。"
#define RegistrationFaceAlertMessage        @"脸部识别是你在支付、押金提现时可选择的交易密码形式之一，启用后更加安全便捷。"

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(@"%s [Line %d]\n---- %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...) {}
#endif

#endif
