//
//  GHInventoryEditor.m
//  Goblin Hacker
//
//  Re-Created by Hermann Gundel on 22/01/08.
//
//  2008-01-22 hgu - methods for easy item acquisition
//       find empty slot, give armor/missiles/potions/weapons
//       structure info and display strings in items.plist
//  2008-01-27 hgu - more methods for item handling
//       addItem, moveItem
//

#import "GHInventoryEditor.h"
#import "GHItemEditor.h"
#include "Endian.h"

#define FIRST_SLOT_LINE    30
#define INVENTORY_MAX      69
#define EQUIPPED_SLOT_BASE 71
#define QUICK_SLOT_BASE    85
#define QUICK_SLOT_MAX     8

@implementation GHInventoryEditor

+ (NSArray*) items 
{
	static NSArray * items = nil;
	
	if (items == nil) {
		NSString * itemsPath = [[NSBundle mainBundle] pathForResource:@"item" ofType:@"plist"];
		items = [[NSArray arrayWithContentsOfFile:itemsPath] retain];
	}
	
	return items;
}

- (int)wantedPotionQuality {
   return wantedPotionQuality;
}

- (int)wantedArmorType {
   return wantedArmorType;
}

- (int)wantedWeaponType {
   return wantedWeaponType;
}

- (int) findFirstEmptySlot {
   int slot;
   
   for (slot = 1; slot <= INVENTORY_MAX; slot++) {
      if ([self isSlotFree:slot]) break;
   }
   if (slot == INVENTORY_MAX + 1) {
      return 0;
   } 
   return slot;
}

- (int) findFirstQuickSlot {
   int slot;
   for (slot = QUICK_SLOT_BASE; slot < QUICK_SLOT_BASE + QUICK_SLOT_MAX; slot++) {
      if ([self isSlotFree:slot]) break;
   }
   if (slot == QUICK_SLOT_BASE + QUICK_SLOT_MAX) {
      return 0;
   } 
   return slot;
}

- (bool)isSlotFree: (int)slot {
   int line = FIRST_SLOT_LINE + (slot - 1)* 3;
   const uint32_t *l = (const uint32_t*)[[document dataForIndex:line] bytes];
   if (orderRead(l[2], LITTLE, hostEndian()) == 0)
      return TRUE;
   else
      return FALSE;
}

- (int) getItemType: (int)slot {
   int line = FIRST_SLOT_LINE + (slot - 1)* 3;
   const uint32_t *l = (const uint32_t*)[[document dataForIndex:line] bytes];
   return orderRead(l[2], LITTLE, hostEndian());
}

- (void)addItem:(int)slot itemType:(itemType)it name:(NSString*)nam weight:(double)weight
        skillRequired:(skillType)skreq occurrence:(int)occ icon:(int)iconNr value:(int)val
        count:(int)nr damage:(int)dam armorRating:(int)ar attr:(attrType)attr attrBonus:(int)attrbon
        skill:(skillType)skgrant skillBonus:(int)skbon hitPoints:(int)hp mana:(int)mana
        toHitBonus:(int)hitbon damageBonus:(int)dambon arBonus:(int)arbon
        resistance:(resistType)res effect:(int)eff script:(NSString*)script;

{
   GHItemEditor * itemEditor = [GHItemEditor new];
   if ([itemEditor getDoc] == nil) [itemEditor setDoc:document];
   [itemEditor setSlotNr:slot];
   [itemEditor reload];
   [itemEditor setItemName:nam];
   [itemEditor setItemClass:it];
   [itemEditor setItemWeight:weight];
   [itemEditor setSkillRequired:skreq];
   [itemEditor setOccurrence:occ];
   [itemEditor setIconNr:iconNr];
   [itemEditor setItemValue:val];
   [itemEditor setItemKnown:TRUE];
   [itemEditor setItemCount:nr];
   [itemEditor setItemDamage:dam];
   [itemEditor setItemArmorRating:ar];
   [itemEditor setAttrGranted:attr];
   [itemEditor setAttrBonus:attrbon];
   [itemEditor setSkillGranted:skgrant];
   [itemEditor setSkillBonus:skbon];
   [itemEditor setHpBonus:hp];
   [itemEditor setManaBonus:mana];
   [itemEditor setToHitBonus:hitbon];
   [itemEditor setDamageBonus:dambon];
   [itemEditor setArBonus:arbon];
   [itemEditor setItemResistance:res];
   [itemEditor setItemEffect:eff];
   [itemEditor setItemScript:script];
   
   [itemEditor saveItem];
}

// try to keep the time of inconsistency short, we don't want semaphores
- (void)moveItem:(int)srcSlot to:(int)destSlot {
   if ([self isSlotFree:srcSlot]) return; 
   if (![self isSlotFree:destSlot]) return;
   NSData *src1, *src2, *dest1, *dest2;
   src1 = [document dataForIndex:FIRST_SLOT_LINE + (srcSlot - 1)*3];
   src2 = [document dataForIndex:FIRST_SLOT_LINE + (srcSlot - 1)*3 + 1];
   dest1 = [document dataForIndex:FIRST_SLOT_LINE + (destSlot - 1)*3];
   dest2 = [document dataForIndex:FIRST_SLOT_LINE + (destSlot - 1)*3 + 1];
   [document setData:src1 forIndex:FIRST_SLOT_LINE + (destSlot - 1)*3];
   [document setData:src2 forIndex:FIRST_SLOT_LINE + (destSlot - 1)*3 + 1];
}

