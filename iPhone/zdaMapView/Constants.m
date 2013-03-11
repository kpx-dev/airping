/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   All the constant values defined for this example app
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
#import "Constants.h"

//format parameters must be in the following order: DEVICES
NSString * const LOCATION_REQUEST_XML           = @"<request>\n  <action>locate</action>\n  <devices>\n"
                                                  @"  %@\n  </devices>\n</request>";
NSString * const DEVICE_XML                     = @"<device>%@</device>";
NSString * const GEOCODE_REQUEST_XML            = @"<request>\n  <action>geocode</action>\n  <address>%@</address>\n</request>";
NSString * const REVERSE_GEOCODE_REQUEST_XML    = @"<request>\n  <action>reversegeocode</action>"
                                                  @"\n  <coordinates>\n    <latitude>%f</latitude>\n    <longitude>%f</longitude>"
                                                  @"\n  </coordinates>\n</request>";
NSString * const ATTRIBUTES_REQUEST_XML         = @"<request>\n  <action>attribute</action>\n  <attrs>\n    %@\n  </attrs>\n</request>";
NSString * const ATTRIBUTE_XML                  = @"<attr><desc>%@</desc><value>%@</value></attr>";

//Notification event strings
NSString * const LOCATION_UPDATE_EVENT          = @"location.update.event";
NSString * const XML_RESPONSE_EVENT             = @"xml.response.event";
NSString * const LOCATION_SHOT_RESPONSE_EVENT   = @"location.shot.response.event";
NSString * const ERROR_RECEIVED_EVENT           = @"error.event";
