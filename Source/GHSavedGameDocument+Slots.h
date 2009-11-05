//
//  GHSavedGameDocument+Slots.h
//  Goblin Hacker
//
//  Created by Samuel Williams on 19/02/08.
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
