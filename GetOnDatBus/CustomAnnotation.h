//
//  CustomAnnotation.h
//  GetOnDatBus
//
//  Created by Evan Vandenberg on 1/20/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BusStopDetails.h"

@interface CustomAnnotation : MKPointAnnotation

@property BusStopDetails *busStopAnnotation;

@end
