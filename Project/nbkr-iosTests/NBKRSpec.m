//
//  nbkr_iosTests.m
//  nbkr-iosTests
//
//  Created by Kalys Osmonov on 12/14/13.
//  Copyright (c) 2013 Kalys Osmonov. All rights reserved.
//

#define EXP_SHORTHAND

#import "Specta.h"
#import "Expecta.h"
#import "Nocilla.h"
#import "NBKR.h"

SpecBegin(NBKR)

beforeAll(^{
    [[LSNocilla sharedInstance] start];
});

afterAll(^{
    [[LSNocilla sharedInstance] stop];
});

afterEach(^{
    [[LSNocilla sharedInstance] clearStubs];
});

describe(@"dailyCurrencyRates:error", ^{
    context(@"when response is OK", ^{
        it(@"should call successful block with data dictionary", ^AsyncBlock {
            NSString *dailyFixturesPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"daily_valid_currencies" ofType:@"xml"];
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/daily.xml").
                andReturn(200).
                withBody([NSData dataWithContentsOfFile:dailyFixturesPath]);
            
            [[NBKR new] dailyCurrencyRates:^(NSArray *rates) {
                                            expect(rates).notTo.beEmpty();
                                            expect([[rates objectAtIndex:0] objectForKey:@"currency"]).to.equal(@"USD");
                                            done();
                                        }
                                     error: nil
            ];
        });
    });
    
    context(@"when request is not OK", ^{
        it(@"should call error block with error object", ^AsyncBlock {
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/daily.xml").
                andReturn(404);
            
            [[NBKR new] dailyCurrencyRates:nil
                                     error:^(NSError *error) {
                                         NSLog(@"%@", error);
                                         done();
                                     }
             ];
        });
    });
    
    context(@"when totally unknown error is occured", ^{
        it(@"should call error block with error object", ^AsyncBlock {
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/daily.xml").
                andFailWithError([NSError errorWithDomain:@"foo" code:123 userInfo:nil]);
            [[NBKR new] dailyCurrencyRates:nil
                                     error:^(NSError *error) {
                                         NSLog(@"%@", error);
                                         done();
                                     }
             ];
        });
    });
});

describe(@"weeklyCurrencyRates:error", ^{
    context(@"when response is OK", ^{
        it(@"should call successful block with data dictionary", ^AsyncBlock {
            NSString *weeklyFixturesPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"weekly_valid_currencies" ofType:@"xml"];
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/weekly.xml").
            andReturn(200).
            withBody([NSData dataWithContentsOfFile:weeklyFixturesPath]);
            
            [[NBKR new] weeklyCurrencyRates:^(NSArray *rates) {
                expect(rates).notTo.beEmpty();
                expect([[rates objectAtIndex:0] objectForKey:@"currency"]).to.equal(@"GBP");
                done();
            }
                                     error: nil
             ];
        });
    });
    
    context(@"when request is not OK", ^{
        it(@"should call error block with error object", ^AsyncBlock {
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/weekly.xml").
            andReturn(404);
            
            [[NBKR new] weeklyCurrencyRates:nil
                                     error:^(NSError *error) {
                                         NSLog(@"%@", error);
                                         done();
                                     }
             ];
        });
    });
    
    context(@"when totally unknown error is occured", ^{
        it(@"should call error block with error object", ^AsyncBlock {
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/weekly.xml").
            andFailWithError([NSError errorWithDomain:@"foo" code:123 userInfo:nil]);
            [[NBKR new] weeklyCurrencyRates:nil
                                     error:^(NSError *error) {
                                         NSLog(@"%@", error);
                                         done();
                                     }
             ];
        });
    });

});

/*
describe(@"currencyRates:error", ^{
    context(@"when online", ^{
 
        beforeEach(^{
            [NBKR resetInstance];
            NSString *dailyFixturesPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"daily_valid_currencies" ofType:@"xml"];
            NSString *weeklyFixturesPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"weekly_valid_currencies" ofType:@"xml"];
            
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/daily.xml").
                andReturn(200).
                withBody([NSData dataWithContentsOfFile:dailyFixturesPath]);
            
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/weekly.xml").
                andReturn(200).
                withBody([NSData dataWithContentsOfFile:weeklyFixturesPath]);
        });
        
        it(@"should return list of currencies", ^AsyncBlock {
            [[NBKR sharedInstance] currencyRates:^(NSDictionary *response){
                expect(response).notTo.beEmpty();
                
                expect([response objectForKey:@"USD"]).to.beKindOf([NSDictionary class]);
                expect([response objectForKey:@"RUB"]).to.beKindOf([NSDictionary class]);
                
                expect([[response objectForKey:@"USD"] objectForKey:@"rate"]).to.equal(@"29,2717");
                expect([[response objectForKey:@"RUB"] objectForKey:@"rate"]).to.equal(@"1,4992");
                
                done();
            }
            error:nil];
        });
    });
 */
    
    /*
     
    TODO: v1.1
     
    context(@"when something wrong with internet or server is down", ^{
        beforeEach(^{
            
            [NBKR resetInstance];
            // successful requests
            NSString *dailyFixturesPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"daily_valid_currencies" ofType:@"xml"];
            NSString *weeklyFixturesPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"weekly_valid_currencies" ofType:@"xml"];
            
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/daily.xml").
            andReturn(200).
            withBody([NSData dataWithContentsOfFile:dailyFixturesPath]);
            
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/weekly.xml").
            andReturn(200).
            withBody([NSData dataWithContentsOfFile:weeklyFixturesPath]);
            
            [[NBKR sharedInstance] currencyRates:^(NSDictionary * response) {} error:nil];
            
            [NSThread sleepForTimeInterval:1.0];
            [[LSNocilla sharedInstance] clearStubs];
            [NBKR resetInstance];
            
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/daily.xml").andReturn(503);
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/weekly.xml").andReturn(503);
        });

        it(@"should read data from file when there is no internet connection", ^AsyncBlock {
            [[NBKR sharedInstance] currencyRates: ^(NSDictionary *response) {
                expect(response).notTo.beEmpty();
                expect([response objectForKey:@"USD"]).to.beKindOf([NSDictionary class]);
                expect([response objectForKey:@"RUB"]).to.beKindOf([NSDictionary class]);
                done();
            }
            error: nil];
        });
        
        it(@"should call error block if there is old cache file", ^{});
    });
     */
/*
});
*/
SpecEnd