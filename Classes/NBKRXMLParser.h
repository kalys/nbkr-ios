//
//  NBKRXMLParser.h
//  Pods
//
//  Created by Kalys Osmonov on 3/12/14.
//
//

#import <Foundation/Foundation.h>

@interface NBKRXMLParser : NSObject<NSXMLParserDelegate>

- (NSArray *) parse:(NSData *)data;

@end
