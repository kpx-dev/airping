/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:  View controller for allowing the user to send xml through the ZDA.
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
 */

#import <Foundation/Foundation.h>

/*!
 * View controller to allow the user to view examples
 * of sending xml through the zda framework.
 *
 * \version     1.0
 * \date        17th August 2011
 */
@interface SendXmlViewController : UIViewController
{
    UIButton *clearButton;
    UIButton *geocodeXmlButton;
    UIButton *reverseGeocodeXmlButton;
    UIButton *locateXmlButton;
    UIButton *attributeXmlButton;
    
    UIButton *showHideResponseButton;
    UITextView *xmlInputTextView;
    UITextView *responseTextView;
    UIActivityIndicatorView *activityView;
    BOOL showingResponseTextView;
}

@property (nonatomic, retain) UIButton *clearButton;
@property (nonatomic, retain) UIButton *geocodeXmlButton;
@property (nonatomic, retain) UIButton *reverseGeocodeXmlButton;
@property (nonatomic, retain) UIButton *locateXmlButton;
@property (nonatomic, retain) UIButton *attributeXmlButton;

@property (nonatomic, retain) UITextView *xmlInputTextView;
@property (nonatomic, retain) UITextView *responseTextView;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UIButton *showHideResponseButton;

@end