- (int)armorType {
   return wantedArmorType;
}

- (int)weaponType {
   return wantedWeaponType;
}

- (int)potionQuality {
   return wantedPotionQuality;
}

- (void)setArmorType: (int)val {
   wantedArmorType = val;
}

- (void)setWeaponType: (int)val {
   wantedWeaponType = val;
}

- (void)setPotionQuality: (int)val {
   wantedPotionQuality = val;
}

//***************************** Weapons ********************************
- (void)basicWeapon: (id)sender {
   int slot;
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   switch ([self weaponType]) {
      case 0: // arrows
         [self addItem:slot itemType:arrow name:@"Arrow" weight:0.1 skillRequired:noSkill
               occurrence:1 icon:20 value:1 count:100 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 1: // grenades
           [self addItem:slot itemType:weapon name:@"Demon Oil I" weight:0.3 skillRequired:weapon_thrown
               occurrence:1 icon:137 value:30 count:30 damage:10 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
       break;
      case 2: // axes
          [self addItem:slot itemType:weapon name:@"Iron Hand Axe" weight:2 skillRequired:weapon_axe
               occurrence:1 icon:31 value:22 count:0 damage:2 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:elements effect:0 script:NULL];
       break;
      case 3: // short blades
          [self addItem:slot itemType:weapon name:@"Steel Dagger" weight:0.8 skillRequired:weapon_short
               occurrence:2 icon:2 value:85 count:0 damage:2 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
        break;
      case 4: // bows
       [self addItem:slot itemType:weapon name:@"Yew Short Bow" weight:2 skillRequired:weapon_bow
               occurrence:1 icon:22 value:160 count:0 damage:2 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:elements effect:0 script:NULL];
        break;
      case 5: // maces
         [self addItem:slot itemType:weapon name:@"Copper Hammer" weight:3 skillRequired:weapon_mace
               occurrence:1 icon:10 value:20 count:0 damage:2 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 6: //swords
           [self addItem:slot itemType:weapon name:@"Iron Short Sword" weight:3 skillRequired:weapon_sword
               occurrence:1 icon:40 value:30 count:0 damage:2 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
        break;
   }
}

- (void)goodWeapon: (id)sender {
   int slot;
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   switch ([self weaponType]) {
      case 0: // arrows
         [self addItem:slot itemType:arrow name:@"Flight Arrow" weight:0.1 skillRequired:noSkill
               occurrence:2 icon:20 value:4 count:100 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:1 damageBonus:2
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 1: // grenades
         [self addItem:slot itemType:weapon name:@"Demon Oil III" weight:0.3 skillRequired:weapon_thrown
               occurrence:2 icon:147 value:60 count:30 damage:20 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 2: // axes
         [self addItem:slot itemType:weapon name:@"Steel Double Battle Axe" weight:4 skillRequired:weapon_axe
               occurrence:2 icon:36 value:385 count:0 damage:5 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:elements effect:0 script:NULL];
         break;
      case 3: // short blades
         [self addItem:slot itemType:weapon name:@"Mithril Dagger" weight:1 skillRequired:weapon_short
               occurrence:3 icon:3 value:310 count:0 damage:4 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 4: // bows
       [self addItem:slot itemType:weapon name:@"Composite Longbow" weight:5 skillRequired:weapon_bow
               occurrence:3 icon:24 value:550 count:0 damage:5 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:elements effect:0 script:NULL];
         break;
      case 5: // maces
         [self addItem:slot itemType:weapon name:@"Steel Warhammer" weight:7 skillRequired:weapon_mace
               occurrence:2 icon:12 value:410 count:0 damage:5 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 6: //swords
          [self addItem:slot itemType:weapon name:@"Steel Long Sword" weight:4.5 skillRequired:weapon_sword
               occurrence:2 icon:42 value:400 count:0 damage:5 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
   }
}

- (void)superbWeapon: (id)sender {
   int slot;
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   switch ([self weaponType]) {
      case 0: // arrows
         [self addItem:slot itemType:arrow name:@"Diamond Head Arrows" weight:0.1 skillRequired:noSkill
               occurrence:4 icon:21 value:30 count:100 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:5 damageBonus:4
               arBonus:0 resistance:noResist effect:0 script:NULL];
        break;
      case 1: // grenades
         [self addItem:slot itemType:weapon name:@"Demon Oil III" weight:0.3 skillRequired:weapon_thrown
               occurrence:3 icon:157 value:120 count:30 damage:30 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 2: // axes
         [self addItem:slot itemType:weapon name:@"Diamond-edge Great Axe +3" weight:8 skillRequired:weapon_axe
               occurrence:4 icon:37 value:2600 count:0 damage:8 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:3 damageBonus:3
               arBonus:0 resistance:elements effect:0 script:NULL];
         break;
      case 3: // short blades
         [self addItem:slot itemType:weapon name:@"Adamantine Dagger +5" weight:1.5 skillRequired:weapon_short
               occurrence:4 icon:3 value:1500 count:0 damage:5 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:5 damageBonus:5
               arBonus:0 resistance:noResist effect:3 script:NULL];
         break;
      case 4: // bows
         [self addItem:slot itemType:weapon name:@"Composite Great Bow +3" weight:7 skillRequired:weapon_bow
               occurrence:4 icon:25 value:1800 count:0 damage:7 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:3 damageBonus:3
               arBonus:0 resistance:elements effect:0 script:NULL];
         break;
      case 5: // maces
          [self addItem:slot itemType:weapon name:@"Adamantine War Hammer +3" weight:8 skillRequired:weapon_mace
               occurrence:4 icon:14 value:2700 count:0 damage:8 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:3 damageBonus:3
               arBonus:0 resistance:noResist effect:0 script:NULL];
        break;
      case 6: //swords
          [self addItem:slot itemType:weapon name:@"Adamantine Great Sword" weight:10 skillRequired:weapon_sword
               occurrence:4 icon:45 value:2000 count:0 damage:10 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
   }      
}

- (void)avatarWeapon: (id)sender {
   int slot, equSlot;
   if ([self weaponType] == 0) {
      equSlot = EQUIPPED_SLOT_BASE + sl_arrow;
   } else {
      equSlot = EQUIPPED_SLOT_BASE + sl_weapon;
   }
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   slot = equSlot;
   switch ([self weaponType]) {
      case 0: //arrows
         [self addItem:slot itemType:arrow name:@"Arrows of Annihilation" weight:0.1 skillRequired:noSkill
               occurrence:9 icon:21 value:0 count:200 damage:10 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 1: //grenades
         [self addItem:slot itemType:weapon name:@"Demon Oil X" weight:0.3 skillRequired:weapon_thrown
               occurrence:9 icon:39 value:0 count:40 damage:100 armorRating:0 attr:noAttr attrBonus:0
               skill:weapon_thrown skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 2: // axes
         [self addItem:slot itemType:weapon name:@"Decapitator" weight:5.0 skillRequired:weapon_axe
               occurrence:9 icon:35 value:0 count:0 damage:20 armorRating:0 attr:strength attrBonus:30
               skill:weapon_axe skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
               arBonus:0 resistance:elements effect:0 script:NULL];
         break;
      case 3: // short blades
         [self addItem:slot itemType:weapon name:@"Dagger of Assassination" weight:1.0 skillRequired:weapon_short
               occurrence:9 icon:3 value:0 count:0 damage:20 armorRating:0 attr:dexterity attrBonus:30
               skill:weapon_short skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
               arBonus:0 resistance:toxin effect:3 script:NULL];
         break;
      case 4: // bows
         [self addItem:slot itemType:weapon name:@"Great Bow of the Avatar" weight:5.0 skillRequired:weapon_bow
               occurrence:9 icon:25 value:0 count:0 damage:20 armorRating:0 attr:concentration attrBonus:30
               skill:weapon_bow skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
               arBonus:0 resistance:elements effect:0 script:NULL];
         break;
      case 5: // maces
         [self addItem:slot itemType:weapon name:@"Atomizer" weight:8.0 skillRequired:weapon_mace
               occurrence:9 icon:19 value:0 count:0 damage:25 armorRating:0 attr:strength attrBonus:60
               skill:weapon_mace skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
               arBonus:0 resistance:elements effect:0 script:NULL];
         break;
      case 6: // swords
         [self addItem:slot itemType:weapon name:@"Flamberge of the Gods" weight:5.0 skillRequired:weapon_sword
               occurrence:9 icon:47 value:0 count:0 damage:25 armorRating:0 attr:strength attrBonus:30
               skill:weapon_sword skillBonus:30 hitPoints:0 mana:0 toHitBonus:100 damageBonus:100
               arBonus:0 resistance:elements effect:0 script:NULL];
         break;
   }
}

//***************************** Armor ********************************
- (void)basicArmor: (id)sender {
   int slot;
   switch ([self armorType]) {
      case 0: // light armor
         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:body_armor name:@"Studded Leather Jerkin" weight:2 skillRequired:armor_light
               occurrence:1 icon:82 value:50 count:0 damage:0 armorRating:2 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
        [self addItem:slot itemType:helmet name:@"Leather Skullcap" weight:1 skillRequired:armor_light
               occurrence:1 icon:61 value:10 count:0 damage:0 armorRating:1 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
          [self addItem:slot itemType:leggins name:@"Hide Leggings" weight:3 skillRequired:armor_light
               occurrence:1 icon:55 value:32 count:0 damage:0 armorRating:1 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:boots name:@"Leather Sandals" weight:1 skillRequired:armor_light
               occurrence:1 icon:95 value:10 count:0 damage:0 armorRating:1 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
      case 1: // heavy armor
         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:body_armor name:@"Hard Leather Banded Armor" weight:5 skillRequired:armor_heavy
               occurrence:1 icon:78 value:150 count:0 damage:0 armorRating:3 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:helmet name:@"Iron Skullcap" weight:3 skillRequired:armor_heavy
               occurrence:1 icon:60 value:70 count:0 damage:0 armorRating:2 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
          [self addItem:slot itemType:leggins name:@"Ringmail Leggings" weight:6 skillRequired:armor_heavy
               occurrence:1 icon:56 value:85 count:0 damage:0 armorRating:2 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:boots name:@"Chainmail Boots" weight:3 skillRequired:armor_heavy
               occurrence:1 icon:97 value:110 count:0 damage:0 armorRating:2 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
   }
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:body_armor name:@"Wooden Buckler" weight:3 skillRequired:armor_shields
         occurrence:1 icon:93 value:10 count:0 damage:0 armorRating:1 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:NULL];
}

- (void)goodArmor: (id)sender {
   int slot;
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   switch ([self armorType]) {
      case 0: // light armor
         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:body_armor name:@"Diamond Studded Jerkin" weight:3 skillRequired:armor_light
               occurrence:3 icon:86 value:800 count:0 damage:0 armorRating:5 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
 
         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:helmet name:@"Steel Chainmail Coif" weight:2 skillRequired:armor_light
               occurrence:2 icon:65 value:250 count:0 damage:0 armorRating:3 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:leggins name:@"Mithril Studded Leggings" weight:3 skillRequired:armor_light
               occurrence:3 icon:55 value:800 count:0 damage:0 armorRating:4 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:boots name:@"Studded Leather Boots +1" weight:2 skillRequired:armor_light
               occurrence:2 icon:96 value:260 count:0 damage:0 armorRating:2 attr:noAttr attrBonus:0
               skill:unarmed_combat skillBonus:2 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:1 resistance:noResist effect:0 script:NULL];
         break;
      case 1: // heavy armor
         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:body_armor name:@"Steel Ring Mail Jerkin" weight:8 skillRequired:armor_heavy
               occurrence:2 icon:79 value:375 count:0 damage:0 armorRating:5 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
 
         if ((slot = [self findFirstEmptySlot]) == 0) return;
          [self addItem:slot itemType:helmet name:@"Iron Half-Helm" weight:3 skillRequired:armor_heavy
               occurrence:2 icon:63 value:220 count:0 damage:0 armorRating:3 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
 
         if ((slot = [self findFirstEmptySlot]) == 0) return;
          [self addItem:slot itemType:leggins name:@"Mithril Chainmail Leggings" weight:7 skillRequired:armor_heavy
               occurrence:3 icon:56 value:1000 count:0 damage:0 armorRating:4 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:boots name:@"Iron Spiked Boots" weight:2 skillRequired:armor_heavy
               occurrence:3 icon:98 value:320 count:0 damage:0 armorRating:3 attr:noAttr attrBonus:0
               skill:unarmed_combat skillBonus:2 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
   }
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:body_armor name:@"Large Steel Shield" weight:6 skillRequired:armor_shields
         occurrence:3 icon:92 value:315 count:0 damage:0 armorRating:3 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:NULL];
}

- (void)superbArmor: (id)sender {
   int slot;
   switch ([self armorType]) {
      case 0: // light armor
         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:body_armor name:@"Adamantine Studded Jerkin +3" weight:4 skillRequired:armor_light
               occurrence:4 icon:87 value:1500 count:0 damage:0 armorRating:6 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:3 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:helmet name:@"Mithril Coif of Divine Study" weight:1.5 skillRequired:armor_light
               occurrence:9 icon:65 value:3000 count:0 damage:0 armorRating:4 attr:intelligence attrBonus:3
               skill:divination skillBonus:3 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:leggins name:@"Diamond Studded Leggings" weight:4 skillRequired:armor_light
               occurrence:4 icon:56 value:1200 count:0 damage:0 armorRating:5 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:boots name:@"Thieves Softened Leather Boots +3" weight:1.5 skillRequired:armor_light
               occurrence:3 icon:96 value:765 count:0 damage:0 armorRating:2 attr:noAttr attrBonus:0
               skill:move_silently skillBonus:2 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:3 resistance:noResist effect:0 script:NULL];
         break;
      case 1: // heavy armor
         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:body_armor name:@"Adamantine Chest Plate" weight:11 skillRequired:armor_heavy
               occurrence:9 icon:89 value:2000 count:0 damage:0 armorRating:9 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:helmet name:@"Adamantine Great Helm" weight:4 skillRequired:armor_heavy
               occurrence:4 icon:68 value:2500 count:0 damage:0 armorRating:5 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:leggins name:@"Adamantine Greaves" weight:9 skillRequired:armor_heavy
               occurrence:4 icon:56 value:1400 count:0 damage:0 armorRating:6 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];

         if ((slot = [self findFirstEmptySlot]) == 0) return;
         [self addItem:slot itemType:boots name:@"Adamantine Plate Boots" weight:5 skillRequired:armor_heavy
               occurrence:4 icon:99 value:990 count:0 damage:0 armorRating:5 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
               arBonus:0 resistance:noResist effect:0 script:NULL];
         break;
   }
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:body_armor name:@"Adamantine Great Shield" weight:10 skillRequired:armor_shields
         occurrence:4 icon:94 value:1750 count:0 damage:0 armorRating:5 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:NULL];
}

- (void)avatarArmor: (id)sender {
   int slot, equSlot;
   skillType armorSkill;
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   switch ([self armorType]) {
      case 0: // light armor
         armorSkill = armor_light;
         break;
      case 1: // heavy armor
         armorSkill = armor_heavy;
         break;
   }
   // ok ,try to equip our hero so that he's ready to fight
   
   // helmet -     ar=1 ar+100        int+30 spot_hidden+30     elemental_resistance
   equSlot = EQUIPPED_SLOT_BASE + sl_helmet;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:helmet name:@"Great Thought" weight:1.5 skillRequired:armorSkill
         occurrence:9 icon:68 value:0 count:0 damage:0 armorRating:1 attr:intelligence attrBonus:30
         skill:elemental skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
         arBonus:100 resistance:elements effect:0 script:NULL];

   // body armor - ar=1 ar+100        end+30 light_armor+30     disease_resistance
   equSlot = EQUIPPED_SLOT_BASE + sl_body;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:body_armor name:@"Hauberk of Chrom" weight:5.0 skillRequired:armorSkill
         occurrence:9 icon:89 value:0 count:0 damage:0 armorRating:1 attr:endurance attrBonus:30
         skill:armorSkill skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
         arBonus:100 resistance:disease effect:0 script:NULL];
   
   // cloak -      ar=1 ar+100        wis+30 hide_in_shadows+30 magick_resistance
   equSlot = EQUIPPED_SLOT_BASE + sl_cloak;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:cloak name:@"Mantle of the Night" weight:2.0 skillRequired:armorSkill
         occurrence:9 icon:52 value:0 count:0 damage:0 armorRating:1 attr:wisdom attrBonus:30
         skill:hide_in_shadows skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
         arBonus:100 resistance:magick effect:0 script:NULL];

   // belt -      ar=1 ar+100         str+40 
   equSlot = EQUIPPED_SLOT_BASE + sl_belt;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:leggins name:@"Girdle of the Titans" weight:2.0 skillRequired:armorSkill
         occurrence:9 icon:59 value:0 count:0 damage:0 armorRating:1 attr:strength attrBonus:40
         skill:divination skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
         arBonus:100 resistance:toxin effect:0 script:NULL];
   
   // leggins -    ar=1 ar+100        per+30 dodge+30           toxin_resistance
   equSlot = EQUIPPED_SLOT_BASE + sl_pants;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:leggins name:@"Pantaloons of the Witness" weight:2.0 skillRequired:armorSkill
         occurrence:9 icon:56 value:0 count:0 damage:0 armorRating:1 attr:perception attrBonus:30
         skill:mercantile skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
         arBonus:100 resistance:toxin effect:0 script:NULL];
   
   // boots -      ar=1 ar+100        spd+30 move_silent+30     disease_resistance
   equSlot = EQUIPPED_SLOT_BASE + sl_boots;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:boots name:@"Boots of the Divine Messenger" weight:2.0 skillRequired:armorSkill
         occurrence:9 icon:97 value:0 count:0 damage:0 armorRating:1 attr:speed attrBonus:30
         skill:move_silently skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
         arBonus:100 resistance:disease effect:0 script:NULL];
   
   // gauntlets -  ar=1 ar+100        dex+30 unarmed_combat+30  toxin resistance
   equSlot = EQUIPPED_SLOT_BASE + sl_gauntlets;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:gauntlets name:@"Cestus of the Titans" weight:2.0 skillRequired:armorSkill
         occurrence:9 icon:76 value:0 count:0 damage:0 armorRating:1 attr:dexterity attrBonus:30
         skill:unarmed_combat skillBonus:30 hitPoints:100 mana:100 toHitBonus:100 damageBonus:100
         arBonus:100 resistance:toxin effect:0 script:NULL];
   
   // shield -     ar=1 ar+100               shield+30          magick_resistance
   GHItemEditor * itemEditor = [GHItemEditor new];
   if ([itemEditor getDoc] == nil) [itemEditor setDoc:document];
   [itemEditor setSlotNr:slot];
   [itemEditor reload];
   // cannot wear a shield when wielding a bow
   if ([itemEditor getItemProperty:@"Required Skill"] != weapon_bow) {
      equSlot = EQUIPPED_SLOT_BASE + sl_shield;
      slot = [self findFirstEmptySlot];
      if (slot) [self moveItem:equSlot to:slot];
   } else {
      if ((equSlot = [self findFirstEmptySlot]) == 0) return;
   }
   [self addItem:equSlot itemType:shield name:@"Aegis of Light" weight:3.0 skillRequired:armor_shields
      occurrence:9 icon:94 value:0 count:0 damage:0 armorRating:1 attr:concentration attrBonus:30
         skill:armor_shields skillBonus:30 hitPoints:100 mana:100 toHitBonus:0 damageBonus:0
         arBonus:100 resistance:magick effect:0 script:NULL];
}

//***************************** Potions ********************************
- (void)catsEyePotions: (id)sender {
   int slot;
   if ((slot = [self findFirstQuickSlot]) == 0) {
      if ((slot = [self findFirstEmptySlot]) == 0) return;
   }
   switch ([self potionQuality]) {
      case 0:
         [self addItem:slot itemType:potion name:@"Potion of Cat's Eyes" weight:0.3 skillRequired:noSkill
               occurrence:1 icon:179 value:30 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Cat's Eyes) 2 ; to_flask"];
         break;
      case 1:
         [self addItem:slot itemType:potion name:@"Potion of Cat's Eyes II" weight:0.3 skillRequired:noSkill
               occurrence:9 icon:179 value:0 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Cat's Eyes) 8 ; to_flask"];
         break;
      case 2:
         [self addItem:slot itemType:potion name:@"Potion of Cat's Eyes III" weight:0.3 skillRequired:noSkill
               occurrence:9 icon:179 value:0 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Cat's Eyes) 18 ; to_flask"];
         break;
   }
}

- (void)cureDiseasePotions: (id)sender {
   int slot;
   if ((slot = [self findFirstQuickSlot]) == 0) {
      if ((slot = [self findFirstEmptySlot]) == 0) return;
   }
   switch ([self potionQuality]) {
      case 0:
      case 1:
         [self addItem:slot itemType:potion name:@"Potion of Cure Lesser Disease" weight:0.3 skillRequired:noSkill
               occurrence:2 icon:238 value:110 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; cure_disease 3 ; to_flask"];
         break;
      case 2:
         [self addItem:slot itemType:potion name:@"Potion of Cure Greater Disease" weight:0.3 skillRequired:noSkill
               occurrence:3 icon:237 value:400 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; cure_disease 6 ; to_flask"];
         break;
   }
}

- (void)hastePotions: (id)sender {
   int slot;
   if ((slot = [self findFirstQuickSlot]) == 0) {
      if ((slot = [self findFirstEmptySlot]) == 0) return;
   }
   switch ([self potionQuality]) {
      case 0:
         [self addItem:slot itemType:potion name:@"Potion of Haste I" weight:0.3 skillRequired:noSkill
               occurrence:1 icon:135 value:20 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Haste) 2 ; to_flask"];
         break;
      case 1:
         [self addItem:slot itemType:potion name:@"Potion of Haste II" weight:0.3 skillRequired:noSkill
               occurrence:2 icon:145 value:40 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Haste) 4 ; to_flask"];
         break;
      case 2:
         [self addItem:slot itemType:potion name:@"Potion of Haste III" weight:0.3 skillRequired:noSkill
               occurrence:4 icon:155 value:90 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Haste) 6 ; to_flask"];
         break;
   }
}

- (void)healingPotions: (id)sender {
   int slot;
   if ((slot = [self findFirstQuickSlot]) == 0) {
      if ((slot = [self findFirstEmptySlot]) == 0) return;
   }
   switch ([self potionQuality]) {
      case 0:
         [self addItem:slot itemType:potion name:@"Healing Elixir III" weight:0.3 skillRequired:noSkill
               occurrence:1 icon:134 value:15 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"cond_health ; Message(You feel the elixir course through your veins.) ; Heal 15 0 ;Sound(SFX_quaff) ; Sound(SFX_Heal) ; to_flask"];
         break;
      case 1:
         [self addItem:slot itemType:potion name:@"Healing Elixir II" weight:0.3 skillRequired:noSkill
               occurrence:2 icon:144 value:45 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"cond_health ; Message(You feel the elixir course through your veins.) ; Heal 40 0 ;Sound(SFX_quaff) ; Sound(SFX_Heal) ; to_flask"];
         break;
      case 2:
         [self addItem:slot itemType:potion name:@"Healing Elixir III" weight:0.3 skillRequired:noSkill
               occurrence:3 icon:154 value:100 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"cond_health ; Message(You feel the elixir course through your veins.) ; Heal 90 0 ;Sound(SFX_quaff) ; Sound(SFX_Heal) ; to_flask"];
         break;
   }
   
}

- (void)invisibilityPotions: (id)sender {
   int slot;
   if ((slot = [self findFirstQuickSlot]) == 0) {
      if ((slot = [self findFirstEmptySlot]) == 0) return;
   }
   switch ([self potionQuality]) {
      case 0:
         [self addItem:slot itemType:potion name:@"Invisibility I" weight:0.3 skillRequired:noSkill
               occurrence:2 icon:139 value:40 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"sound (SFX_Quaff) ; effect (Invisible) 2 ; to_flask"];
         break;
      case 1:
         [self addItem:slot itemType:potion name:@"Invisibility II" weight:0.3 skillRequired:noSkill
               occurrence:3 icon:149 value:90 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"sound (SFX_Quaff) ; effect (Invisible) 4 ; to_flask"];
         break;
      case 2:
         [self addItem:slot itemType:potion name:@"Invisibility III" weight:0.3 skillRequired:noSkill
               occurrence:4 icon:159 value:200 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"sound (SFX_Quaff) ; effect (Invisible) 6 ; to_flask"];
         break;
   }
}

- (void)leatherSkinPotions: (id)sender {
   int slot;
   if ((slot = [self findFirstQuickSlot]) == 0) {
      if ((slot = [self findFirstEmptySlot]) == 0) return;
   }
   switch ([self potionQuality]) {
      case 0:
         [self addItem:slot itemType:potion name:@"Leatherskin I" weight:0.3 skillRequired:noSkill
               occurrence:1 icon:138 value:20 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"sound (SFX_Quaff) ; effect (Leatherskin) 2 ; to_flask"];
         break;
      case 1:
         [self addItem:slot itemType:potion name:@"Leatherskin II" weight:0.3 skillRequired:noSkill
               occurrence:2 icon:148 value:40 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"sound (SFX_Quaff) ; effect (Leatherskin) 4 ; to_flask"];
         break;
      case 2:
         [self addItem:slot itemType:potion name:@"Leatherskin III" weight:0.3 skillRequired:noSkill
               occurrence:3 icon:158 value:90 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"sound (SFX_Quaff) ; effect (Leatherskin) 6 ; to_flask"];
         break;
   }
}

- (void)manaPotions: (id)sender {
   int slot;
   if ((slot = [self findFirstQuickSlot]) == 0) {
      if ((slot = [self findFirstEmptySlot]) == 0) return;
   }
   switch ([self potionQuality]) {
      case 0:
         [self addItem:slot itemType:potion name:@"Mana Potion I" weight:0.3 skillRequired:noSkill
               occurrence:2 icon:136 value:15 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"cond_mana ; Message(You feel a surge of power as the potion restores your arcane energies.) ; Restore 15 ; Sound(SFX_Quaff) ; Sound(SFX_Restore) ; to_flask"];
         break;
      case 1:
         [self addItem:slot itemType:potion name:@"Mana Potion II" weight:0.3 skillRequired:noSkill
               occurrence:2 icon:146 value:45 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"cond_mana ; Message(You feel a surge of power as the potion restores your arcane energies.) ; Restore 40 ; Sound(SFX_Quaff) ; Sound(SFX_Restore) ; to_flask"];
         break;
      case 2:
         [self addItem:slot itemType:potion name:@"Mana Potion III" weight:0.3 skillRequired:noSkill
               occurrence:4 icon:156 value:100 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 
               script:@"cond_mana ; Message(You feel a surge of power as the potion restores your arcane energies.) ; Restore 90 ; Sound(SFX_Quaff) ; Sound(SFX_Restore) ; to_flask"];
         break;
   }
}

- (void)predatorSightPotions: (id)sender {
   int slot;
   if ((slot = [self findFirstQuickSlot]) == 0) {
      if ((slot = [self findFirstEmptySlot]) == 0) return;
   }
   switch ([self potionQuality]) {
      case 0:
         [self addItem:slot itemType:potion name:@"Potion of Predator Sight" weight:0.3 skillRequired:noSkill
               occurrence:1 icon:38 value:70 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Predator Sight) 3 ; to_flask"];
         break;
      case 1:
         [self addItem:slot itemType:potion name:@"Potion of Predator Sight II" weight:0.3 skillRequired:noSkill
               occurrence:9 icon:38 value:0 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Predator Sight) 8 ; to_flask"];
         break;
      case 2:
         [self addItem:slot itemType:potion name:@"Potion of Predator Sight III" weight:0.3 skillRequired:noSkill
               occurrence:9 icon:38 value:0 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
               skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
               resistance:noResist effect:0 script:@"sound (SFX_Quaff) ; effect (Predator Sight) 18 ; to_flask"];
         break;
   }
}

//***************************** Misc ***********************************
- (void)alchemyBooks: (id)sender {
   int slot;

   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:note name:@"The Alchemist's Cookbook I" weight:2 skillRequired:noSkill
         occurrence:1 icon:193 value:15 count:0 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:@"Sound(SFX_Stats_Open) ; book 4"];

   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:note name:@"The Alchemist's Cookbook II" weight:2 skillRequired:noSkill
         occurrence:2 icon:188 value:50 count:0 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:@"Sound(SFX_Stats_Open) ; book 6"];

   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:note name:@"The Alchemist's Cookbook III" weight:2 skillRequired:noSkill
         occurrence:3 icon:194 value:75 count:0 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:@"Sound(SFX_Stats_Open) ; book 5"];

   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:note name:@"Imbuing Your Equipment" weight:2 skillRequired:noSkill
         occurrence:2 icon:194 value:50 count:0 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:@"Sound(SFX_Stats_Open) ; book 34"];

   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:note name:@"The Art of Brewing" weight:2 skillRequired:noSkill
         occurrence:2 icon:194 value:50 count:0 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:@"Sound(SFX_Stats_Open) ; book 28 ; learn_book 31"];
}

- (void)amulets: (id)sender {
}

- (void)lockpicks: (id)sender {
   int slot;
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   
   [self addItem:slot itemType:lockpick name:@"Lock Pick" weight:0.1 skillRequired:noSkill
         occurrence:1 icon:126 value:15 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:pick_locks skillBonus:2 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0
         arBonus:0 resistance:noResist effect:0 script:NULL];
 }

- (void)reagents: (id)sender {
   int slot;
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reagent name:@"Ambergris" weight:0.3 skillRequired:noSkill
         occurrence:2 icon:160 value:25 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];
   
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reagent name:@"Ash" weight:0.3 skillRequired:noSkill
         occurrence:1 icon:142 value:7 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];
   
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reagent name:@"Belladonna" weight:0.3 skillRequired:noSkill
         occurrence:2 icon:162 value:42 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];
   
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reagent name:@"Ectoplasm" weight:0.3 skillRequired:noSkill
         occurrence:4 icon:170 value:100 count:20 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];
 
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reagent name:@"Jelly Fungus" weight:0.3 skillRequired:noSkill
         occurrence:2 icon:140 value:25 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];

   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reagent name:@"Mandrake Root" weight:0.3 skillRequired:noSkill
         occurrence:1 icon:150 value:30 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];

   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reagent name:@"Willow Sap" weight:0.3 skillRequired:noSkill
         occurrence:1 icon:180 value:10 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];   
}

