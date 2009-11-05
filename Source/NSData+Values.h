//
//  NSData+Values.h
//  Goblin Hacker
//
//  Created by Samuel Williams on 21/02/08.
//  Copyright 2008 Samuel Williams, Orion Transfer Ltd. All rights reserved.
//
//  This software was originally produced by Orion Transfer Ltd.
//    Please see http://www.oriontransfer.org for more details.
//

/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


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