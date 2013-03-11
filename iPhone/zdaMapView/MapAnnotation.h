/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Map annotation data to add to the map view
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

// types of annotations for which we will provide annotation views.
typedef enum 
{
    MapAnnotationTypeStart  = 0,
    MapAnnotationTypeEnd    = 1,
    MapAnnotationTypeImage  = 2
} MapAnnotationType;

/*!
 * Implement the MKAnnotation interface to provice the data for an item on the map.
 *
 * \author  Paul MacBeath
 * \date    08/05/11
 * \version 1.0
 * \brief   Map annotation object to contain all the data for an item on the map
 */
@interface MapAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    MapAnnotationType annotationType;
    NSString* title;
    NSString* subtitle;
    NSString* userData;
    NSURL* url;
}

-(id) initWithCoordinate:(CLLocationCoordinate2D)coords
          annotationType:(MapAnnotationType) theType
                   title:(NSString*)theTitle;

@property MapAnnotationType annotationType;
@property (nonatomic, retain) NSString* userData;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
