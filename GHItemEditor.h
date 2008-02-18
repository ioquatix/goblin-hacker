//
//  GHInventoryEditor.h
//  Goblin Hacker
//
//  Created by Hermann Gundel on 25/01/08.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

@interface GHItemEditor : NSObject {
	IBOutlet GHSavedGameDocument * document;
	IBOutlet NSWindow * window;
	IBOutlet NSView * itemEditorView;

   NSMutableData * line1;
   NSMutableData * line2;
   bool identifyActive;
   int slot;
}

+ (id)new;
- (id)init;

- (id)getDoc;
- (void)setDoc: (GHSavedGameDocument *)doc;
- (void)reload;
- (IBAction)revert: (id)sender;
- (IBAction)save: (id)sender;
- (void)saveItem;

- (void)setIntValue: (int)intIndex line:(int)lineIndex to: (int)val;
- (int)getItemProperty: (NSString *)propertyString;
- (void)setItemProperty: (NSString*)propertyString to: (int)val;
- (NSString*)getPropertyName: (NSString*)propertyString value: (int)propVal 
                     onerror: (NSString*)errString zeroAllowed:(bool)handleZero useSkillTable:(bool)uST;

- (int)slotNr;
- (NSString*)slotType;
- (NSString*)itemName;
- (int)itemClass;
- (double)itemWeight;
- (int)skillRequired;
- (int)occurrence;
- (int)iconNr;
- (int)itemValue;
- (bool)itemKnown;
- (int)itemCount;
- (int)itemDamage;
- (int)itemArmorRating;
- (int)attrGranted;
- (int)attrBonus;
- (int)skillGranted;
- (int)skillBonus;
- (int)hpBonus;
- (int)manaBonus;
- (int)toHitBonus;
- (int)damageBonus;
- (int)arBonus;
- (int)itemResistance;
- (int)itemEffect;
- (NSString*)itemScript;

- (NSString*)itemClassName;
- (NSString*)requiredSkillName;
- (NSString*)bonusSkillName;
- (NSString*)attributeName;
- (NSString*)resistanceName;
- (NSString*)occurrenceName;

- (void)setSlotNr:       (int)val;
- (void)setSlotType:     (NSString*)val;
- (void)setItemName:     (NSString*)val;
- (void)setItemClass:    (int)val;
- (void)setItemWeight:   (double)val;
- (void)setSkillRequired:(int)val;
- (void)setOccurrence:   (int)val;
- (void)setIconNr:       (int)val;
- (void)setItemValue:    (int)val;
- (void)setItemKnown:    (bool)val;
- (void)setItemCount:    (int)val;
- (void)setItemDamage:   (int)val;
- (void)setItemArmorRating: (int)val;
- (void)setAttrGranted:  (int)val;
- (void)setAttrBonus:    (int)val;
- (void)setSkillGranted: (int)val;
- (void)setSkillBonus:   (int)val;
- (void)setHpBonus:      (int)val;
- (void)setManaBonus:    (int)val;
- (void)setToHitBonus:   (int)val;
- (void)setDamageBonus:  (int)val;
- (void)setArBonus:      (int)val;
- (void)setItemResistance: (int)val;
- (void)setItemEffect:   (int)val;
- (void)setItemScript:   (NSString*)val;


- (bool)identifyButtonIsEnabled;
- (bool)identifyButtonIsHidden;

- (IBAction)identifyItem: (id)sender;

- (IBAction)nextSlot: (id)sender;
- (IBAction)previousSlot: (id)sender;
- (void)getItem;
- (void)setItem;


- (IBAction) show: (id)sender;
+ (NSArray*) items;

@property (retain) NSView * itemEditorView;
@property (retain) NSWindow * window;
@property (retain) GHSavedGameDocument * document;
@end
