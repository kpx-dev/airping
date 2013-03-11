/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  ZOS Communications, LLC (ÒZOSÓ) grants you a nonexclusive copyright license
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
#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"zdaMapViewAppDelegate");
    [pool release];
    return retVal;
}
