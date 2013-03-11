/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Example view controller which utilises the ZDA API to:
 *                  Request a location shot
 *                  Send XML to the ZOS server
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
#import "FunctionsTableViewController.h"
#import "RequestLocationShotViewController.h"
#import "MessageCountViewController.h"
#import "SendXmlViewController.h"

/*!
 * View Controller to example utilising the ZDA API to 
 * provide additional functionality within an app.
 *
 * \version 1.0
 * \date    16 August 2011
 */
@interface FunctionsViewController : UIViewController<FunctionsActionDelegate>
{
    FunctionsTableViewController *tableViewController;
    RequestLocationShotViewController *locationShotViewController;
    MessageCountViewController *messageCountViewController;
    SendXmlViewController *sendXmlViewController;
}

@property (nonatomic, retain) FunctionsTableViewController *tableViewController;
@property (nonatomic, retain) RequestLocationShotViewController *locationShotViewController;
@property (nonatomic, retain) MessageCountViewController *messageCountViewController;
@property (nonatomic, retain) SendXmlViewController *sendXmlViewController;

@end
