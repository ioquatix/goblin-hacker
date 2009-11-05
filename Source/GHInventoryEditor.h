//
//  GHInventoryEditor.h
//  Goblin Hacker
//
//  Created by Samuel Williams on 19/12/07.
//  Copyright 2007 Samuel Williams, Orion Transfer Ltd. All rights reserved.

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
