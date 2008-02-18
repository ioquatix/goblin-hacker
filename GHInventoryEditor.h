//
//  GHInventoryEditor.h
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

@interface GHInventoryEditor : NSObject {
	IBOutlet GHSavedGameDocument * document;
	IBOutlet NSWindow * window;
	IBOutlet NSView * inventoryEditorView;   

   int wantedArmorType;
   int wantedWeaponType;
   int wantedPotionQuality;
}

typedef enum {
   noAttr, strength, dexterity, endurance, speed, intelligence, wisdom, perception, concentration
} attrType;

typedef enum {
   noItem, weapon, arrow, helmet, cloak, body_armor, belt, gauntlets, leggins, shield, boots,
   amulet, ring, scroll, unknown_1, potion, reagent, reactant, misc, lockpick, gem, food,
   unknown_2, note, quest, key
} itemType;

typedef enum {
   noResist, elements, toxin, magick, disease
} resistType;

typedef enum {
   noSkill, alchemy, divination, elemental, armor_light, armor_heavy, armor_shields,
   cartography, dodge, hide_in_shadows, lore, meditation, mercantile, move_silently,
   pick_locks, skull_duggery, spot_hidden, survival, unarmed_combat,
   weapon_mace, weapon_bow, weapon_axe, weapon_short,
   weapon_sword, weapon_thrown
} skillType;

typedef enum {
   sl_arrow, sl_helmet, sl_cloak, sl_amulet, sl_body, sl_weapon, sl_belt, sl_gauntlets,
   sl_pants, sl_ring_r, sl_ring_l, sl_shield, sl_boots, sl_alt_weapon
} equipSlots;

- (int)findFirstQuickSlot;
- (int)findFirstEmptySlot;
- (bool)isSlotFree:(int)slot;

- (IBAction) show: (id)sender;
+ (NSArray*) items;

- (void)addItem:(int)slot itemType:(itemType)it name:(NSString*)nam weight:(double)weight
        skillRequired:(skillType)skreq occurrence:(int)occ icon:(int)iconNr value:(int)val
        count:(int)nr damage:(int)dam armorRating:(int)ar attr:(attrType)attr attrBonus:(int)attrbon
        skill:(skillType)skgrant skillBonus:(int)skbon hitPoints:(int)hp mana:(int)mana
        toHitBonus:(int)hitbon damageBonus:(int)dambon arBonus:(int)arbon
        resistance:(resistType)res effect:(int)eff script:(NSString*)script;

- (void)moveItem:(int)srcSlot to:(int)destSlot;

- (int)armorType;
- (int)weaponType;
- (int)potionQuality;
- (void)setArmorType: (int)val;
- (void)setWeaponType: (int)val;
- (void)setPotionQuality: (int)val;

- (IBAction)healingPotions:      (id)sender;
- (IBAction)manaPotions:         (id)sender;
- (IBAction)cureDiseasePotions:  (id)sender;
- (IBAction)catsEyePotions:      (id)sender;
- (IBAction)predatorSightPotions:(id)sender;
- (IBAction)leatherSkinPotions:  (id)sender;
- (IBAction)hastePotions:        (id)sender;
- (IBAction)invisibilityPotions: (id)sender;

- (IBAction)basicWeapon:  (id)sender;
- (IBAction)goodWeapon:   (id)sender;
- (IBAction)superbWeapon: (id)sender;
- (IBAction)avatarWeapon: (id)sender;

- (IBAction)basicArmor:  (id)sender;
- (IBAction)goodArmor:   (id)sender;
- (IBAction)superbArmor: (id)sender;
- (IBAction)avatarArmor: (id)sender;

- (IBAction)alchemyBooks: (id)sender;
- (IBAction)amulets: (id)sender;
- (IBAction)lockpicks: (id)sender;
- (IBAction)reagents: (id)sender;
- (IBAction)reactants: (id)sender;
- (IBAction)rings: (id)sender;
- (IBAction)torches: (id)sender;

- (IBAction)avatarJewelry: (id)sender;


@property (retain) NSView * inventoryEditorView;
// @property (retain) NSView * itemEditorView;
@property (retain) NSWindow * window;
@property (retain) GHSavedGameDocument * document;
@end
