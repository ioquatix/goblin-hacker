//
//  GHEditorController.h
//  Goblin Hacker
//
//  Created by Administrator on 18/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

@interface GHEditorController : NSObject {
	IBOutlet NSView * primaryEditorView;
	IBOutlet NSWindow * window;
	IBOutlet GHSavedGameDocument * document;
}

- init; // Uses the clases name to get the right nib
- initWithNibName: (NSString*)nibName;

- (IBAction) showPrimaryEditor: (id)sender;

// Called when the editor is loaded
- (void) awakeFromEditor;

@property (retain) NSView * primaryEditorView;
@property (retain) GHSavedGameDocument * document;
@property (retain) NSWindow * window;

@end
