//
//  GHSkillsEditor.h
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHEditorController.h"

enum {
	SKILL_OFFSET = 9
};

@interface GHSkillsEditor : GHEditorController {
	IBOutlet NSTableView * skillsTable;
}

+ (NSArray*) skills;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
