//
//  GHSavedGameDocument+Slots.h
//  Goblin Hacker
//
//  Created by Administrator on 19/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHItem.h"

@interface GHSavedGameDocument(Slots)

- (GHSlotIndex)findFirstQuickSlot;
- (GHSlotIndex)findFirstEmptySlot;
- (BOOL)isSlotFree:(GHSlotIndex)slot;

- (void) moveItem:(GHSlotIndex)srcSlot to:(GHSlotIndex)destSlot;

- (void) clearItemInSlot: (GHSlotIndex)slot;
- (void) setItem: (GHItem*)item inSlot:(GHSlotIndex)slot;

- (void)addItem:(GHSlotIndex)slot itemType:(ItemType)it name:(NSString*)nam weight:(double)weight
        skillRequired:(SkillType)skreq occurrence:(int)occ icon:(int)iconIndex value:(int)val
        count:(int)nr damage:(int)dam armorRating:(int)ar attr:(AttributeType)attr attrBonus:(int)attrbon
        skill:(SkillType)skgrant skillBonus:(int)skbon hitPoints:(int)hp mana:(int)mana
        toHitBonus:(int)hitbon damageBonus:(int)dambon arBonus:(int)arbon
        resistance:(ResistanceType)res effect:(int)eff script:(NSString*)script;

@end
