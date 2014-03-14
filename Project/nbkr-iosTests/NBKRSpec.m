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
#import "OCMock.h"
#import "NBKR.h"
#import "NBKRXMLParser.h"

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
            NSData *expectedBody = [NSData dataWithContentsOfFile:dailyFixturesPath];
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/daily.xml").
                andReturn(200).
                withBody(expectedBody);
            NSArray *expectedResult = @[@"ololo"];
            id parser = [OCMockObject mockForClass:[NBKRXMLParser class]];
            // [(NBKRXMLParser*) [parser expect] parse:expectedBody];
            [(NBKRXMLParser *)[[parser stub] andReturn:expectedResult] parse:expectedBody];
            NBKR *nbkr = [NBKR new];
            nbkr.parser = parser;
            [nbkr dailyCurrencyRates:^(NSArray *rates) {
                    expect(rates).to.equal(expectedResult);
                    [parser verify];
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
            NSData *expectedResponse = [NSData dataWithContentsOfFile:weeklyFixturesPath];
            stubRequest(@"GET", @"http://www.nbkr.kg/XML/weekly.xml").
                andReturn(200).
                withBody(expectedResponse);
            
            NSArray *expectedResult = @[@"ololo"];
            id parser = [OCMockObject mockForClass:[NBKRXMLParser class]];
            [(NBKRXMLParser *)[[parser stub] andReturn:expectedResult] parse:expectedResponse];
            NBKR *nbkr = [NBKR new];
            nbkr.parser = parser;
            
            [nbkr weeklyCurrencyRates:^(NSArray *rates) {
                expect(rates).to.equal(expectedResult);
                [parser verify];
                done();
            }
                                     error: nil
             ];
        });
    });
});

SpecEnd