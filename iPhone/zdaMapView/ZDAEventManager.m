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
 *  Copyright Zos Communications LLC, (c) 2011
 *
 */

#import "ZDAEventManager.h"
#import "Constants.h"
#import "DeviceData.h"

static ZDAEventManager *sharedInstance = nil;

@implementation ZDAEventManager
@synthesize zdaUserToken;
@synthesize zdaVersion;
@synthesize tempController;
@synthesize currentLocation;
@synthesize messageCount;
@synthesize zes;

/////////////////////////////SINGLETON IMPLEMENTATION///////////////////////////////

-(void) initMemberVariables
{
    //setup the devices array for adding all the device information to
    devices = [[NSMutableArray alloc] init];
    messageCount = 0;
}

/*!
 * Implementing the singleton design pattern provide a getter method to return 
 * the one and only instance of the class.
 *
 * \return  ZDAEventManager*    Pointer to the one and only instance of the class
 */
+ (ZDAEventManager *)getInstance
{
    @synchronized (self)
    {
        if (sharedInstance == nil) 
        {
            //alloc here will eventually call allocWithZone below where the sharedInstance 
            //object is actually assigned.  This stops any developers manually allocing an instance
            //and not going through this method.
            [[self alloc] init];
        }
    }
    
    return sharedInstance;
}

/*!
 * Create the one and only instance of the singleton class
 * or return nil to anyone who is trying to create another
 * instance of the singleton.
 */
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) 
    {
        if (sharedInstance == nil) 
        {
            sharedInstance = [super allocWithZone:zone];
            [sharedInstance initMemberVariables];
            
            //make a call to assign the zda version
            ZDAEventService *zes = [ZDAClassFactory getEventService];
            [zes getVersion:sharedInstance];
            
            return sharedInstance;
        }
    }
    
    return nil;
}



- (void)dealloc
{
    [super dealloc];
    
    [devices release];
    devices = nil;
}

////////////////////////////////////INSTANCE METHODS///////////////////////////////////////////////

/*!
 * authenticate user against the ZOS server.
 */
-(void) authenticateUser:(NSString*)api WithPassword:(NSString*)password UsingViewController:(UIViewController*)controller
{
    self.tempController = controller;
    
    assert(controller);
    
    self.zes = [ZDAClassFactory getEventService:controller];
    
    [self.zes authenticateUser:api :password :sharedInstance];
}

/*!
 * request has been made to get a location shot with the inputted accuracy and
 * timeout values.
 */
-(void) requestLocationShotWithAccuracy:(int) accuracy AndTimeout:(int) timeout
{
    @synchronized (zdaUserToken)
    {
        if (zdaUserToken != nil && [zdaUserToken compare:@""] != NSOrderedSame)
        {
           assert(self.zes);
           //get the event service and make the location shot request
           [self.zes requestLocationShot:zdaUserToken :accuracy :timeout :sharedInstance];
        }
    }
}

/*!
 * Create some XML and send it through the ZDA to get device location information for the 
 * inputted number/email address.
 */
-(void) addDevice:(NSString*)deviceId
{
    if ([deviceId compare:@""] == NSOrderedSame) return; //do nothing blank device id string
    
    //create the devices list (of size 1)
    NSString *deviceXml = [NSString stringWithFormat:DEVICE_XML, deviceId];
    
    //now create the xml to sent into the zda
    //format parameters must be in the following order: DEVICES
    NSString *xml = [NSString stringWithFormat:LOCATION_REQUEST_XML, deviceXml];
    
    //this asynchronously sends the xml to the server.  We need to await a response to see if it succeeded.
    assert(self.zes);
    requestId dataRequestId = [self.zes sendXml:zdaUserToken :xml :sharedInstance];
    
    DeviceData *data = [[DeviceData alloc] initWithDeviceId:deviceId];
    data.lastRequestId = dataRequestId;
    
    [devices addObject:data];
    [data release];
}

/*!
 * Device has been requested to be deleted from the example app.
 */
-(void) removeDevice:(int)row
{
    [devices removeObjectAtIndex:row];
}

/*!
 * \return  DeviceData  Return the DeviceData object at the specified row
 */
-(DeviceData*) getDeviceData:(int)row
{
    return [devices objectAtIndex:row];
}

/*!
 * \return  int     Return the number of devices held for monitoring
 */
-(int) getDeviceCount
{
    return [devices count];
}

-(requestId) requestDeviceUpdate:(int)row
{
    DeviceData *data = [devices objectAtIndex:row];
    if (data == nil) return 0;
    
    //create the devices list (of size 1)
    NSString *deviceXml = [NSString stringWithFormat:DEVICE_XML, data.deviceId];
    
    //now create the xml to sent into the zda
    //format parameters must be in the following order: DEVICES
    NSString *xml = [NSString stringWithFormat:LOCATION_REQUEST_XML, deviceXml];
    
    //this asynchronously sends the xml to the server and returns the requestId to the caller
    assert(self.zes);
    return [self.zes sendXml:zdaUserToken :xml :sharedInstance];
}

-(requestId) sendXML:(NSString*)xml
{
    //this asynchronously sends the xml to the server and returns the requestId to the caller
    assert(self.zes);
    return [zes sendXml:zdaUserToken :xml :sharedInstance];
}

