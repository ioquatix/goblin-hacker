//
//  GHInventoryEditor.m
//  Goblin Hacker
//
//  Created by Hermann Gundel on 25/02/08.
//  Copyright 2008 Hermann Gundel. All rights reserved.
//  

#import "GHItemEditor.h"
#import "GHInventoryEditor.h"
#import "GHSkillsEditor.h"
#include "Endian.h"

@implementation GHItemEditor

+ (void) initialize {
	[self setKeys:[NSArray arrayWithObject:@"item"] triggerChangeNotificationsForDependentKey:@"slotName"];
	[self setKeys:[NSArray arrayWithObject:@"slotIndex"] triggerChangeNotificationsForDependentKey:@"slotIndexBase1"];
}

- (void)nextSlot: (id)sender {
	GHSlotIndex next = slotIndex + 1;

	// We can't go any further.. wrap around
	if (next >= SLOT_MAX) next = SLOT_MIN;
	
	[self setSlotIndex:next];
}

- (void)previousSlot: (id)sender {
	GHSlotIndex prev = slotIndex - 1;
	
	// We can't go any further... wrap around
	if (prev < SLOT_MIN) prev = SLOT_MAX-1;
	
	[self setSlotIndex:prev];
}

- (void) awakeFromNib {
	if (document && window && primaryEditorView)
		[self setSlotIndex:0];
	
	[super awakeFromNib];
}

- (void)revert: (id)sender {
	NSLog (@"Reverting item...");
	[self setSlotIndex:slotIndex];
}

- (void) updateSlotItem: (GHItem*)newItem {
	[self willChangeValueForKey:@"item"];
	
	[[[document undoManager] prepareWithInvocationTarget:self] updateSlotItem:item];
	
	if (item)
		[item autorelease];
	
	item = [newItem retain];
	
	[self didChangeValueForKey:@"item"];
}

- (IBAction)clear: (id)sender {
	[[document undoManager] beginUndoGrouping];
	[[document undoManager] setActionName:@"Clear Item"];
	
	[self updateSlotItem:[GHItem new]];
		
	[[document undoManager] endUndoGrouping];
}

- (void)save: (id)sender {
	[document setItem:item inSlot:slotIndex];
}

- (NSString*)slotName {
	return [GHItem slotName:slotIndex];
}

- (GHSlotIndex) slotIndexBase1 {
	return [self slotIndex] + 1;
}

- (void)setSlotIndexBase1: (GHSlotIndex)val {
	[self setSlotIndex:val-1];
}

- (GHSlotIndex)slotIndex {
   return slotIndex;
}

- (void)setSlotIndex: (GHSlotIndex)val {		
	if (val < SLOT_MIN || val >= SLOT_MAX) {
		NSLog (@"%s: Trying to set slotIndex to %d, which is invalid!", __PRETTY_FUNCTION__, val);
		val = 0;
	}
	
	[self willChangeValueForKey:@"item"];
	
	if (item != nil)
		[item release];
	
	slotIndex = val;
	
	item = [[GHItem alloc] initFromSlot:slotIndex ofDocument:document];
	
	[self didChangeValueForKey:@"item"];
}

- (void)identifyItem: (id)sender {
	if (item) {
		[item setIdentified:YES];
	}	
}

@synthesize item;

@end
