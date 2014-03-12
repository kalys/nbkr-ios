//
//  NBKRXMLParser.m
//  Pods
//
//  Created by Kalys Osmonov on 3/12/14.
//
//

#import "NBKRXMLParser.h"

@interface NBKRXMLParser ()

@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) NSString *currencyCode;
@property (nonatomic, assign) BOOL rateNode;
@property (nonatomic, retain) NSString *currencyRate;
@property (nonatomic, strong) NSMutableArray *result;

@end


NSXMLParser *xmlParser;

@implementation NBKRXMLParser

- (instancetype) initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        xmlParser = [[NSXMLParser alloc] initWithData:data];
        [xmlParser setDelegate:self];
    }
    return self;
}

- (NSArray *) parse {
    self.result = [NSMutableArray new];
    [xmlParser parse];
    return self.result;
}

#pragma mark NSXMLParserDelegate methods

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"CurrencyRates"]) {
        self.dateString = [attributeDict objectForKey:@"Date"];
    } else if ([elementName isEqualToString:@"Currency"]) {
        self.currencyCode = [attributeDict objectForKey:@"ISOCode"];
    } else if ([elementName isEqualToString:@"Value"]) {
        self.rateNode = YES;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.rateNode) {
        self.currencyRate = string;
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Value"]) {
        self.rateNode = NO;
    } else if ([elementName isEqualToString:@"Currency"]) {
        //[self.result setObject:@{@"rate": self.currencyRate, @"date": self.dateString} forKey:self.currencyCode];
        [self.result addObject:@{@"currency": self.currencyCode, @"rate": self.currencyRate, @"date": self.dateString}];
        
        self.currencyRate = nil;
        self.currencyCode = nil;
    }
}

@end
