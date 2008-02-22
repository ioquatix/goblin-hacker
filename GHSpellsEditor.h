//
//  GHSpellsEditor.h
//  Goblin Hacker
//
//  Created by hgu on 18/01/08.
//

#import <Cocoa/Cocoa.h>

#import "GHEditorController.h"

@interface GHSpellsEditor : GHEditorController {
	IBOutlet NSTableView * spellsTable;
}

- (IBAction) giveDivinitySpells: (id)sender;
- (IBAction) giveElementalSpells: (id)sender;
+ (NSArray*) spells;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

@end
