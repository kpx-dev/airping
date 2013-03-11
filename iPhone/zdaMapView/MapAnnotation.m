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

#import "MapAnnotation.h"
#import "ImageAnnotationView.h"

@implementation MapAnnotation
@synthesize coordinate;
@synthesize annotationType;
@synthesize userData;
@synthesize url;

-(id) initWithCoordinate:(CLLocationCoordinate2D)coords annotationType:(MapAnnotationType) theType title:(NSString*)myTitle
{
	self = [super init];
	coordinate = coords;
	title      = [myTitle retain];
	annotationType = theType;
	
	return self;
}

- (NSString *)title
{
	return title;
}

- (NSString *)subtitle
{
	NSString* strSubtitle = nil;
	
	if(annotationType == MapAnnotationTypeStart || 
       annotationType == MapAnnotationTypeEnd)
	{
		strSubtitle = [NSString stringWithFormat:@"%lf, %lf", coordinate.latitude, coordinate.longitude];
	}
	
	return strSubtitle;
}

-(void) dealloc
{
	[title    release];
	[userData release];
	[url      release];
	
	[super dealloc];
}

@end
