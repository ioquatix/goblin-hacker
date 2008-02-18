//
//  GHSpellsEditor.h
//  Goblin Hacker
//
//  Created by hgu on 18/01/08.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

@interface GHSpellsEditor : NSObject {
	IBOutlet NSTableView * spellsTable;
	IBOutlet GHSavedGameDocument * document;
	IBOutlet NSWindow * window;
	IBOutlet NSView * spellsEditorView;
}

- (IBAction) giveDivinitySpells: (id)sender;
- (IBAction) giveElementalSpells: (id)sender;
- (IBAction) show: (id)sender;
+ (NSArray*) spells;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@property (retain) NSView * spellsEditorView;
@property (retain) GHSavedGameDocument * document;
@property (retain) NSTableView * spellsTable;
@property (retain) NSWindow * window;
@end
