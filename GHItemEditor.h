//
//  GHInventoryEditor.h
//  Goblin Hacker
//
//  Created by Hermann Gundel on 25/01/08.
//

#import <Cocoa/Cocoa.h>

#import "GHEditorController.h"
#import "GHItem.h"

@interface GHItemEditor : GHEditorController {	
	GHSlotIndex slotIndex;
	GHItem * item;
}

- (IBAction)nextSlot: (id)sender;
- (IBAction)previousSlot: (id)sender;

- (IBAction)revert: (id)sender;
- (IBAction)clear: (id)sender;
- (IBAction)save: (id)sender;

- (NSString*) slotName;

- (GHSlotIndex)slotIndex;
- (void)setSlotIndex: (GHSlotIndex)val;

- (GHSlotIndex) slotIndexBase1;
- (void)setSlotIndexBase1: (GHSlotIndex)val;

- (IBAction)identifyItem: (id)sender;

@property (retain) GHItem * item;

@end
