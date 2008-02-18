//
//  GHSkillsEditor.h
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

#define SKILL_OFFSET 9

@interface GHSkillsEditor : NSObject {
	IBOutlet NSTableView * skillsTable;
	IBOutlet GHSavedGameDocument * document;
	IBOutlet NSWindow * window;
	IBOutlet NSView * skillsEditorView;
}

- (IBAction) show: (id)sender;
+ (NSArray*) skills;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@property (retain) NSView * skillsEditorView;
@property (retain) NSTableView * skillsTable;
@property (retain) GHSavedGameDocument * document;
@property (retain) NSWindow * window;
@end
