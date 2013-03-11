//
//  SXPHPClient.m
//  zdaMapView
//
//  Created by Winfred Raguini on 3/10/13.
//  Copyright (c) 2013 Unknown. All rights reserved.
//

#import "SXPHPClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const kAFPHPAPIBaseURLString = @"http://staging2.sendgrid.net/aa.php";

@implementation SXPHPClient
+ (SXPHPClient *)sharedClient {
    static SXPHPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SXPHPClient alloc] initWithBaseURL:[NSURL URLWithString:kAFPHPAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}
@end
