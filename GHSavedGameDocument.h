//
//  GHSavedGameDocument.h
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright Orion Transfer Ltd 2007 . All rights reserved.
//


#import <Cocoa/Cocoa.h>



@interface GHSavedGameDocument : NSDocument
{
	NSArray * characterData;
}

- (IBAction) reloadDocument: (id)sender;

- (NSString*) stringForIndex: (NSUInteger)idx;
- (NSMutableData*) dataForIndex: (NSUInteger)idx;

- (void) setString: (NSString*)string forIndex:(NSUInteger)idx;
- (void) setData: (NSData*)data forIndex:(NSUInteger)idx;

- (NSString*) displayName;

@end
