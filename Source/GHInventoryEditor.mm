//
//  GHInventoryEditor.m
//  Goblin Hacker
//
//  Re-Created by Hermann Gundel on 22/01/08.
//  Copyright 2008 Hermann Gundel. All rights reserved.
//
//  2008-01-22 Hermann Gundel - methods for easy item acquisition
//       find empty slot, give armor/missiles/potions/weapons
//       structure info and display strings in items.plist
//  2008-01-27 Hermann Gundel - more methods for item handling
//       addItem, moveItem
//

#import "GHInventoryEditor.h"
#import "GHItemEditor.h"
#include "Endian.h"

#import "GHSavedGameDocument+Character.h"

@implementation GHInventoryEditor

@synthesize armorType;
@synthesize weaponType;
@synthesize potionQuality;

+ (NSArray*) items 
{
	static NSArray * items = nil;
	
	if (items == nil) {
		NSString * itemsPath = [[NSBundle mainBundle] pathForResource:@"item" ofType:@"plist"];
		items = [[NSArray arrayWithContentsOfFile:itemsPath] retain];
	}
	
	return items;
}

- (void) noFreeSlots {
	[[NSAlert alertWithMessageText:@"Not enough free slots available" defaultButton:@"Damn! I hate it when that happens!" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Really, you shouldn't cheat so much ^_^"] runModal];
}

#pragma mark -
#pragma mark Weapons

- (void)basicWeapon: (id)sender {
	int slot;
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	
	switch ([self weaponType]) {
		case 0: // arrows
			[document addItem:slot itemType:ITEM_ARROW name:@"Arrow" weight:0.1 skillRequired:SKILL_NONE
				   occurrence:1 icon:20 value:1 count:100 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 1: // grenades
			[document addItem:slot itemType:ITEM_WEAPON name:@"Demon Oil I" weight:0.3 skillRequired:SKILL_WEAPON_THROWN
				   occurrence:1 icon:137 value:30 count:30 damage:10 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 2: // axes
			[document addItem:slot itemType:ITEM_WEAPON name:@"Iron Hand Axe" weight:2 skillRequired:SKILL_WEAPON_AXE
				   occurrence:1 icon:31 value:22 count:0 damage:2 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 3: // short blades
			[document addItem:slot itemType:ITEM_WEAPON name:@"Steel Dagger" weight:0.8 skillRequired:SKILL_WEAPON_SHORT
				   occurrence:2 icon:2 value:85 count:0 damage:2 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 4: // bows
			[document addItem:slot itemType:ITEM_WEAPON name:@"Yew Short Bow" weight:2 skillRequired:SKILL_WEAPON_BOW
				   occurrence:1 icon:22 value:160 count:0 damage:2 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 5: // maces
			[document addItem:slot itemType:ITEM_WEAPON name:@"Copper Hammer" weight:3 skillRequired:SKILL_WEAPON_MACE
				   occurrence:1 icon:10 value:20 count:0 damage:2 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 6: //swords
			[document addItem:slot itemType:ITEM_WEAPON name:@"Iron Short Sword" weight:3 skillRequired:SKILL_WEAPON_SWORD
				   occurrence:1 icon:40 value:30 count:0 damage:2 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
	}
}

- (void)goodWeapon: (id)sender {
	int slot;
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	switch ([self weaponType]) {
		case 0: // arrows
			[document addItem:slot itemType:ITEM_ARROW name:@"Flight Arrow" weight:0.1 skillRequired:SKILL_NONE
				   occurrence:2 icon:20 value:4 count:100 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:1 damageBonus:2
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 1: // grenades
			[document addItem:slot itemType:ITEM_WEAPON name:@"Demon Oil III" weight:0.3 skillRequired:SKILL_WEAPON_THROWN
				   occurrence:2 icon:147 value:60 count:30 damage:20 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 2: // axes
			[document addItem:slot itemType:ITEM_WEAPON name:@"Steel Double Battle Axe" weight:4 skillRequired:SKILL_WEAPON_AXE
				   occurrence:2 icon:36 value:385 count:0 damage:5 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 3: // short blades
			[document addItem:slot itemType:ITEM_WEAPON name:@"Mithril Dagger" weight:1 skillRequired:SKILL_WEAPON_SHORT
				   occurrence:3 icon:3 value:310 count:0 damage:4 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 4: // bows
			[document addItem:slot itemType:ITEM_WEAPON name:@"Composite Longbow" weight:5 skillRequired:SKILL_WEAPON_BOW
				   occurrence:3 icon:24 value:550 count:0 damage:5 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 5: // maces
			[document addItem:slot itemType:ITEM_WEAPON name:@"Steel Warhammer" weight:7 skillRequired:SKILL_WEAPON_MACE
				   occurrence:2 icon:12 value:410 count:0 damage:5 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 6: //swords
			[document addItem:slot itemType:ITEM_WEAPON name:@"Steel Long Sword" weight:4.5 skillRequired:SKILL_WEAPON_SWORD
				   occurrence:2 icon:42 value:400 count:0 damage:5 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
	}
}

- (void)superbWeapon: (id)sender {
	int slot;
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	switch ([self weaponType]) {
		case 0: // arrows
			[document addItem:slot itemType:ITEM_ARROW name:@"Diamond Head Arrows" weight:0.1 skillRequired:SKILL_NONE
				   occurrence:4 icon:21 value:30 count:100 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:5 damageBonus:4
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 1: // grenades
			[document addItem:slot itemType:ITEM_WEAPON name:@"Demon Oil III" weight:0.3 skillRequired:SKILL_WEAPON_THROWN
				   occurrence:3 icon:157 value:120 count:30 damage:30 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 2: // axes
			[document addItem:slot itemType:ITEM_WEAPON name:@"Diamond-edge Great Axe +3" weight:8 skillRequired:SKILL_WEAPON_AXE
				   occurrence:4 icon:37 value:2600 count:0 damage:8 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:3 damageBonus:3
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 3: // short blades
			[document addItem:slot itemType:ITEM_WEAPON name:@"Adamantine Dagger +5" weight:1.5 skillRequired:SKILL_WEAPON_SHORT
				   occurrence:4 icon:3 value:1500 count:0 damage:5 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:5 damageBonus:5
					  arBonus:0 resistance:RESIST_NONE effect:3 script:nil];
			break;
		case 4: // bows
			[document addItem:slot itemType:ITEM_WEAPON name:@"Composite Great Bow +3" weight:7 skillRequired:SKILL_WEAPON_BOW
				   occurrence:4 icon:25 value:1800 count:0 damage:7 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:3 damageBonus:3
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 5: // maces
			[document addItem:slot itemType:ITEM_WEAPON name:@"Adamantine War Hammer +3" weight:8 skillRequired:SKILL_WEAPON_MACE
				   occurrence:4 icon:14 value:2700 count:0 damage:8 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:3 damageBonus:3
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 6: //swords
			[document addItem:slot itemType:ITEM_WEAPON name:@"Adamantine Great Sword" weight:10 skillRequired:SKILL_WEAPON_SWORD
				   occurrence:4 icon:45 value:2000 count:0 damage:10 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
	}      
}

- (void)avatarWeapon: (id)sender {
	int slot, equSlot;
	if ([self weaponType] == 0) {
		equSlot = EQUIPPED_SLOT_BASE + SLOT_QUIVER;
	} else {
		equSlot = EQUIPPED_SLOT_BASE + SLOT_WEAPON;
	}
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	slot = equSlot;
	switch ([self weaponType]) {
		case 0: //arrows
			[document addItem:slot itemType:ITEM_ARROW name:@"Arrows of Annihilation" weight:0.1 skillRequired:SKILL_NONE
				   occurrence:9 icon:21 value:0 count:200 damage:10 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 1: //grenades
			[document addItem:slot itemType:ITEM_WEAPON name:@"Demon Oil X" weight:0.3 skillRequired:SKILL_WEAPON_THROWN
				   occurrence:9 icon:39 value:0 count:40 damage:100 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_WEAPON_THROWN skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 2: // axes
			[document addItem:slot itemType:ITEM_WEAPON name:@"Decapitator" weight:5.0 skillRequired:SKILL_WEAPON_AXE
				   occurrence:9 icon:35 value:0 count:0 damage:20 armorRating:0 attr:ATTR_STRENGTH attrBonus:30
						skill:SKILL_WEAPON_AXE skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 3: // short blades
			[document addItem:slot itemType:ITEM_WEAPON name:@"Dagger of Assassination" weight:1.0 skillRequired:SKILL_WEAPON_SHORT
				   occurrence:9 icon:3 value:0 count:0 damage:20 armorRating:0 attr:ATTR_DEXTERITY attrBonus:30
						skill:SKILL_WEAPON_SHORT skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
					  arBonus:0 resistance:RESIST_TOXIN effect:3 script:nil];
			break;
		case 4: // bows
			[document addItem:slot itemType:ITEM_WEAPON name:@"Great Bow of the Avatar" weight:5.0 skillRequired:SKILL_WEAPON_BOW
				   occurrence:9 icon:25 value:0 count:0 damage:20 armorRating:0 attr:ATTR_CONCENTRATION attrBonus:30
						skill:SKILL_WEAPON_BOW skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 5: // maces
			[document addItem:slot itemType:ITEM_WEAPON name:@"Atomizer" weight:8.0 skillRequired:SKILL_WEAPON_MACE
				   occurrence:9 icon:19 value:0 count:0 damage:25 armorRating:0 attr:ATTR_STRENGTH attrBonus:60
						skill:SKILL_WEAPON_MACE skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
		case 6: // swords
			[document addItem:slot itemType:ITEM_WEAPON name:@"Flamberge of the Gods" weight:5.0 skillRequired:SKILL_WEAPON_SWORD
				   occurrence:9 icon:47 value:0 count:0 damage:25 armorRating:0 attr:ATTR_STRENGTH attrBonus:30
						skill:SKILL_WEAPON_SWORD skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
					  arBonus:0 resistance:RESIST_ELEMENTS effect:0 script:nil];
			break;
	}
}

#pragma mark -
#pragma mark Armor

- (void)basicArmor: (id)sender {
	int slot;
	switch ([self armorType]) {
		case 0: // light armor
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BODYARMOR name:@"Studded Leather Jerkin" weight:2 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:1 icon:82 value:50 count:0 damage:0 armorRating:2 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_HELMET name:@"Leather Skullcap" weight:1 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:1 icon:61 value:10 count:0 damage:0 armorRating:1 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_LEGGINGS name:@"Hide Leggings" weight:3 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:1 icon:55 value:32 count:0 damage:0 armorRating:1 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BOOTS name:@"Leather Sandals" weight:1 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:1 icon:95 value:10 count:0 damage:0 armorRating:1 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
		case 1: // heavy armor
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BODYARMOR name:@"Hard Leather Banded Armor" weight:5 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:1 icon:78 value:150 count:0 damage:0 armorRating:3 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_HELMET name:@"Iron Skullcap" weight:3 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:1 icon:60 value:70 count:0 damage:0 armorRating:2 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_LEGGINGS name:@"Ringmail Leggings" weight:6 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:1 icon:56 value:85 count:0 damage:0 armorRating:2 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BOOTS name:@"Chainmail Boots" weight:3 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:1 icon:97 value:110 count:0 damage:0 armorRating:2 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
	}
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_BODYARMOR name:@"Wooden Buckler" weight:3 skillRequired:SKILL_ARMOR_SHIELDS
		   occurrence:1 icon:93 value:10 count:0 damage:0 armorRating:1 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
}

- (void)goodArmor: (id)sender {
	int slot;
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	switch ([self armorType]) {
		case 0: // light armor
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BODYARMOR name:@"Diamond Studded Jerkin" weight:3 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:3 icon:86 value:800 count:0 damage:0 armorRating:5 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_HELMET name:@"Steel Chainmail Coif" weight:2 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:2 icon:65 value:250 count:0 damage:0 armorRating:3 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_LEGGINGS name:@"Mithril Studded Leggings" weight:3 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:3 icon:55 value:800 count:0 damage:0 armorRating:4 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BOOTS name:@"Studded Leather Boots +1" weight:2 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:2 icon:96 value:260 count:0 damage:0 armorRating:2 attr:ATTR_NONE attrBonus:0
						skill:SKILL_UNARMED_COMBAT skillBonus:2 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:1 resistance:RESIST_NONE effect:0 script:nil];
			break;
			case 1: // heavy armor
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BODYARMOR name:@"Steel Ring Mail Jerkin" weight:8 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:2 icon:79 value:375 count:0 damage:0 armorRating:5 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_HELMET name:@"Iron Half-Helm" weight:3 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:2 icon:63 value:220 count:0 damage:0 armorRating:3 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_LEGGINGS name:@"Mithril Chainmail Leggings" weight:7 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:3 icon:56 value:1000 count:0 damage:0 armorRating:4 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BOOTS name:@"Iron Spiked Boots" weight:2 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:3 icon:98 value:320 count:0 damage:0 armorRating:3 attr:ATTR_NONE attrBonus:0
						skill:SKILL_UNARMED_COMBAT skillBonus:2 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
	}
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_BODYARMOR name:@"Large Steel Shield" weight:6 skillRequired:SKILL_ARMOR_SHIELDS
		   occurrence:3 icon:92 value:315 count:0 damage:0 armorRating:3 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
}

- (void)superbArmor: (id)sender {
	int slot;
	
	switch ([self armorType]) {
		case 0: // light armor
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BODYARMOR name:@"Adamantine Studded Jerkin +3" weight:4 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:4 icon:87 value:1500 count:0 damage:0 armorRating:6 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:3 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_HELMET name:@"Mithril Coif of Divine Study" weight:1.5 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:9 icon:65 value:3000 count:0 damage:0 armorRating:4 attr:ATTR_INTELLIGENCE attrBonus:3
						skill:SKILL_DIVINATION skillBonus:3 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_LEGGINGS name:@"Diamond Studded Leggings" weight:4 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:4 icon:56 value:1200 count:0 damage:0 armorRating:5 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BOOTS name:@"Thieves Softened Leather Boots +3" weight:1.5 skillRequired:SKILL_ARMOR_LIGHT
				   occurrence:3 icon:96 value:765 count:0 damage:0 armorRating:2 attr:ATTR_NONE attrBonus:0
						skill:SKILL_MOVE_SILENTLY skillBonus:2 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:3 resistance:RESIST_NONE effect:0 script:nil];
			break;
			case 1: // heavy armor
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BODYARMOR name:@"Adamantine Chest Plate" weight:11 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:9 icon:89 value:2000 count:0 damage:0 armorRating:9 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_HELMET name:@"Adamantine Great Helm" weight:4 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:4 icon:68 value:2500 count:0 damage:0 armorRating:5 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_LEGGINGS name:@"Adamantine Greaves" weight:9 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:4 icon:56 value:1400 count:0 damage:0 armorRating:6 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			
			if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
			[document addItem:slot itemType:ITEM_BOOTS name:@"Adamantine Plate Boots" weight:5 skillRequired:SKILL_ARMOR_HEAVY
				   occurrence:4 icon:99 value:990 count:0 damage:0 armorRating:5 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
					  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
			break;
	}
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_BODYARMOR name:@"Adamantine Great Shield" weight:10 skillRequired:SKILL_ARMOR_SHIELDS
		   occurrence:4 icon:94 value:1750 count:0 damage:0 armorRating:5 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
}

- (void)avatarArmor: (id)sender {
	int slot, equSlot;
	SkillType armorSkill;
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	switch ([self armorType]) {
		case 0: // light armor
			armorSkill = SKILL_ARMOR_LIGHT;
			break;
		case 1: // heavy armor
			armorSkill = SKILL_ARMOR_HEAVY;
			break;
	}
	// ok ,try to equip our hero so that he's ready to fight
	
	// helmet -     ar=1 ar+100        int+30 spot_hidden+30     elemental_resistance
	equSlot = EQUIPPED_SLOT_BASE + SLOT_HELMET;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_HELMET name:@"Great Thought" weight:1.5 skillRequired:armorSkill
		   occurrence:9 icon:68 value:0 count:0 damage:0 armorRating:1 attr:ATTR_INTELLIGENCE attrBonus:30
				skill:SKILL_ELEMENTAL skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
			  arBonus:100 resistance:RESIST_ELEMENTS effect:0 script:nil];
	
	// body armor - ar=1 ar+100        end+30 SKILL_ARMOR_LIGHT+30     disease_resistance
	equSlot = EQUIPPED_SLOT_BASE + SLOT_BODY;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_BODYARMOR name:@"Hauberk of Chrom" weight:5.0 skillRequired:armorSkill
		   occurrence:9 icon:89 value:0 count:0 damage:0 armorRating:1 attr:ATTR_ENDURANCE attrBonus:30
				skill:armorSkill skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
			  arBonus:100 resistance:RESIST_DISEASE effect:0 script:nil];
	
	// cloak -      ar=1 ar+100        wis+30 hide_in_shadows+30 magick_resistance
	equSlot = EQUIPPED_SLOT_BASE + SLOT_CLOAK;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_CLOAK name:@"Mantle of the Night" weight:2.0 skillRequired:armorSkill
		   occurrence:9 icon:52 value:0 count:0 damage:0 armorRating:1 attr:ATTR_WISDOM attrBonus:30
				skill:SKILL_HIDE_IN_SHADOWS skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
			  arBonus:100 resistance:RESIST_MAGICK effect:0 script:nil];
	
	// belt -      ar=1 ar+100         str+40 
	equSlot = EQUIPPED_SLOT_BASE + SLOT_BELT;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_BELT name:@"Girdle of the Titans" weight:2.0 skillRequired:armorSkill
		   occurrence:9 icon:59 value:0 count:0 damage:0 armorRating:1 attr:ATTR_STRENGTH attrBonus:40
				skill:SKILL_DIVINATION skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
			  arBonus:100 resistance:RESIST_TOXIN effect:0 script:nil];
	
	// leggins -    ar=1 ar+100        per+30 dodge+30           RESIST_TOXIN_resistance
	equSlot = EQUIPPED_SLOT_BASE + SLOT_PANTS;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_LEGGINGS name:@"Pantaloons of the Witness" weight:2.0 skillRequired:armorSkill
		   occurrence:9 icon:56 value:0 count:0 damage:0 armorRating:1 attr:ATTR_PERCEPTION attrBonus:30
				skill:SKILL_MERCANTILE skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
			  arBonus:100 resistance:RESIST_TOXIN effect:0 script:nil];
	
	// boots -      ar=1 ar+100        spd+30 move_silent+30     disease_resistance
	equSlot = EQUIPPED_SLOT_BASE + SLOT_BOOTS;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_BOOTS name:@"Boots of the Divine Messenger" weight:2.0 skillRequired:armorSkill
		   occurrence:9 icon:97 value:0 count:0 damage:0 armorRating:1 attr:ATTR_SPEED attrBonus:30
				skill:SKILL_MOVE_SILENTLY skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
			  arBonus:100 resistance:RESIST_DISEASE effect:0 script:nil];
	
	// ITEM_GAUNTLETS -  ar=1 ar+100        dex+30 SKILL_UNARMED_COMBAT+30  RESIST_TOXIN resistance
	equSlot = EQUIPPED_SLOT_BASE + SLOT_GAUNTLETS;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_GAUNTLETS name:@"Cestus of the Titans" weight:2.0 skillRequired:armorSkill
		   occurrence:9 icon:76 value:0 count:0 damage:0 armorRating:1 attr:ATTR_DEXTERITY attrBonus:30
				skill:SKILL_UNARMED_COMBAT skillBonus:30 hitPoints:100 mana:100 toHitBonus:100 damageBonus:100
			  arBonus:100 resistance:RESIST_TOXIN effect:0 script:nil];
	
	// shield -     ar=1 ar+100               shield+30          magick_resistance
	
	GHItem * item = [[GHItem alloc] initFromSlot:slot ofDocument:document];
	
	// cannot wear a shield when wielding a bow
	if ([item getItemProperty:@"Required Skill"] != SKILL_WEAPON_BOW) {
		equSlot = EQUIPPED_SLOT_BASE + SLOT_SHIELD;
		slot = [document findFirstEmptySlot];
		if (slot != -1) [document moveItem:equSlot to:slot];
	} else {
		if ((equSlot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	
	[document addItem:equSlot itemType:ITEM_SHIELD name:@"Aegis of Light" weight:3.0 skillRequired:SKILL_ARMOR_SHIELDS
		   occurrence:9 icon:94 value:0 count:0 damage:0 armorRating:1 attr:ATTR_CONCENTRATION attrBonus:30
				skill:SKILL_ARMOR_SHIELDS skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
			  arBonus:100 resistance:RESIST_MAGICK effect:0 script:nil];
}

#pragma mark -
#pragma mark Potions

- (void)catsEyePotions: (id)sender {
	int slot;
	if ((slot = [document findFirstQuickSlot]) == -1) {
		if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	switch ([self potionQuality]) {
		case 0:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Cat's Eyes" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:1 icon:179 value:30 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Cat's Eyes) 2 ; to_flask"];
			break;
		case 1:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Cat's Eyes II" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:9 icon:179 value:0 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Cat's Eyes) 8 ; to_flask"];
			break;
		case 2:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Cat's Eyes III" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:9 icon:179 value:0 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Cat's Eyes) 18 ; to_flask"];
			break;
	}
}

- (void)cureDiseasePotions: (id)sender {
	int slot;
	if ((slot = [document findFirstQuickSlot]) == -1) {
		if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	switch ([self potionQuality]) {
		case 0:
		case 1:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Cure Lesser Disease" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:2 icon:238 value:110 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; cure_disease 3 ; to_flask"];
			break;
		case 2:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Cure Greater Disease" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:3 icon:237 value:400 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; cure_disease 6 ; to_flask"];
			break;
	}
}

- (void)hastePotions: (id)sender {
	int slot;
	if ((slot = [document findFirstQuickSlot]) == -1) {
		if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	switch ([self potionQuality]) {
		case 0:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Haste I" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:1 icon:135 value:20 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Haste) 2 ; to_flask"];
			break;
		case 1:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Haste II" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:2 icon:145 value:40 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Haste) 4 ; to_flask"];
			break;
		case 2:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Haste III" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:4 icon:155 value:90 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Haste) 6 ; to_flask"];
			break;
	}
}

- (void)healingPotions: (id)sender {
	int slot;
	if ((slot = [document findFirstQuickSlot]) == -1) {
		if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	switch ([self potionQuality]) {
		case 0:
			[document addItem:slot itemType:ITEM_POTION name:@"Healing Elixir III" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:1 icon:134 value:15 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"cond_health ; Message(You feel the elixir course through your veins.) ; Heal 15 0 ;Sound(SFX_quaff) ; Sound(SFX_Heal) ; to_flask"];
			break;
		case 1:
			[document addItem:slot itemType:ITEM_POTION name:@"Healing Elixir II" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:2 icon:144 value:45 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"cond_health ; Message(You feel the elixir course through your veins.) ; Heal 40 0 ;Sound(SFX_quaff) ; Sound(SFX_Heal) ; to_flask"];
			break;
		case 2:
			[document addItem:slot itemType:ITEM_POTION name:@"Healing Elixir III" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:3 icon:154 value:100 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"cond_health ; Message(You feel the elixir course through your veins.) ; Heal 90 0 ;Sound(SFX_quaff) ; Sound(SFX_Heal) ; to_flask"];
			break;
	}
	
}

- (void)invisibilityPotions: (id)sender {
	int slot;
	if ((slot = [document findFirstQuickSlot]) == -1) {
		if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	switch ([self potionQuality]) {
		case 0:
			[document addItem:slot itemType:ITEM_POTION name:@"Invisibility I" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:2 icon:139 value:40 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"sound (SFX_Quaff) ; effect (Invisible) 2 ; to_flask"];
			break;
		case 1:
			[document addItem:slot itemType:ITEM_POTION name:@"Invisibility II" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:3 icon:149 value:90 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"sound (SFX_Quaff) ; effect (Invisible) 4 ; to_flask"];
			break;
		case 2:
			[document addItem:slot itemType:ITEM_POTION name:@"Invisibility III" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:4 icon:159 value:200 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"sound (SFX_Quaff) ; effect (Invisible) 6 ; to_flask"];
			break;
	}
}

- (void)leatherSkinPotions: (id)sender {
	int slot;
	if ((slot = [document findFirstQuickSlot]) == -1) {
		if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	switch ([self potionQuality]) {
		case 0:
			[document addItem:slot itemType:ITEM_POTION name:@"Leatherskin I" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:1 icon:138 value:20 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"sound (SFX_Quaff) ; effect (Leatherskin) 2 ; to_flask"];
			break;
		case 1:
			[document addItem:slot itemType:ITEM_POTION name:@"Leatherskin II" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:2 icon:148 value:40 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"sound (SFX_Quaff) ; effect (Leatherskin) 4 ; to_flask"];
			break;
		case 2:
			[document addItem:slot itemType:ITEM_POTION name:@"Leatherskin III" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:3 icon:158 value:90 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"sound (SFX_Quaff) ; effect (Leatherskin) 6 ; to_flask"];
			break;
	}
}

- (void)manaPotions: (id)sender {
	int slot;
	if ((slot = [document findFirstQuickSlot]) == -1) {
		if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	switch ([self potionQuality]) {
		case 0:
			[document addItem:slot itemType:ITEM_POTION name:@"Mana Potion I" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:2 icon:136 value:15 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"cond_mana ; Message(You feel a surge of power as the potion restores your arcane energies.) ; Restore 15 ; Sound(SFX_Quaff) ; Sound(SFX_Restore) ; to_flask"];
			break;
		case 1:
			[document addItem:slot itemType:ITEM_POTION name:@"Mana Potion II" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:2 icon:146 value:45 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"cond_mana ; Message(You feel a surge of power as the potion restores your arcane energies.) ; Restore 40 ; Sound(SFX_Quaff) ; Sound(SFX_Restore) ; to_flask"];
			break;
		case 2:
			[document addItem:slot itemType:ITEM_POTION name:@"Mana Potion III" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:4 icon:156 value:100 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 
					   script:@"cond_mana ; Message(You feel a surge of power as the potion restores your arcane energies.) ; Restore 90 ; Sound(SFX_Quaff) ; Sound(SFX_Restore) ; to_flask"];
			break;
	}
}

- (void)predatorSightPotions: (id)sender {
	int slot;
	if ((slot = [document findFirstQuickSlot]) == -1) {
		if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	}
	switch ([self potionQuality]) {
		case 0:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Predator Sight" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:1 icon:38 value:70 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Predator Sight) 3 ; to_flask"];
			break;
		case 1:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Predator Sight II" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:9 icon:38 value:0 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Predator Sight) 8 ; to_flask"];
			break;
		case 2:
			[document addItem:slot itemType:ITEM_POTION name:@"Potion of Predator Sight III" weight:0.3 skillRequired:SKILL_NONE
				   occurrence:9 icon:38 value:0 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
						skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
				   resistance:RESIST_NONE effect:0 script:@"sound (SFX_Quaff) ; effect (Predator Sight) 18 ; to_flask"];
			break;
	}
}

#pragma mark -
#pragma mark Misc

- (void)alchemyBooks: (id)sender {
	int slot;
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_NOTE name:@"The Alchemist's Cookbook I" weight:2 skillRequired:SKILL_NONE
		   occurrence:1 icon:193 value:15 count:0 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:@"Sound(SFX_Stats_Open) ; book 4"];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_NOTE name:@"The Alchemist's Cookbook II" weight:2 skillRequired:SKILL_NONE
		   occurrence:2 icon:188 value:50 count:0 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:@"Sound(SFX_Stats_Open) ; book 6"];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_NOTE name:@"The Alchemist's Cookbook III" weight:2 skillRequired:SKILL_NONE
		   occurrence:3 icon:194 value:75 count:0 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:@"Sound(SFX_Stats_Open) ; book 5"];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_NOTE name:@"Imbuing Your Equipment" weight:2 skillRequired:SKILL_NONE
		   occurrence:2 icon:194 value:50 count:0 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:@"Sound(SFX_Stats_Open) ; book 34"];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_NOTE name:@"The Art of Brewing" weight:2 skillRequired:SKILL_NONE
		   occurrence:2 icon:194 value:50 count:0 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:@"Sound(SFX_Stats_Open) ; book 28 ; learn_book 31"];
}

- (void)amulets: (id)sender {
}

- (void)lockpicks: (id)sender {
	int slot;
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	
	[document addItem:slot itemType:ITEM_LOCKPICK name:@"Lock Pick" weight:0.1 skillRequired:SKILL_NONE
		   occurrence:1 icon:126 value:15 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_LOCKPICK skillBonus:2 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
			  arBonus:0 resistance:RESIST_NONE effect:0 script:nil];
}

- (void)reagents: (id)sender {
	int slot;
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REAGENT name:@"Ambergris" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:2 icon:160 value:25 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REAGENT name:@"Ash" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:1 icon:142 value:7 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REAGENT name:@"Belladonna" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:2 icon:162 value:42 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REAGENT name:@"Ectoplasm" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:4 icon:170 value:100 count:20 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REAGENT name:@"Jelly Fungus" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:2 icon:140 value:25 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REAGENT name:@"Mandrake Root" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:1 icon:150 value:30 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REAGENT name:@"Willow Sap" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:1 icon:180 value:10 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];   
}

- (void)reactants: (id)sender {
	int slot;
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REACTANT name:@"Acid" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:1 icon:181 value:25 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];   
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REACTANT name:@"Bromine" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:2 icon:171 value:40 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];   
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REACTANT name:@"Charcoal" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:1 icon:151 value:35 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];   
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REACTANT name:@"Mercury" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:2 icon:161 value:35 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];   
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REACTANT name:@"Serpent Venom" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:2 icon:152 value:45 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];   
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REACTANT name:@"Spider Silk" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:1 icon:192 value:20 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];   
	
	if ((slot = [document findFirstEmptySlot]) == -1) { [self noFreeSlots]; return; }
	[document addItem:slot itemType:ITEM_REACTANT name:@"Sulfur" weight:0.3 skillRequired:SKILL_NONE
		   occurrence:1 icon:141 value:8 count:10 damage:0 armorRating:0 attr:ATTR_NONE attrBonus:0
				skill:SKILL_NONE skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
		   resistance:RESIST_NONE effect:0 script:nil];   
	
}

- (void)rings: (id)sender {
}

// add 10 torches
- (void) torches: (id)sender {
	int c;
	c = [document spellStat:0 section:1];
	c += 10; 
	if (c > 1000) c = 1000;  // limit any nonsense 
	[document setSpellStat:0 to:c section:1];
}

- (void) avatarJewelry: (id)sender {
	int slot, equSlot;
	
	equSlot = EQUIPPED_SLOT_BASE + SLOT_AMULET;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_AMULET name:@"Amulet of the Divine Wanderer" weight:0.1 skillRequired:SKILL_NONE
		   occurrence:9 icon:176 value:0 count:0 damage:0 armorRating:0 attr:ATTR_CONCENTRATION attrBonus:30
				skill:SKILL_CARTOGRAPHY skillBonus:30 hitPoints:50 mana:50 toHitBonus:0 damageBonus:0
			  arBonus:10 resistance:RESIST_MAGICK effect:0 script:nil];
	
	equSlot = EQUIPPED_SLOT_BASE + SLOT_RING_LEFT;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_RING name:@"Opener of Ways" weight:0.1 skillRequired:SKILL_NONE
		   occurrence:9 icon:112 value:0 count:0 damage:0 armorRating:0 attr:ATTR_DEXTERITY attrBonus:30
				skill:SKILL_LOCKPICK skillBonus:30 hitPoints:50 mana:50 toHitBonus:0 damageBonus:0
			  arBonus:10 resistance:RESIST_TOXIN effect:0 script:nil];
	
	equSlot = EQUIPPED_SLOT_BASE + SLOT_RING_RIGHT;
	slot = [document findFirstEmptySlot];
	if (slot != -1) [document moveItem:equSlot to:slot];
	[document addItem:equSlot itemType:ITEM_RING name:@"Circlet of Loki" weight:0.1 skillRequired:SKILL_NONE
		   occurrence:9 icon:113 value:0 count:0 damage:0 armorRating:0 attr:ATTR_PERCEPTION attrBonus:30
				skill:SKILL_TRAPS skillBonus:30 hitPoints:50 mana:50 toHitBonus:0 damageBonus:0
			  arBonus:10 resistance:RESIST_DISEASE effect:0 script:nil];
}


@end
