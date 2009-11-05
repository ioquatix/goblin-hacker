//
//  GHInventoryEditor.h
//  Goblin Hacker
//
//  Created by Hermann Gundel on 25/01/08.
//  Copyright 2008 Hermann Gundel. All rights reserved.
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

#import "GHEditorController.h"
#import "GHItem.h"

@interface GHItemEditor : GHEditorController {	
	GHSlotIndex slotIndex;
	GHItem * item;
}

- (IBAction)nextSlot: (id)sender;
- (IBAction)previousSlot: (id)sender;

- (IBAction)revert: (id)sender;
- (IBAction)clear: (id)sender;
- (IBAction)save: (id)sender;

- (NSString*) slotName;

- (GHSlotIndex)slotIndex;
- (void)setSlotIndex: (GHSlotIndex)val;

- (GHSlotIndex) slotIndexBase1;
- (void)setSlotIndexBase1: (GHSlotIndex)val;

- (IBAction)identifyItem: (id)sender;

@property (retain) GHItem * item;

@end