/*!
 * Update any xml event listeners of the received xml (should also include 
 * the request id for any proper implementations).
 */
-(void) notifyXmlResponseListeners:(NSString*)xml
{
    if ([NSThread isMainThread])
    {
        //post a notification in the main thread to any listeners
        [[NSNotificationCenter defaultCenter] postNotificationName:XML_RESPONSE_EVENT object:xml];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(notifyXmlResponseListeners:) withObject:xml waitUntilDone:NO];
    }
}

//////////////////////////////ZDAEVENTLISTENER IMPLEMENTATION//////////////////////////////////////

/**
 * An authentication complete message has been received from the ZDA.
 * Inform any listeners of this being complete and with the token which
 * was received.
 * 
 * @param token The token obtained via ZDAEventListener->onAuthenticationComplete 
 * @returns void
 * @see ZDAEventListener 
 */
-(void) onAuthenticationComplete: (userToken) token
{
    NSLog(@"onAuthenticationComplete received with token: %@", token);
    
    @synchronized (zdaUserToken)
    {
        self.zdaUserToken = token;
        
        //add ourselves as a listener for location update events
        assert(self.zes);
        [self.zes addLocationUpdateListener:token :sharedInstance];
        [self.zes addMessageCountUpdateListener:token :sharedInstance];        
    }
}

-(void) postErrorNotification: (NSString*)reason
{
    //post the error in the main thread for this example app
    if ([NSThread isMainThread])
    {
        //post a notification in the main thread to any listeners
        [[NSNotificationCenter defaultCenter] postNotificationName:ERROR_RECEIVED_EVENT object:reason];
    }
}

/**
 * An error has been received from the ZDA.
 * Inform any listeners of this error.
 *
 * @param erorCode The error code (eZdaErrors)
 * @param reason Descriptive reason
 * @see eZdaErrors
 */
-(void) onError: (int) errorCode: (string) reason
{
    NSLog(@"onError received with error code: %d", errorCode);
    NSLog(@"onError received with reason: %@", reason);
    
    [self performSelectorOnMainThread:@selector(postErrorNotification:) 
    	withObject:reason waitUntilDone:NO];
}

/**
 Invoked when the on-demand location shot request determines a location that 
 matches or exceeds the requested criteria.
 @param location Location details from ZOS server
 @returns void
 */
-(void) onLocationShotResponse: (GeoLocation*) location
{
    @synchronized (currentLocation)
    {
        NSLog(@"onLocationShotResponse: Location: %@", [location description]);
        self.currentLocation = [self convertGeoLocation:location];
    }
    
    
    //update the example app location in the main thread
    if ([NSThread isMainThread])
    {
        //post a notification in the main thread to any listeners
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_SHOT_RESPONSE_EVENT object:[self convertGeoLocation:location]];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(onLocationShotResponse:) withObject:location waitUntilDone:NO];
    }
}

/**
 Invoked when the device's location has been updated.
 @param location Location details from ZOS server
 @returns void
 */
-(void) onLocationUpdate: (GeoLocation*) location
{
    @synchronized (currentLocation)
    {
        NSLog(@"onLocationUpdate: Location: %@", [location description]);
        self.currentLocation = [self convertGeoLocation:location];
    }
    
    //update the example app location in the main thread
    if ([NSThread isMainThread])
    {
        //post a notification in the main thread to any listeners
        [[NSNotificationCenter defaultCenter] postNotificationName:LOCATION_UPDATE_EVENT object:[self convertGeoLocation:location]];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(onLocationUpdate:) withObject:location waitUntilDone:NO];
    }
}

/**
 Invoked when the message count has changed.
 @param count The current count of messages for the account
 @returns void
 */
-(void) onMessageNotify: (int) count
{
    NSLog(@"onMessageNotify: message count is: %d", count);
    
    self.messageCount = count;
}

/**
 Invoked when the server sends an XML response to the device.
 @param id ID of the original XML post
 @param xml XML response to XML post
 @returns void
 */
-(void) onXMLResponse: (requestId) id: (string) xml
{
    NSLog(@"onXMLResponse: id:%d XML:%@", id, xml);
    
    [self performSelectorOnMainThread:@selector(notifyXmlResponseListeners:) withObject:xml waitUntilDone:NO];
}

/**
 Invoked to indicate the version of ZDA currently built against. 
 @param version The version string of the ZDA library
 @returns void
 */
-(void) onVersionResponse: (string) version
{
    NSLog(@"onVersionResponse: %@", version);
    
    @synchronized (zdaVersion)
    {
        self.zdaVersion = version;
    }
}

/*!
 * handle onComplete callbacks
 */
-(void) onComplete:(int) actionCode: (string) param
{
    NSLog(@"onComplete: (%d) \"%@\"", actionCode,param);
}

/*!
 * Convert the GeoLocation type into a CoreLocation CLLocation type
 */
-(CLLocation*) convertGeoLocation:(GeoLocation*)location
{
  CLLocationCoordinate2D coord;
	coord.latitude = location.latitude;
	coord.longitude = location.longitude;
    
	CLLocation* tmp =[[[CLLocation alloc] initWithCoordinate:coord altitude:-1 
      horizontalAccuracy:location.accuracy verticalAccuracy:-1 course:0 
      speed:location.speed timestamp:location.timestamp] autorelease];
    
	return tmp;
}

@end
