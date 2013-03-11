/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Singleton class to contain all the ZDA data and trigger some app events of its own.
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
#import <zda/ZDAEventListener.h>
#import <CoreLocation/CoreLocation.h>
#import "DeviceData.h"
#import <zda/ZDAClassFactory.h>

/*!
 * Singleton class to contain all the latest ZDA data which can be obtained
 * throughout the application.  This will also trigger some events to any 
 * application listeners.
 *
 * \author  Paul MacBeath
 * \date    08/05/11
 * \version 1.0
 * \brief   Singleton class to contain all the ZDA data and trigger some app events of its own.
 */
@interface ZDAEventManager : NSObject<ZDAEventListener>
{
    userToken zdaUserToken;
    NSString *zdaVersion;
    int messageCount;
    
    UIViewController *tempController;
    NSMutableArray *devices;
    CLLocation *currentLocation;
}

@property (copy) userToken zdaUserToken;
@property (copy) NSString *zdaVersion;
@property (assign) int messageCount;
@property (retain) UIViewController *tempController;
@property (retain) CLLocation *currentLocation;
@property (retain) ZDAEventService *zes;

+ (ZDAEventManager *)getInstance;

-(void) authenticateUser:(NSString*)api WithPassword:(NSString*)password UsingViewController:(UIViewController*)controller;
-(void) requestLocationShotWithAccuracy:(int) accuracy AndTimeout:(int) timeout;
-(requestId) sendXML:(NSString*)xml;

-(void) addDevice:(NSString*)deviceId;
-(void) removeDevice:(int)row;
-(DeviceData*) getDeviceData:(int)row;
-(int) getDeviceCount;

-(requestId) requestDeviceUpdate:(int)row;
-(CLLocation*) convertGeoLocation:(GeoLocation*)location;

@end
