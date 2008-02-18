//
//  GHApplicationDelegate.m
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import "GHApplicationDelegate.h"


@implementation GHApplicationDelegate

- (IBAction) openWebsite: (id)sender {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.oriontransfer.org/go/GoblinHacker"]];
}

- (void) editGame: (NSString*)path {
	NSURL * url = [NSURL fileURLWithPath:path];
	NSError * err = nil;
	[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES error:&err];
	
	if (err) {
		[[NSAlert alertWithError:err] runModal];
	}
}

- (NSArray*) games {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString * searchPath = [@"~/Documents/Eschalon Book 1 Saved Games/" stringByExpandingTildeInPath];
	NSArray *paths = [fm directoryContentsAtPath:searchPath];
	NSMutableArray *games = [NSMutableArray new];
	
	for (NSString * path in paths) {
		BOOL isDir = NO;
		
		NSString * fileName = path;
		path = [searchPath stringByAppendingPathComponent:path];
		[fm fileExistsAtPath:path isDirectory:&isDir];
		
		NSString * charPath = [path stringByAppendingPathComponent:@"char"];
		NSString * saveNamePath = [path stringByAppendingPathComponent:@"savename"];
		
		//NSLog (@"Looking at path: %@", charPath);
		
		if (isDir && [fm fileExistsAtPath:saveNamePath] && [fm fileExistsAtPath:charPath]) {
			NSArray * details = [[NSString stringWithContentsOfFile:saveNamePath] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
			
			NSDictionary * props = [NSDictionary dictionaryWithObjectsAndKeys:
				charPath, @"path",
				fileName, @"fileName",
				[details objectAtIndex:0], @"name",
				[details objectAtIndex:2], @"date",
				[details objectAtIndex:4], @"time",
				nil];
			
			[games addObject:props];
		}
	}
	
	//NSLog(@"Games found:");
	//for (NSDictionary * d in games) {
	//	NSLog(@"Game found: %@", [d objectForKey:@"name"]);
	//}
	
	return games;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
	return NO;
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication {
	return NO;
}

@end
