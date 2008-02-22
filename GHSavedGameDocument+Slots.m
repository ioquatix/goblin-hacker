//
//  GHSavedGameDocument+Slots.m
//  Goblin Hacker
//
//  Created by Administrator on 19/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GHSavedGameDocument+Slots.h"

#import "NSData+Values.h"

@implementation GHSavedGameDocument(Slots)

- (GHSlotIndex) findFirstEmptySlot {
   GHSlotIndex slot;
   
   for (slot = INVENTORY_SLOT_START; slot <= INVENTORY_SLOT_END; slot++) {
      if ([self isSlotFree:slot]) break;
   }
   
   if (slot > INVENTORY_SLOT_END) {
      return -1;
   }
   
   return slot;
}

- (GHSlotIndex) findFirstQuickSlot {
	GHSlotIndex slot;

	for (slot = QUICK_SLOT_START; slot <= QUICK_SLOT_END; slot++) {
		if ([self isSlotFree:slot]) break;
	}

	if (slot > QUICK_SLOT_END) {
		return -1;
	} 

	return slot;
}

- (BOOL)isSlotFree: (GHSlotIndex)slot {
	if (slot < SLOT_MIN || slot >= SLOT_MAX) return NO;
	
	NSUInteger line = SLOT_LINE + slot * 3;
   
	if ([characterData intValueAtIndex:2 line:line] == 0)
		return YES;
	else
		return NO;
}

// try to keep the time of inconsistency short, we don't want semaphores
- (void)moveItem:(GHSlotIndex)srcSlot to:(GHSlotIndex)destSlot {
	if ([self isSlotFree:srcSlot]) return;
	if (![self isSlotFree:destSlot]) return;

	NSData *src1, *src2, *dest1, *dest2;
	src1 = [self dataForIndex:FIRST_SLOT_LINE + srcSlot*3];
	src2 = [self dataForIndex:FIRST_SLOT_LINE + srcSlot*3 + 1];
	dest1 = [self dataForIndex:FIRST_SLOT_LINE + destSlot*3];
	dest2 = [self dataForIndex:FIRST_SLOT_LINE + destSlot*3 + 1];
	[self setData:src1 forIndex:FIRST_SLOT_LINE + destSlot*3];
	[self setData:src2 forIndex:FIRST_SLOT_LINE + destSlot*3 + 1];
}

- (void) clearItemInSlot: (GHSlotIndex)slot {
	NSData * line1 = [[NSData alloc] initWithLength: 3 * 4];
	NSData * line2 = [[NSData alloc] initWithLength:21 * 4];

	[self setData:line1 forIndex:FIRST_SLOT_LINE + slot*3];
	[self setData:line2 forIndex:FIRST_SLOT_LINE + slot*3 + 1];
}

- (void) setItem: (GHItem*)item inSlot: (GHSlotIndex)slot {
	NSArray * lines = [item itemData];
	
	NSLog (@"Setting item %@ in slot %d (%@)", [item name], slot, [GHItem slotName:slot]);
	
	// Avoid corrupting the save game if possible!
	if (slot < SLOT_MIN || slot >= SLOT_MAX) {
		NSLog(@"Aborting setting item in slot: slot is invalid!");
		return;
	}

	[[self undoManager] beginUndoGrouping];	
	[self setData:[lines objectAtIndex:0] forIndex:FIRST_SLOT_LINE + slot*3];
	[self setData:[lines objectAtIndex:1] forIndex:FIRST_SLOT_LINE + slot*3 + 1];
	[[self undoManager] endUndoGrouping];
}

- (void)addItem:(GHSlotIndex)slot itemType:(ItemType)it name:(NSString*)nam weight:(double)weight
        skillRequired:(SkillType)skreq occurrence:(int)occ icon:(int)iconIndex value:(int)val
        count:(int)nr damage:(int)dam armorRating:(int)ar attr:(AttributeType)attr attrBonus:(int)attrbon
        skill:(SkillType)skgrant skillBonus:(int)skbon hitPoints:(int)hp mana:(int)mana
        toHitBonus:(int)hitbon damageBonus:(int)dambon arBonus:(int)arbon
        resistance:(ResistanceType)res effect:(int)eff script:(NSString*)script
{
	GHItem * item = [GHItem new];
	
	[item setName:nam];
	[item setEquipmentType:it];
	[item setWeight:weight];
	[item setSkillRequired:skreq];
	[item setOccurrence:occ];
	[item setIconIndex:iconIndex];
	[item setValue:val];
	[item setIdentified:YES];
	[item setStackCount:nr];
	[item setBaseDamage:dam];
	[item setArmorRating:ar];
	[item setAttrGranted:attr];
	[item setAttrBonus:attrbon];
	[item setSkillGranted:skgrant];
	[item setSkillBonus:skbon];
	[item setHpBonus:hp];
	[item setManaBonus:mana];
	[item setToHitBonus:hitbon];
	[item setDamageBonus:dambon];
	[item setArBonus:arbon];
	[item setResistance:res];
	[item setEffect:eff];
	[item setScript:script];
	
	[self setItem:item inSlot:slot];
}
@end
