//
//  GHStatesEditor.h
//  Goblin Hacker
//
//  Created by hgu on 18/01/08.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

@interface GHStatesEditor : NSObject {
	IBOutlet NSTableView * statesTable;
	IBOutlet GHSavedGameDocument * document;
	IBOutlet NSWindow * window;
	IBOutlet NSView * statesEditorView;
}

- (IBAction) show: (id)sender;
+ (NSArray*) states;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (unsigned char) cursed;
- (void) setCursed: (unsigned char)val;
- (NSString*) cursedState;

- (IBAction)bless: (id)sender;
- (IBAction)uncurse: (id)sender;

@property (retain) NSView * statesEditorView;
@property (retain) NSTableView * statesTable;
@property (retain) NSWindow * window;
@property (retain) GHSavedGameDocument * document;
@end
