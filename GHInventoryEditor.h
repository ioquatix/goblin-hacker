//
//  GHInventoryEditor.h
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright 2007 Orion Transfer Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHEditorController.h"
#import "GHSavedGameDocument+Slots.h"

@interface GHInventoryEditor : GHEditorController {
	NSInteger armorType, weaponType, potionQuality;
}

+ (NSArray*) items;

@property NSInteger armorType;
@property NSInteger weaponType;
@property NSInteger potionQuality;

- (IBAction)healingPotions: (id)sender;
- (IBAction)manaPotions: (id)sender;
- (IBAction)cureDiseasePotions: (id)sender;
- (IBAction)catsEyePotions: (id)sender;
- (IBAction)predatorSightPotions:(id)sender;
- (IBAction)leatherSkinPotions: (id)sender;
- (IBAction)hastePotions: (id)sender;
- (IBAction)invisibilityPotions: (id)sender;

- (IBAction)basicWeapon: (id)sender;
- (IBAction)goodWeapon: (id)sender;
- (IBAction)superbWeapon: (id)sender;
- (IBAction)avatarWeapon: (id)sender;

- (IBAction)basicArmor: (id)sender;
- (IBAction)goodArmor: (id)sender;
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

@end
