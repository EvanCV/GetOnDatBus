//
//  BusStopDetails.h
//  GetOnDatBus
//
//  Created by Evan Vandenberg on 1/20/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusStopDetails : NSObject

@property NSNumber *busStopID;
@property NSString *busTransfers;
@property NSString *intermodalTransfers;
@property NSNumber *stopLatitude;
@property NSNumber *stopLongitude;
@property NSString *busStopWebAddress;
@property NSString *busStopName;


@end
