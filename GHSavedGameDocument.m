//
//  GHSavedGameDocument.m
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright Orion Transfer Ltd 2007 . All rights reserved.
//

#import "GHSavedGameDocument.h"
#import "GHSavedGameDocument+Character.h"

#include <arpa/inet.h>

@implementation GHSavedGameDocument

- (IBAction) reloadDocument: (id)sender {
	[self close];
	
	NSError * err = nil;
	NSURL * url = [self fileURL];
	[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES error:&err];
	
	if (err) {
		[[NSAlert alertWithError:err] runModal];
	}
}

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"GHSavedGameDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}


- (NSString*) displayName {
	return [self characterName];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	NSMutableData * fileData = [NSMutableData new];
	
	NSUInteger i, count = [characterData count];
	for (i = 0; i < count; i++) {
		NSData * line = [characterData objectAtIndex:i];
		if (i == 0) {
			[fileData appendBytes:"\0\0\0\0" length:4];
		} else {
			[fileData appendBytes:"\r\n" length:2];
		}
		
		[fileData appendData:line];
	}
	
	return fileData;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	[self willChangeValueForKey:@"characterData"];
	const unsigned char *b = (const unsigned char *)[data bytes];
	
	if (b[0] != '\0' || b[1] != '\0' || b[2] != '\0' || b[3] != '\0') {
		NSLog (@"File format appears incorrect!");
	}
	
	NSMutableArray * strs = [NSMutableArray new];
	
	unsigned c = 4, s = 4;
	unsigned sz = [data length];
	while (s < sz) {
		// \r\n
		if (s+1 < sz && b[s] == 0x0d && b[s+1] == 0x0a) {
			[strs addObject:[NSMutableData dataWithBytes:b+c length:s - c]];
			s += 2; // We used up two bytes marker
			c = s; // We used up 
			
			continue;
		}
		
		s++;
	}
	
	if (s > c) {
		[strs addObject:[NSMutableData dataWithBytes:b+c length:s - c]];
	}
		
	characterData = [strs retain];
    
	// NSLog (@"Read %d lines", [characterData count]);
	
	//NSUInteger i, count = [characterData count];
	//NSString * header = [NSString stringWithFormat:@"Dumping %d lines", [characterData count]];
	//[dump addObject:header];
	//for (i = 0; i < count; i++) {
	//	NSString * line = [NSString stringWithFormat:@"%d: %@ => %@", i, [self dataForIndex:i], [self stringForIndex:i]];
	//	[dump addObject:line];
	//}
	
	[self didChangeValueForKey:@"characterData"];
    return YES;
}

- (NSString*) stringForIndex: (NSUInteger)idx {
	return [[[NSString alloc] initWithData:[self dataForIndex:idx] encoding:NSUTF8StringEncoding] autorelease];
}

- (NSMutableData*) dataForIndex: (NSUInteger)idx {
	return [characterData objectAtIndex:idx];	
}

- (void) setString: (NSString*)string forIndex:(NSUInteger)idx {
	[self setData:[string dataUsingEncoding:NSASCIIStringEncoding] forIndex:idx];
}

- (void) setData: (NSData*)data forIndex:(NSUInteger)idx {
	NSMutableData * old = [characterData objectAtIndex:idx];
	
	//NSLog (@"Replacing %@ with %@", old, data);
	
	[[[self undoManager] prepareWithInvocationTarget:self] setData: [old copy] forIndex:idx];
	
	[self willChangeValueForKey:@"characterData"];
	[old setData:data];
	[self didChangeValueForKey:@"characterData"];
}

@end