- (void)reactants: (id)sender {
   int slot;
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reactant name:@"Acid" weight:0.3 skillRequired:noSkill
         occurrence:1 icon:181 value:25 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];   
   
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reactant name:@"Bromine" weight:0.3 skillRequired:noSkill
         occurrence:2 icon:171 value:40 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];   
   
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reactant name:@"Charcoal" weight:0.3 skillRequired:noSkill
         occurrence:1 icon:151 value:35 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];   
   
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reactant name:@"Mercury" weight:0.3 skillRequired:noSkill
         occurrence:2 icon:161 value:35 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];   
      
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reactant name:@"Serpent Venom" weight:0.3 skillRequired:noSkill
         occurrence:2 icon:152 value:45 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];   
   
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reactant name:@"Spider Silk" weight:0.3 skillRequired:noSkill
         occurrence:1 icon:192 value:20 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];   
   
   if ((slot = [self findFirstEmptySlot]) == 0) return;
   [self addItem:slot itemType:reactant name:@"Sulfur" weight:0.3 skillRequired:noSkill
         occurrence:1 icon:141 value:8 count:10 damage:0 armorRating:0 attr:noAttr attrBonus:0
         skill:noSkill skillBonus:0 hitPoints:0 mana:0 toHitBonus:0 damageBonus:0 arBonus:0
         resistance:noResist effect:0 script:nil];   
   
}

