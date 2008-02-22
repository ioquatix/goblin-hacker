//
//  NSData+Values.h
//  Goblin Hacker
//
//  Created by Administrator on 21/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSArray(Values)

// Assumes an array of NSData
- (uint8_t) byteValueAtIndex: (NSUInteger)byteIndex line: (NSUInteger)lineOffset;
- (uint32_t) intValueAtIndex: (NSUInteger)intIndex line:(NSUInteger)lineOffset;

- (void) setByteValue: (uint8_t)val atIndex: (NSUInteger)byteIndex ofLine: (NSUInteger)lineOffset;
- (void) setIntValue: (uint32_t)val atIndex: (NSUInteger)intIndex ofLine: (NSUInteger)lineOffset;

@end

@interface NSData(Values)

- (uint8_t) byteValueAtIndex: (NSUInteger)byteIndex;
- (uint32_t) intValueAtIndex: (NSUInteger)intIndex;

@end

@interface NSMutableData(Values)

- (void) setByteValue: (uint8_t)val atIndex: (NSUInteger)byteIndex;
- (void) setIntValue: (uint32_t)val atIndex: (NSUInteger)intIndex;

@end