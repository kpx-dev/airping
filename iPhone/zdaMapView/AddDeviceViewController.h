/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   The view controller to add a new device we want to start locating.
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

/*!
 * UI view controller to display an add device page to get the number/email
 * address of the contact we want to start tracking.
 *
 * \author  Paul MacBeath
 * \date    08/08/11
 * \version 1.0
 * \brief   The view controller to add a new device we want to start locating.
 */
@interface AddDeviceViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *deviceNumber;
    UILabel *deviceNumberLabel;
    UISegmentedControl *deviceTypes;
    UIButton *keyboardInputBackground;
}

@property (retain) UITextField *deviceNumber;
@property (retain) UILabel *deviceNumberLabel;
@property (retain) UISegmentedControl *deviceTypes;
@property (retain) UIButton *keyboardInputBackground;

@end
