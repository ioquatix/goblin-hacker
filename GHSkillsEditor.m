//
//  GHSkillsEditor.m
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import "GHSkillsEditor.h"

#import "GHSavedGameDocument+Character.h"

@implementation GHSkillsEditor

+ (NSArray*) skills 
{
	static NSArray * skills = nil;
	
	if (skills == nil) {
		NSString * skillsPath = [[NSBundle mainBundle] pathForResource:@"skills" ofType:@"plist"];
		skills = [[NSArray arrayWithContentsOfFile:skillsPath] retain];
	}
	
	return skills;
}

- (void) awakeFromEditor {
	[skillsTable setDataSource: self];
	[skillsTable reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[[self class] skills] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([@"Value" isEqualTo:[tableColumn identifier]]) {
		return [NSNumber numberWithInt:[document characterStat:SKILL_OFFSET + row]];
	} else {
		return [[[self class] skills] objectAtIndex:row];
	}
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	if ([@"Value" isEqualTo:[tableColumn identifier]]) {
		[[[document undoManager] prepareWithInvocationTarget:tableView] reloadData];
		[document setCharacterStat:SKILL_OFFSET + row to:[object intValue]];
	}	
}

@end
