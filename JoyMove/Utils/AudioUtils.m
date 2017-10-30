//
//  AudioUtils.m
//  JoyMove
//
//  Created by ethen on 15/4/28.
//  Copyright (c) 2015年 xin.liu. All rights reserved.
//

#import "AudioUtils.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AudioUtils

+ (void)phoneVibrate {
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
