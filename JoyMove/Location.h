//
//  Location.h
//  PetBar
//
//  Created by eThEn on 14/11/11.
//  Copyright (c) 2014年 EZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol LocationDelegate <NSObject>

//@optional
@required
- (void)didUpdateUserLocation:(CLLocationCoordinate2D)coor;

@end


@interface Location : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) id<LocationDelegate> delegate;

- (BOOL)update;
- (void)stop;

@end
