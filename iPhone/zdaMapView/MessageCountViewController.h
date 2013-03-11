/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:  View controller for displaying the current geo-message count.
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
 */

#import <Foundation/Foundation.h>

/*!
 * View controller for displaying the current message count
 * from the ZOS server.
 *
 * \version     1.0
 * \date        16 August 2011
 */
@interface MessageCountViewController : UIViewController
{
    UILabel *messageCountLabel;
}

@property (nonatomic, retain) UILabel *messageCountLabel;

@end
