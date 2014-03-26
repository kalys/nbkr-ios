//
//  CurrencyRate.h
//  nbkr-ios
//
//  Created by Kalys Osmonov on 3/16/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyRate : NSObject

+ (RACSignal *) fetchRates;

@end
