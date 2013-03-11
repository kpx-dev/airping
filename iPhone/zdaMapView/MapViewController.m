/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   The view controller to display a map displaying the location of any mobile devices we have been sent
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

#import "MapViewController.h"
#import "ImageAnnotationView.h"
#import "Constants.h"
#import "ZDAEventManager.h"

@implementation MapViewController
@synthesize mapView;
@synthesize myAnnotation;

/*!
 * Override the NSObject init method to initialise the about view controller
 *
 * \return  id  returns the 'this' pointer of the created AboutViewController object
 */
-(id) init
{
    self = [super init];
    
    if (self != nil)
    {
        self.title = @"Map";
        self.view.backgroundColor = [UIColor blackColor];
        
        //create the tab bar item for this view
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"103-map.png"] tag:0];
        self.tabBarItem = item;
        [item release];
    }
    
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
    
    //now create and add the map to the view
    mapView = [[MKMapView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:mapView];
    
    //add ourselves as a listener of location events received from the zda framework
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCurrentLocation:) name:LOCATION_UPDATE_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setCurrentLocation:) name:LOCATION_SHOT_RESPONSE_EVENT object:nil];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    
    //unregister from the notification center for location update events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOCATION_UPDATE_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOCATION_SHOT_RESPONSE_EVENT object:nil];
}

- (void) dealloc
{
    [myAnnotation release];
    [super dealloc];
}

/*!
 *
 */
- (void) setCurrentLocation:(NSNotification *)notification
{
    CLLocation *location = (CLLocation*) [notification object];
        
    if (myAnnotation == nil)
    {
        myAnnotation = [[[MapAnnotation alloc] initWithCoordinate:[location coordinate]
                                                   annotationType:MapAnnotationTypeImage
                                                            title:@"My Device"] autorelease];
        [myAnnotation setUserData:@"32-iphone.png"];
        [self.mapView addAnnotation:myAnnotation];
    }
    else
    {
        //remove and re-add the annotation on the map for our position
        [self.mapView removeAnnotation:myAnnotation];
        myAnnotation.coordinate = [location coordinate];
        [self.mapView addAnnotation:myAnnotation];
    }
    
    //zoom into a region where the device is
    MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
    region.center = location.coordinate;
    region.span.longitudeDelta = 0.20f;
    region.span.latitudeDelta = 0.20f;
    [self.mapView setRegion:region animated:YES];
}

@end
