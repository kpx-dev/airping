/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Example view controller which gathers all the required data from the
 *              user and requests a location shot.  Displayign the response as a result.
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

#import <Foundation/Foundation.h>

/*!
 * View Controller to example utilising the ZDA API to 
 * request a location shot from the ZOS Server.
 *
 * \version 1.0
 * \date    16 August 2011
 */
@interface RequestLocationShotViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *accuracy;
    UILabel *accuracyLabel;
    UITextField *timeout;
    UILabel *timeoutLabel;
    UIButton *keyboardInputBackground;
    UITextField *selectedTextField;
    UILabel *timeoutCountdownLabel;
    UITextView *locationShotOutputResult;
    UIActivityIndicatorView *activityView;
    BOOL shotResponseReceived;
}

@property (nonatomic, retain) UITextField *accuracy;
@property (nonatomic, retain) UILabel *accuracyLabel;
@property (nonatomic, retain) UITextField *timeout;
@property (nonatomic, retain) UILabel *timeoutLabel;
@property (retain) UIButton *keyboardInputBackground;
@property (nonatomic, retain) UITextView *locationShotOutputResult;
@property (retain) UIActivityIndicatorView *activityView;

@end
