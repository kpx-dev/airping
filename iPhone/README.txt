-----------------------------------------------------------------------
                    zdaMapView Example App README.txt
                    ---------------------------------

    $HeadURL$
    $Rev$
    $Date$

    Abstract:  ReadMe file for the zdaMapView example app 

   ZOS Communications, LLC (“ZOS”) grants you a nonexclusive copyright license
   to use all programming code examples from which you can generate similar 
   function tailored to your own specific needs.
  
   All sample code is provided by ZOS for illustrative purposes only. These 
   examples have not been thoroughly tested under all conditions. ZOS, 
   therefore, cannot guarantee or imply reliability, serviceability, or 
   function of these *programs.
  
   All programs contained herein are provided to you "AS IS" without any 
   warranties of any kind. The implied warranties of non-infringement, 
   merchantability and fitness for a particular purpose are expressly 
   disclaimed. 

                  Copyright Zos Communications LLC, (c) 2012
-----------------------------------------------------------------------

CONTENTS
--------

1. Introduction
2. Prerequisites
3. Running the App
4. Known Issues

1. INTRODUCTION
---------------

The zdaMapView example application demonstrates how a developer can 
utilise the power of the ZDA framework within a simple iphone application.

The zdaMapView shall display the current location on a map and provide the
user the ability to send XML into the framework and obtain the results back,
e.g. GeoCoding an address, Reverse geocoding a position.

2. PREREQUISITES
----------------

    *   Mac OS X 10.6.8 or above
    *   XCode 4 IDE
    *   iPhone 4.2

You will also require a developer profile to allow you to deploy the app to
your device.

3. RUNNING THE APP
------------------

The following steps will allow you to compile, deploy, and run the app on an
iPhone 4.2 or above:

    *   Extract the zda library into the directory /Users/Shared/zda.Framework
    *   Open the project zdaMapView.xcodeproj in xcode 4
    *   Attach an iphone 4 device with a developer profile installed.
    *   Select the zdaMapView | Device Scheme
    *   Run the selected sheme.

This will run the app and allow you to observe the 

4. KNOWN ISSUES
---------------

4.1 Locate Other Devices
------------------------
The locator to add other devices onto the map has not been implemented within this
example project.  It requires XML parsing of the XML result from the ZDA library, and
any additional devices to be displayed on the map.


