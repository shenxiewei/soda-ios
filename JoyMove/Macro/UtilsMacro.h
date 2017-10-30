//
//  UtilsMacro.h
//  PetBar
//
//  Created by Ethen on 14-2-25.
//  Copyright (c) 2014年 EZ. All rights reserved.
//


#ifndef JoyMove_UtilsMacro_h
#define JoyMove_UtilsMacro_h

#define kDevice             ([UIDevice currentDevice].systemName)
#define kIphone4            (480==kScreenHeight)
#define kIphone5            (568==kScreenHeight)
#define kIphone6            (667==kScreenHeight)
#define kIphone6plus        (736==kScreenHeight)
#define kAboveIOS7          ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f)
#define kAboveIOS8          ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.f)
#define kAboveIOS9          ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.f)
#define kScreenHeight       ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth        ([UIScreen mainScreen].bounds.size.width)

#define kVersion                        [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]
#define UIColorFromSixteenRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromSixteenRGBA(rgbValue, alp) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alp]
#define UIColorFromRGB(r,g,b)           [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIFontFromSize(intValue)        [UIFont fontWithName:@"Avenir-Book" size:intValue]
#define UIBoldFontFromSize(intValue)    [UIFont boldSystemFontOfSize:intValue]
#define kIsNSString(string)             [string isKindOfClass:[NSString class]]
#define kIsNSNull(string)               [string isKindOfClass:[NSNull class]]
#define IntegerFormObject(obj)          ([(obj) respondsToSelector:@selector(integerValue)]?[(obj) integerValue]:0)
#define kDoubleFormObject(obj)           ([(obj) respondsToSelector:@selector(doubleValue)]?[(obj) doubleValue]:0.f)
#define NSStringFromNSNumbel(numbel)    NSStringFromInt([numbel intValue])
#define UIImageName(imageName)          [UIImage imageNamed:imageName]

#define AddObserver(nam, sel)           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sel) name:nam object:nil]
#define RemoveObserver(id, nam)         [[NSNotificationCenter defaultCenter] removeObserver:id name:nam object:nil]
#define PostNotification(nam)           [[NSNotificationCenter defaultCenter] postNotificationName:nam object:nil]
#define PostNotificationAllParameter(nam, obj, userIn) [[NSNotificationCenter defaultCenter] postNotificationName:nam object:obj userInfo:userIn]
#define response(string)                (response[string] && response[string]!=[NSNull null])?response[string]:@""

#define km(latpoint, longpoint)         (111.045*DEGREES(ACOS(COS(RADIANS(latpoint))*COS(RADIANS(latitude))*COS(RADIANS(longpoint)-RADIANS(longitude))+SIN(RADIANS(latpoint))*SIN(RADIANS(latitude)))) AS distance_in_km)
#define kUrlHeader                      [NSString stringWithFormat:kURL(kUrlGetHeaderIcon),[UserData userData].mobileNo]

#define isZhHans [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"zh-Hans"]
#define isZhHant [[[NSLocale preferredLanguages] firstObject] hasPrefix:@"zh-Hant"]

#define JMWeakSelf(type)  __weak typeof(type) weak##type = type;

#endif
