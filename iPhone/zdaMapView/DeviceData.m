/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Data class to hold all the information provided from the zda for each device we are interested in
 *
 *  ZOS Communications, LLC (“ZOS”) grants you a nonexclusive copyright license
 *  to use all programming code examples from which you can generate similar 
 *  function tailored to your own specific needs.
 * 
 *  All sample code is provided by ZOS for illustrative purposes only. These 
 *  examples have not been thoroughly tested under all conditions. ZOS, 
 *  therefore, cannot guarantee or imply reliability, serviceability, or 
 *  function of these *programs.
 * 
 *  All programs contained herein are provided to you "AS IS" without any 
 *  warranties of any kind. The implied warranties of non-infringement, 
 *  merchantability and fitness for a particular purpose are expressly 
 *  disclaimed. 
 *
 *  Copyright Zos Communications LLC, (c) 2012
 *
 */

#import "DeviceData.h"


@implementation DeviceData
@synthesize lastRequestId;
@synthesize deviceState;
@synthesize deviceId;
@synthesize displayOnMap;

-(id) initWithDeviceId:(NSString*)device
{
    self = [super init];
    
    if (self != nil)
    {
        deviceId = [device copy];
        lastRequestId = 0;
        deviceState = AWAITING_RESPONSE;
        displayOnMap = YES;
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    DeviceData *copy = [[DeviceData allocWithZone:zone] initWithDeviceId:self.deviceId];
    copy.lastRequestId = self.lastRequestId;
    copy.deviceState = self.deviceState;
    copy.displayOnMap = self.displayOnMap;
    
    return copy;
}

@end
