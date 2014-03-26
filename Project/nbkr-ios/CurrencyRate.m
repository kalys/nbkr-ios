//
//  CurrencyRate.m
//  nbkr-ios
//
//  Created by Kalys Osmonov on 3/16/14.
//  Copyright (c) 2014 Kalys Osmonov. All rights reserved.
//

#import "CurrencyRate.h"
#import <NBKR.h>

@implementation CurrencyRate

+ (RACReplaySubject *) fetchDailyRates {
    RACReplaySubject *subject = [RACReplaySubject subject];
    [[NBKR new] dailyCurrencyRates:^(NSDictionary *response) {
        [subject sendNext:response];
        [subject sendCompleted];
    } error:^(NSError *error) {
        [subject sendError:error];
    }];
    return subject;
}

+ (RACReplaySubject *) fetchWeeklyRates {
    RACReplaySubject *subject = [RACReplaySubject subject];
    [[NBKR new] weeklyCurrencyRates:^(NSDictionary *response) {
        [subject sendNext:response];
        [subject sendCompleted];
    } error:^(NSError *error) {
        [subject sendError:error];
    }];
    return subject;
}

+ (RACSignal *) fetchRates {
    return [RACSignal combineLatest: @[ [self fetchDailyRates], [self fetchWeeklyRates]]
            reduce:(id)^id(NSDictionary *daily, NSDictionary *weekly) {
                return @[daily, weekly];
            }];
}

@end
