//
//  GHApplicationDelegate.h
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GHApplicationDelegate : NSObject {

}

- (IBAction) openWebsite: (id)sender;

- (NSArray*) games;
- (void) editGame: (NSString*)path;

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender;
- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication;

@end
