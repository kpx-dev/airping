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

#import <Foundation/Foundation.h>
#import <zda/ZDATypes.h>

typedef enum DeviceState
{
    AWAITING_RESPONSE   = 0,
    PERMISSION_RECEIVED,
    PERMISSION_REJECTED
} DeviceState;

/*!
 * Data class to contain all the data for each device we are interested in.
 *
 * \author  Paul MacBeath
 * \date    08/08/11
 * \version 1.0
 * \brief   Data class to contain all the data for each device we are interested in.
 */
@interface DeviceData : NSObject 
{
    ///! \brief The last request id for any xml sent for this displayId - probably should be an array of requestIds!
    requestId lastRequestId;
    
    ///! \brief The device state.  We can only receive location updates from devices in the PERMISSION_RECEIVED state
    DeviceState deviceState;
    
    ///! \brief Set to YES if the device location is to be displayed on the map
    BOOL displayOnMap;
    
    ///! \brief The number/email address of the device to track
    NSString *deviceId;
}

@property (assign) requestId lastRequestId;
@property (assign) DeviceState deviceState;
@property (assign) BOOL displayOnMap;
@property (copy, readonly) NSString *deviceId;

-(id) initWithDeviceId:(NSString*)device;
-(id)copyWithZone:(NSZone *)zone;

@end
