//
//  UserData.m
//  JoyMove
//
//  Created by 刘欣 on 15/3/17.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "UserData.h"
#import "UtilsMacro.h"

@implementation UserData

static UserData *myUserData = nil;

+ (UserData *)userData {

    if (!myUserData) {
        
        myUserData = [[UserData alloc] init];
        
        myUserData.nickname = @"";
        myUserData.genderIndex = 0;
        myUserData.password = @"";
        myUserData.authToken = @"";
        myUserData.mobileNo = @"";
        
        myUserData.cityName=@"";
        myUserData.provinceString=@"";
        myUserData.cityString=@"";
        myUserData.townString=@"";
        
        myUserData.balance = -1.0;
        
        [self loadData];
    }
    return myUserData;
}

+ (UserData *)share{
    return [UserData userData];
}

+ (BOOL)isLogin {

    if (kIsNSString([UserData userData].authToken) && [UserData userData].authToken.length
        && kIsNSString([UserData userData].mobileNo) && [UserData userData].mobileNo.length) {
        
        return YES;
    }else {
    
        return NO;
    }
}

+ (void)logout {

    myUserData.nickname = @"";
    myUserData.genderIndex = 0;
    myUserData.password = @"";
    myUserData.authToken = @"";
    myUserData.mobileNo = @"";
    
    myUserData.balance = -1.0;
    myUserData.isRentForMonth = NO;
    
    [self savaData];
}

+ (void)savaData {

    [UserData saveObject:myUserData.nickname forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] setInteger:myUserData.genderIndex forKey:@"genderIndex"];
    [UserData saveObject:myUserData.password forKey:@"password"];
    [UserData saveObject:myUserData.authToken forKey:@"authToken"];
    [UserData saveObject:myUserData.mobileNo forKey:@"mobileNo"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveObject:(id)obj forKey:(NSString *)key {
    
    if (obj&&key) {
        
        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    }
}

+ (void)loadData {

    if (kIsNSString([[NSUserDefaults standardUserDefaults] stringForKey:@"nickname"])) {
        
        myUserData.nickname = [[NSUserDefaults standardUserDefaults] stringForKey:@"nickname"];
    }
    
    myUserData.genderIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"genderIndex"];
    
    if (kIsNSString([[NSUserDefaults standardUserDefaults] stringForKey:@"password"])) {
        
        myUserData.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    }
    
    if (kIsNSString([[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"])) {
        
        myUserData.authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"];
    }
    
    if (kIsNSString([[NSUserDefaults standardUserDefaults] stringForKey:@"mobileNo"])) {
        
        myUserData.mobileNo = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobileNo"];
    }
}

@end
