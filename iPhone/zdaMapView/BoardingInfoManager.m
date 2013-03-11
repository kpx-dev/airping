//
//  BoardingInfo.m
//  zdaMapView
//
//  Created by Winfred Raguini on 3/10/13.
//  Copyright (c) 2013 Unknown. All rights reserved.
//

#import "BoardingInfoManager.h"

@implementation BoardingInfoManager
- (id)initWithAttributes:(NSDictionary *)attributes
{
//    @property (readonly) NSUInteger postID;
//    @property (readonly) NSString *boardingTimeString;
//    @property (readonly) NSString *flight_status;
//    @property (readonly) NSString *flight_number;
//    @property (readonly) NSString *origin_code;
//    @property (readonly) NSString *destination_code;
//    @property (readonly) NSString *terminal;
//    @property (readonly) NSString *gate;
//    {"boarding":"2013-03-10T19:00:00.000-05:00","changed":null,"flight_status":"ON TIME","flight_number":"427","origin_code":"AUS","destination_code":"LAX","terminal":null,"gate":"13"}
    if (self = [super init]) {
        _boardingTimeString = [attributes valueForKeyPath:@"boarding"];
        _flight_status = [attributes valueForKeyPath:@"flight_status"];
        _origin_code = [attributes valueForKeyPath:@"origin_code"];
        _flight_number = [attributes valueForKeyPath:@"flight_number"];
        _destination_code = [attributes valueForKeyPath:@"destination_code"];
        _gate = [attributes valueForKeyPath:@"gate"];
        _terminal = [attributes valueForKeyPath:@"terminal"];
    }
    return self;
}
@end
