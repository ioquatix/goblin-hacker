//
//  GHCharacterEditor.h
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

@interface GHCharacterEditor : NSObject {
	IBOutlet GHSavedGameDocument * document;
	IBOutlet NSWindow * window;
	IBOutlet NSView * characterEditorView;
}

- (IBAction) show: (id)sender;

@property (retain) NSWindow * window;
@property (retain) NSView * characterEditorView;
@property (retain) GHSavedGameDocument * document;
@end
