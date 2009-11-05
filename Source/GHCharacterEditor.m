//
//  GHCharacterEditor.m
//  Goblin Hacker
//
//  Created by Samuel Williams on 19/12/07.
//  Copyright 2007 Samuel Williams, Orion Transfer Ltd. All rights reserved.


#import "GHCharacterEditor.h"


@implementation GHCharacterEditor

- (void) awakeFromNib {
	if (window)
		[self showPrimaryEditor:self];
	
	[super awakeFromNib];
}

- (void) awakeFromEditor {
	fixedSize = [primaryEditorView bounds].size;
}

- (IBAction) showPrimaryEditor: (id)sender {
	[window setContentSize:fixedSize];
	[window setContentView:primaryEditorView];
}

@end
