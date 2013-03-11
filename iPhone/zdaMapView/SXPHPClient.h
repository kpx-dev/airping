//
//  SXPHPClient.h
//  zdaMapView
//
//  Created by Winfred Raguini on 3/10/13.
//  Copyright (c) 2013 Unknown. All rights reserved.
//

#import "AFHTTPClient.h"

@interface SXPHPClient : AFHTTPClient
+ (SXPHPClient *)sharedClient;
@end
