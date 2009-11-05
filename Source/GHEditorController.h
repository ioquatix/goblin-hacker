//
//  GHEditorController.h
//  Goblin Hacker
//
//  Created by Samuel Williams on 18/02/08.
//  Copyright 2008 Samuel Williams, Orion Transfer Ltd. All rights reserved.
//
//  This software was originally produced by Orion Transfer Ltd.
//    Please see http://www.oriontransfer.org for more details.
//

/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/


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
