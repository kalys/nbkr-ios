//
//  NBKR.h
//  nbkr-ios
//
//  Created by Kalys Osmonov on 12/14/13.
//  Copyright (c) 2013 Kalys Osmonov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NBKRXMLParser;

@interface NBKR : NSObject

@property (nonatomic, strong) NBKRXMLParser *parser;

- (void) dailyCurrencyRates:(void (^)(NSDictionary *)) response error:(void(^)(NSError *)) error;
- (void) weeklyCurrencyRates:(void (^)(NSDictionary *)) response error:(void(^)(NSError *)) error;

@end
