//
//  NSData+Values.m
//  Goblin Hacker
//
//  Created by Samuel Williams on 21/02/08.
//  Copyright 2008 Samuel Williams, Orion Transfer Ltd. All rights reserved.
//

#import "NSData+Values.h"
#include "Endian.h"

@implementation NSArray(Values)

- (uint8_t) byteValueAtIndex: (NSUInteger)byteIndex line: (NSUInteger)lineOffset {
	NSData * data = [self objectAtIndex:lineOffset];
	assert(data != nil);
	
	return [data intValueAtIndex:byteIndex];
}

- (uint32_t) intValueAtIndex: (NSUInteger)intIndex line: (NSUInteger)lineOffset {
	NSData * data = [self objectAtIndex:lineOffset];
	assert(data != nil);
	
	return [data intValueAtIndex:intIndex];
}

- (void) setByteValue: (uint8_t)val atIndex: (NSUInteger)byteIndex ofLine: (NSUInteger)lineOffset {
	NSMutableData * data = [self objectAtIndex:lineOffset];
	assert(data != nil);
	
	[data setByteValue:val atIndex:byteIndex];	
}

- (void) setIntValue: (uint32_t)val atIndex: (NSUInteger)intIndex ofLine: (NSUInteger)lineOffset {
	NSMutableData * data = [self objectAtIndex:lineOffset];
	assert(data != nil);
	
	[data setIntValue:val atIndex:intIndex];
}

@end

@implementation NSData(Values)

- (uint8_t) byteValueAtIndex: (NSUInteger)byteIndex {
	if (byteIndex >= [self length]) {
		NSLog (@"%s: Invalid offset! [%d]: %@", __PRETTY_FUNCTION__, byteIndex, self);
		return 0;
	}
	
	uint8_t *val = (uint8_t *)[self bytes];
	return orderRead(val[byteIndex], LITTLE, hostEndian());
}

- (uint32_t) intValueAtIndex: (NSUInteger)intIndex {
	if (intIndex*4 > [self length]-4) {
		NSLog (@"%s: Invalid offset! [%d]: %@", __PRETTY_FUNCTION__, intIndex, self);
		return 0;
	}
	
	uint32_t *val = (uint32_t *)[self bytes];
	return orderRead(val[intIndex], LITTLE, hostEndian());
}

@end

@implementation NSMutableData(Values)

- (void) setByteValue: (uint8_t)val atIndex: (NSUInteger)byteIndex {
	if (byteIndex >= [self length]) {
		NSLog (@"%s: Invalid offset! [%d]: %@", __PRETTY_FUNCTION__, byteIndex, self);
		return;
	}

	uint8_t * item = (uint8_t *)[self mutableBytes];
	
	orderCopy(val, item[byteIndex], hostEndian(), LITTLE);
}

- (void) setIntValue: (uint32_t)val atIndex: (NSUInteger)intIndex {
	if (intIndex*4 > [self length]-4) {
		NSLog (@"%s: Invalid offset! %d: %@", __PRETTY_FUNCTION__, intIndex, self);
		return;
	}

	uint32_t * item = (uint32_t *)[self mutableBytes];
	
	orderCopy(val, item[intIndex], hostEndian(), LITTLE);
}


@end