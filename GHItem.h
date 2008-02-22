//
//  GHItem.h
//  Goblin Hacker
//
//  Created by Administrator on 19/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

typedef NSInteger GHSlotIndex;

// The following is deprecated
#define FIRST_SLOT_LINE SLOT_LINE

enum {
	INVENTORY_BASE = 30,
	INVENTORY_MAX = 69, // slot 70 is unused = gold
	EQUIPPED_SLOT_BASE = 70,
	EQUIPPED_SLOT_MAX = 14,
	QUICK_SLOT_BASE = 84,
	QUICK_SLOT_MAX = 8
};

// Please use these ones instead
enum {
	SLOT_LINE = 30	// Offset from the start of the file in lines to the first slot
};

enum {
	SLOT_MIN = 0,	// 0 is valid
	SLOT_MAX = 92	// Number of slots, 92 is invalid slot
};

// These ranges are inclusive, i.e. start and end are valid slots within the range

// Range for inventory slots
enum {
	INVENTORY_SLOT_START = 0,
	INVENTORY_SLOT_END = 68,
};

// Range for equipped slots
enum {
	EQUIPPED_SLOT_START = 70,
	EQUIPPED_SLOT_END = 83,
};

// Range for quick slots
enum {
	QUICK_SLOT_START = 84,
	QUICK_SLOT_END = 91
};

typedef enum {
   SLOT_QUIVER = 0, SLOT_HELMET, SLOT_CLOAK, SLOT_AMULET, SLOT_BODY, SLOT_WEAPON, SLOT_BELT, SLOT_GAUNTLETS,
   SLOT_PANTS, SLOT_RING_RIGHT, SLOT_RING_LEFT, SLOT_SHIELD, SLOT_BOOTS, SLOT_WEAPON_ALT
} EquipmentSlot;

typedef enum {
   ATTR_NONE = 0, ATTR_STRENGTH, ATTR_DEXTERITY, ATTR_ENDURANCE, ATTR_SPEED, ATTR_INTELLIGENCE,
   ATTR_WISDOM, ATTR_PERCEPTION, ATTR_CONCENTRATION
} AttributeType;

typedef enum {
	ITEM_NONE = 0, ITEM_WEAPON, ITEM_ARROW, ITEM_HELMET, ITEM_CLOAK, ITEM_BODYARMOR, ITEM_BELT, ITEM_GAUNTLETS, 
	ITEM_LEGGINGS, ITEM_SHIELD, ITEM_BOOTS, ITEM_AMULET, ITEM_RING, ITEM_SCROLL, ITEM_UNKNOWN_1, ITEM_POTION,
	ITEM_REAGENT, ITEM_REACTANT, ITEM_MISC, ITEM_LOCKPICK, ITEM_GEM, ITEM_FOOD, ITEM_UNKNOWN_2, ITEM_NOTE,
	ITEM_QUEST, ITEM_KEY
} ItemType;

typedef enum {
	RESIST_NONE = 0, RESIST_ELEMENTS, RESIST_TOXIN, RESIST_MAGICK, RESIST_DISEASE
} ResistanceType;

typedef enum {
	SKILL_NONE = 0, SKILL_ALCHEMY, SKILL_DIVINATION, SKILL_ELEMENTAL, SKILL_ARMOR_LIGHT, SKILL_ARMOR_HEAVY, 
	SKILL_ARMOR_SHIELDS, SKILL_CARTOGRAPHY, SKILL_DODGE, SKILL_HIDE_IN_SHADOWS, SKILL_LORE, SKILL_MEDITATION,
	SKILL_MERCANTILE, SKILL_MOVE_SILENTLY, SKILL_LOCKPICK, SKILL_TRAPS, SKILL_SPOT, SKILL_SURVIVAL, SKILL_UNARMED_COMBAT,
	SKILL_WEAPON_MACE, SKILL_WEAPON_BOW, SKILL_WEAPON_AXE, SKILL_WEAPON_SHORT, SKILL_WEAPON_SWORD,
	SKILL_WEAPON_THROWN
} SkillType;

@interface GHItem : NSObject {
	NSMutableData *line1, *line2;
}

// Information about item structure
+ (NSArray*) items;
+ (NSDictionary*) properties;
+ (NSString*) slotName: (NSInteger)index;

- init;
- initWithProperties: (NSDictionary*)props;

- (BOOL) validItem;

// Slot is base-0
- initFromSlot: (NSUInteger)slot ofDocument: (GHSavedGameDocument*)document;

- (NSInteger)getPropertyOffset: (NSString *)propertyString;

- (NSInteger)getItemProperty: (NSString *)propertyString;
- (void)setItemProperty: (NSString*)propertyString to: (NSInteger)val;

- (void)setProperties: (NSDictionary*)properties;
- (NSDictionary*) getProperties;
- (NSArray*) itemData;

- (BOOL) identified;
- (void) setIdentified: (BOOL)to;

- (NSString*)name;
- (int)equipmentType;
- (double)weight;
- (int)skillRequired;
- (int)occurrence;
- (int)iconIndex;
- (int)value;
- (bool)known;
- (int)stackCount;
- (int)baseDamage;
- (int)armorRating;
- (int)attrGranted;
- (int)attrBonus;
- (int)skillGranted;
- (int)skillBonus;
- (int)hpBonus;
- (int)manaBonus;
- (int)toHitBonus;
- (int)damageBonus;
- (int)arBonus;
- (int)resistance;
- (int)effect;
- (NSString*)script;

- (void)setName: (NSString*)val;
- (void)setEquipmentType: (int)val;
- (void)setWeight: (double)val;
- (void)setSkillRequired: (int)val;
- (void)setOccurrence: (int)val;
- (void)setIconIndex: (int)val;
- (void)setValue: (int)val;
- (void)setKnown: (bool)val;
- (void)setStackCount: (int)val;
- (void)setBaseDamage: (int)val;
- (void)setArmorRating: (int)val;
- (void)setAttrGranted: (int)val;
- (void)setAttrBonus: (int)val;
- (void)setSkillGranted: (int)val;
- (void)setSkillBonus: (int)val;
- (void)setHpBonus: (int)val;
- (void)setManaBonus: (int)val;
- (void)setToHitBonus: (int)val;
- (void)setDamageBonus: (int)val;
- (void)setArBonus: (int)val;
- (void)setResistance: (int)val;
- (void)setEffect: (int)val;
- (void)setScript: (NSString*)val;

@end