- (void)rings: (id)sender {
}

// add 10 torches
- (void) torches: (id)sender {
   int c;
   c = [document spellStat:0 section:1];
   c +=10 ; 
   if (c > 1000) c = 1000;  // limit any nonsense 
   [document setSpellStat:0 to:c section:1];
}

- (void) avatarJewelry: (id)sender {
   int slot, equSlot;
   
   equSlot = EQUIPPED_SLOT_BASE + sl_amulet;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:amulet name:@"Amulet of the Divine Wanderer" weight:0.1 skillRequired:noSkill
         occurrence:9 icon:176 value:0 count:0 damage:0 armorRating:0 attr:concentration attrBonus:30
         skill:cartography skillBonus:30 hitPoints:50 mana:50 toHitBonus:0 damageBonus:0
         arBonus:10 resistance:magick effect:0 script:NULL];

   equSlot = EQUIPPED_SLOT_BASE + sl_ring_r;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:ring name:@"Opener of Ways" weight:0.1 skillRequired:noSkill
         occurrence:9 icon:112 value:0 count:0 damage:0 armorRating:0 attr:dexterity attrBonus:30
         skill:pick_locks skillBonus:30 hitPoints:50 mana:50 toHitBonus:0 damageBonus:0
         arBonus:10 resistance:toxin effect:0 script:NULL];

   equSlot = EQUIPPED_SLOT_BASE + sl_ring_l;
   slot = [self findFirstEmptySlot];
   if (slot) [self moveItem:equSlot to:slot];
   [self addItem:equSlot itemType:ring name:@"Circlet of Loki" weight:0.1 skillRequired:noSkill
         occurrence:9 icon:113 value:0 count:0 damage:0 armorRating:0 attr:perception attrBonus:30
         skill:skull_duggery skillBonus:30 hitPoints:50 mana:50 toHitBonus:0 damageBonus:0
         arBonus:10 resistance:disease effect:0 script:NULL];
}


- (IBAction) show: (id)sender {	
	[window setContentView:inventoryEditorView];
}

@synthesize window;
@synthesize document;
@synthesize inventoryEditorView;
@end
