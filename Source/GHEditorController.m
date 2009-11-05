//
//  GHEditorController.m
//  Goblin Hacker
//
//  Created by Samuel Williams on 18/02/08.
//  Copyright 2008 Samuel Williams, Orion Transfer Ltd. All rights reserved.
//

#import "GHEditorController.h"


@implementation GHEditorController

- initWithNibName: (NSString*)nibName {
	if (self = [super init]) {
		[NSBundle loadNibNamed:nibName owner:self];
	}
	
	return self;
}

- init {
	NSString * name = [self className];
	
	if (self = [self initWithNibName:name]) {
	
	}
	
	return self;
}

- (void) awakeFromNib {
	// We need to check if we arrrr! a pirate!
	// Ahmmm... we need to check if we are in the right ship..er nib.
	if (primaryEditorView != nil) {
		[self awakeFromEditor];
	}
}

- (void) awakeFromEditor {
	// Yarrr...
}

- (IBAction) showPrimaryEditor: (id)sender {
	if (window == nil) {
		NSLog (@"%s: window not bound", __PRETTY_FUNCTION__);
	}
	
	if (primaryEditorView == nil) {
		NSLog (@"%s: primary editor view not bound", __PRETTY_FUNCTION__);
	}

	[window setContentView:primaryEditorView];	
}

@synthesize document;
@synthesize window;
@synthesize primaryEditorView;

@end
