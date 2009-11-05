//
//  SWDataToString.m
//  Goblin Hacker
//
//  Created by Samuel Williams on 20/01/08.
//  Copyright 2008 Samuel Williams, Orion Transfer Ltd. All rights reserved.
//

#import "SWDataToString.h"


@implementation SWDataToString
+ (void) initialize {
	static BOOL initialized = NO;
	
	if (!initialized) {
		[NSValueTransformer setValueTransformer:[[[[self class] alloc] init] autorelease] forName:@"SWDataToString"];	
		initialized = YES;
	}
}

+ (Class)transformedValueClass { 
	return [NSString self];
}

+ (BOOL)allowsReverseTransformation {
	return NO;
}

- (id)transformedValue:(id)value {
	//NSLog (@"Transforming: %@", value);
	if (![value isKindOfClass:[NSData class]]) return nil;
	
	// Nasty!!	
	NSPipe * input = [NSPipe new], * output = [NSPipe new];
	
	NSTask * task = [NSTask new];
	[task setLaunchPath:@"/usr/bin/hexdump"];
	[task setArguments:[NSArray arrayWithObject:@"-C"]];
	[task setStandardInput:input];
	[task setStandardOutput:output];
	
	[task launch];

	[[output fileHandleForWriting] closeFile];	
	[[input fileHandleForReading] closeFile];
	[[input fileHandleForWriting] writeData:value];
	[[input fileHandleForWriting] closeFile];
	
	NSFileHandle * readHandle = [output fileHandleForReading];
	NSData * inData;
	NSMutableData * buffer = [NSMutableData new];
	
	[task waitUntilExit];
	
	while ((inData = [readHandle availableData]) && [inData length]) {
		[buffer appendData:inData];
	}

	return [[[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding] autorelease];
}

//- (id)reverseTransformedValue:(id)value {

//}
@end
