//
//  GHStatesEditor.h
//  Goblin Hacker
//
//  Created by hgu on 18/01/08.
//

#import <Cocoa/Cocoa.h>

#import "GHEditorController.h"

@interface GHStatesEditor : GHEditorController {
	IBOutlet NSTableView * statesTable;
}

+ (NSArray*) states;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

- (unsigned char) cursed;
- (void) setCursed: (unsigned char)val;
- (NSString*) cursedState;

- (IBAction)bless: (id)sender;
- (IBAction)uncurse: (id)sender;

@end
