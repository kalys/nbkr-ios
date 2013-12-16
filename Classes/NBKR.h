//
//  NBKR.h
//  nbkr-ios
//
//  Created by Kalys Osmonov on 12/14/13.
//  Copyright (c) 2013 Kalys Osmonov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBKR : NSObject<NSXMLParserDelegate>

+ (id) sharedInstance;
+ (void) resetInstance;

- (void) currencyRates:(void (^)(NSDictionary *)) response error:(void(^)(NSError *)) error;

@property (atomic, retain) NSMutableDictionary *result;

@end
