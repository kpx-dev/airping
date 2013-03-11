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
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapAnnotation.h"

/*!
 * View controller to display the map pointing out any mobile devices we are aware of.
 *
 * \author  Paul MacBeath
 * \date    08/05/11
 * \version 1.0
 * \brief   View controller to display the map.
 */
@interface MapViewController : UIViewController
{
    MKMapView *mapView;
    MapAnnotation *myAnnotation;
    CLLocationManager *locationManager;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) MapAnnotation *myAnnotation;

//- (void) setCurrentLocation:(CLLocation *)location;

@end
