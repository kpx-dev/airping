/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Header file which contains the constant values for this example app
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

/*******************************************************************************
  API_KEY and API_PASSWORD are used to authenticate the app with zda
  Please request genuine API/PW from zos support, and update the defines below. 
  The #warning can then be removed.
******************************************************************************/
#warning Please contact support@zoscomm.com for genuine API_KEY and API_PASSWORD
#define API_KEY         @"93f91046-7b08-11e2-916a-12313d23a402"
#define API_PASSWORD    @"ab9c7b07"
    
extern NSString * const LOCATION_REQUEST_XML;
extern NSString * const DEVICE_XML;
extern NSString * const GEOCODE_REQUEST_XML;
extern NSString * const REVERSE_GEOCODE_REQUEST_XML;
extern NSString * const ATTRIBUTES_REQUEST_XML;
extern NSString * const ATTRIBUTE_XML;

//notification event names
extern NSString * const LOCATION_UPDATE_EVENT;
extern NSString * const XML_RESPONSE_EVENT;
extern NSString * const LOCATION_SHOT_RESPONSE_EVENT;
extern NSString * const ERROR_RECEIVED_EVENT;