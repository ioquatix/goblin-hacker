//
//  GHCharacterEditor.m
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import "GHCharacterEditor.h"


@implementation GHCharacterEditor

- (void) awakeFromNib {
	[self show:self];
}

- (IBAction) show: (id)sender {
	[window setContentSize:[characterEditorView frame].size];
	[window setContentView:characterEditorView];
}

@synthesize window;
@synthesize characterEditorView;
@synthesize document;
@end
