/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Map annotation for displaying an image
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

#import "ImageAnnotationView.h"
#import "MapAnnotation.h"

#define kHeight 30
#define kWidth  10
#define kBorder 2

@implementation ImageAnnotationView
@synthesize imageView;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
	self.frame = CGRectMake(0, 0, kWidth, kHeight);
	//self.backgroundColor = [UIColor whiteColor];
	
	MapAnnotation* temp = (MapAnnotation*)annotation;
	
	UIImage* image = [UIImage imageNamed:temp.userData];
	imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = self.frame;
    
    [self addSubview:imageView];
	
	return self;
	
}

-(void) dealloc
{
	[imageView release];
	[super dealloc];
}


@end
