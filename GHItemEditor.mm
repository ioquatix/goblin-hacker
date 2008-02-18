//
//  GHInventoryEditor.m
//  Goblin Hacker
//
//  Created by Hermann Gundel on 25/02/08.
//  

#import "GHItemEditor.h"
#import "GHInventoryEditor.h"
#import "GHSkillsEditor.h"
#include "Endian.h"

#define FIRST_SLOT         30
#define INVENTORY_MAX      69
// slot 70 is unused
#define EQUIPPED_SLOT_BASE 71
#define EQUIPPED_SLOT_MAX  14
#define QUICK_SLOT_BASE    85
#define QUICK_SLOT_MAX     8

@implementation GHItemEditor

+ (NSArray*) items 
{
	static NSArray * items = nil;
	
	if (items == nil) {
		NSString * itemsPath = [[NSBundle mainBundle] pathForResource:@"item" ofType:@"plist"];
		items = [[NSArray arrayWithContentsOfFile:itemsPath] retain];
	}
	
	return items;
}

+ (id) new {
   return ([[super new] init]);
}

+ (void)initialize {
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"slotType"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemName"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemClass"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemWeight"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"skillRequired"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"occurrence"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"iconNr"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemValue"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemKnown"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemCount"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemDamage"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemArmorRating"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"attrGranted"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"attrBonus"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"skillGranted"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"skillBonus"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"hpBonus"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"manaBonus"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"toHitBonus"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"damageBonus"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"arBonus"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemResistance"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemEffect"];
	[self setKeys:[NSArray arrayWithObject:@"slotNr"] triggerChangeNotificationsForDependentKey:@"itemScript"];
	[self setKeys:[NSArray arrayWithObject:@"itemClass"] triggerChangeNotificationsForDependentKey:@"itemClassName"];
	[self setKeys:[NSArray arrayWithObject:@"skillRequired"]  triggerChangeNotificationsForDependentKey:@"requiredSkillName"];
	[self setKeys:[NSArray arrayWithObject:@"skillGranted"] triggerChangeNotificationsForDependentKey:@"bonusSkillName"];
	[self setKeys:[NSArray arrayWithObject:@"attrGranted"]  triggerChangeNotificationsForDependentKey:@"attributeName"];
	[self setKeys:[NSArray arrayWithObject:@"itemResistance"] triggerChangeNotificationsForDependentKey:@"resistanceName"];
   [self setKeys:[NSArray arrayWithObject:@"occurrence"] triggerChangeNotificationsForDependentKey:@"occurrenceName"];
   [self setKeys:[NSArray arrayWithObject:@"occurrence"] triggerChangeNotificationsForDependentKey:@"knownString"];
   [self setKeys:[NSArray arrayWithObject:@"knownString"] triggerChangeNotificationsForDependentKey:@"identyButtonIsEnabled"];
   [self setKeys:[NSArray arrayWithObject:@"knownString"] triggerChangeNotificationsForDependentKey:@"identifyButtonIsHidden"];
}

- (id)init {
   slot = 1;
   identifyActive = FALSE;
   return self;
}

- (id)valueForUndefinedKey:(NSString*)key {
   NSLog(@"GHItemEditor: Undefined key %@", key);
   return nil;
}

- (id)getDoc {
   return document;
}

- (void)setDoc: (GHSavedGameDocument*)doc {
   document = doc;
   [self reload];
}

- (void)reload {
   line1 = [document dataForIndex:FIRST_SLOT + (slot-1)*3];
   line2 = [document dataForIndex:FIRST_SLOT + (slot-1)*3 + 1];
}

- (void)revert: (id)sender {
   [self reload];
}

- (void)save: (id)sender {
   [self saveItem];
}

- (void)saveItem {
   [document setData:line1 forIndex:FIRST_SLOT + (slot - 1)*3];
   [document setData:line2 forIndex:FIRST_SLOT + (slot - 1)*3 + 1];
}

- (void)setIntValue: (int)intIndex line:(int)lineIndex to: (int)val {
   if ([document dataForIndex:lineIndex] == nil)
		return;
   uint32_t * item = (uint32_t *)[[document dataForIndex:lineIndex] mutableBytes];
   // Undo Manager
	uint32_t oldVal = orderRead(item[intIndex], LITTLE, hostEndian());
	[[[document undoManager] prepareWithInvocationTarget:self] setIntValue:intIndex line:lineIndex to:oldVal];
   
   // Actual Setter
	orderCopy((uint32_t)val, item[intIndex], hostEndian(), LITTLE);
}

- (int)getPropertyOffset: (NSString *)propertyString {
   int offset;
   NSDictionary* itemStruct;
    NSInteger i, count = [[[self class] items] count];
   for (i=0; i < count; i++) {
      itemStruct = [[[self class] items] objectAtIndex:i];
      if ([propertyString isEqualTo:[itemStruct objectForKey:@"Property"]]) {
         offset = [[itemStruct valueForKey:@"Offset"] intValue];
         break;
      }
   }
   if (i == count) return -1;
   return offset;
}

// retrieval code for integers
- (int)getItemProperty: (NSString *)propertyString {
   int itemProperty, offset;
   offset = [self getPropertyOffset:propertyString];
   if (offset == -1) return 0;
   if (line1 == nil) [self reload];
   uint32_t * d = (uint32_t*)[line2 bytes];
   itemProperty = orderRead(d[offset], LITTLE, hostEndian());
   return itemProperty;
}

- (void)setItemProperty: (NSString*)propertyString to: (int)val {
   int offset = [self getPropertyOffset:propertyString];
   if (offset == -1) return;
   if (line1 == nil) [self reload];
   uint32_t *item = (uint32*)[line2 bytes];
   orderCopy((uint32_t)val, item[offset], hostEndian(), LITTLE);
}

- (int)currentSlot {
   return slot;
}

- (NSString*)slotType {
   if (slot >= QUICK_SLOT_BASE) {
      return [NSString stringWithFormat:@"Quickslot %d", slot - QUICK_SLOT_BASE + 1];
   }
   if (slot > INVENTORY_MAX) {
      NSString *equSlotName = @"";
      switch (slot - EQUIPPED_SLOT_BASE) {
         case sl_arrow:       equSlotName = @"Quiver"; break;
         case sl_helmet:      equSlotName = @"Helm"; break;
         case sl_cloak:       equSlotName = @"Cloak"; break;
         case sl_amulet:      equSlotName = @"Amulet"; break;
         case sl_body:        equSlotName = @"Torso"; break;
         case sl_weapon:      equSlotName = @"Weapon"; break;
         case sl_belt:        equSlotName = @"Belt"; break;
         case sl_gauntlets:   equSlotName = @"Gauntlet"; break;
         case sl_pants:       equSlotName = @"Legs"; break;
         case sl_ring_r:      equSlotName = @"Ring (R)"; break;
         case sl_ring_l:      equSlotName = @"Ring (L)"; break;
         case sl_shield:      equSlotName = @"Shield"; break;
         case sl_boots:       equSlotName = @"Feet"; break;
         case sl_alt_weapon:  equSlotName = @"Alternate Weapon"; break;
      }
      return [NSString stringWithFormat:@"Equipment %@", equSlotName];
   }
   return @"Inventory";
}

- (int)slotNr {
   if (!slot) {
      slot++;
      [self setSlotNr:1];
   }
   if (slot == INVENTORY_MAX + 1) slot++;
   return slot;
}

- (NSString*)itemName {
   // return [document stringForIndex:FIRST_SLOT + (slot-1)*3];
   int offset=[self getPropertyOffset:@"Item Name"];
   if (offset == -1) {
      NSLog(@"item.plist corrupt");
      return @"";
   }
   unsigned int l = [line1 length];
   char * dat = (char*)[line1 bytes];
   dat +=offset*4;
   dat[l - offset*4] = '\0';
   NSString *itemName = [[[NSString alloc] initWithCString:(char*)dat encoding:NSASCIIStringEncoding] autorelease];
   return itemName;

}

- (int)itemClass {
   int val;
   int offset = [self getPropertyOffset:@"Item Class"];
   if (offset == -1) return 0;
   uint32_t * d = (uint32_t*)[line1 bytes];   
   val = orderRead(d[offset], LITTLE, hostEndian());
   if (!val) identifyActive = FALSE;
   return val;
}

- (double)itemWeight {
   if (line2 == nil) [self reload];
   const double * weight = (const double *)[line2 bytes];
   double ret = orderRead(weight[0], LITTLE, hostEndian());
   return ret;
}
 - (int)skillRequired {
    int itemProperty;
    itemProperty = [self getItemProperty:@"Required Skill"];
    return itemProperty;
}

- (int)occurrence {
   return [self getItemProperty:@"Occurrence"];
}

- (int)iconNr {
   return [self getItemProperty:@"Icon"];
}

- (int)itemValue {
   return [self getItemProperty:@"Item Value"];
}

- (bool)itemKnown {
   int known, occ;
   known = [self getItemProperty:@"Item Known"];
   occ = [self getItemProperty:@"Occurrence"];
   if (known && (occ != known))  {
      identifyActive = TRUE;
      return FALSE;
   }
   identifyActive = FALSE;
   return TRUE;
}

- (int)itemCount {
   return [self getItemProperty:@"Count"];
}

- (int)itemDamage {
   return [self getItemProperty:@"Damage"];
}

- (int)itemArmorRating {
   return [self getItemProperty:@"Armor Rating"];
}

- (int)attrGranted {
   return [self getItemProperty:@"Attribute"];
}

- (int)attrBonus {
   return [self getItemProperty:@"Attribute Bonus"];
}

- (int)skillGranted {
   return [self getItemProperty:@"Skill"];
}

- (int)skillBonus {
   return [self getItemProperty:@"Skill Bonus"];
}

- (int)hpBonus{
   return [self getItemProperty:@"Hitpoint Bonus"];
}

- (int)manaBonus{
   return [self getItemProperty:@"Mana Bonus"];
}

- (int)toHitBonus{
   return [self getItemProperty:@"ToHit Bonus"];
}

- (int)damageBonus{
   return [self getItemProperty:@"Damage Bonus"];
}

- (int)arBonus{
   return [self getItemProperty:@"Armor Rating Bonus"];
}

- (int)itemResistance{
   int resist;
   resist = [self getItemProperty:@"Resistance"];
   // display text field
   return resist;
}

- (int)itemEffect{
   return [self getItemProperty:@"Effect"];
}

- (NSString*)itemScript{
   int offset = [self getPropertyOffset:@"Script"];
   if (offset == -1) return @"";
   unsigned int l = [line2 length];
   char * dat = (char *)[line2 bytes];
   dat +=offset*4; 
   dat[l - offset*4] = '\0';
   return [[[NSString alloc] initWithCString:dat encoding:NSASCIIStringEncoding] autorelease];
}

//----------------------------- helper methods to display names -----------------------
- (NSString*)getPropertyName: (NSString*)propertyString value: (int)propVal onerror: (NSString*)errString
             zeroAllowed:(bool)handleZero useSkillTable:(bool)uST {
   int offset;
   NSDictionary * itemStruct, *propValDict;
   NSArray *propValues;
   NSInteger i, count = [[[self class] items] count];
   // if zero handling is wanted, we return an empty string
   if (handleZero && !propVal) return @"";
   if (uST) {
      // get string from skill table
      NSArray* skillnames = [GHSkillsEditor skills];
      count = [skillnames count];
      if (count < propVal || propVal < 0) return errString;
      return [skillnames objectAtIndex:propVal - 1];
   } else {
      for (i=0; i < count; i++) {
         itemStruct = [[[self class] items] objectAtIndex:i];
         if ([propertyString isEqualTo:[itemStruct objectForKey:@"Property"]]) {
            offset = [[itemStruct valueForKey:@"Offset"] intValue];
            break;
         }
      }
      if (i == count) return errString;
      propValues = [itemStruct objectForKey:@"Property Values"];
      if (propValues == nil) return errString;
      count = [propValues count];
      for (i=0; i<count; i++) {
         propValDict = [propValues objectAtIndex:i];
         if (propVal == [[propValDict objectForKey:@"Value"] intValue])
            return [propValDict objectForKey:@"Name"];
      }
      return errString;
   }
}

- (NSString*)itemClassName {
   int itemType = [self itemClass];
   return [self getPropertyName:@"Item Class" value:itemType onerror:@"No such Item Class"
                    zeroAllowed:FALSE useSkillTable:FALSE];
}

- (NSString*)requiredSkillName {
   int skill = [self skillRequired];
   return [self getPropertyName:@"Required Skill" value:skill onerror:@"No such Skill" 
                    zeroAllowed:TRUE useSkillTable:TRUE];
}

- (NSString*)bonusSkillName {
   int skill = [self skillGranted];
   return [self getPropertyName:@"Skill" value:skill onerror:@"No such Skill"
                    zeroAllowed:TRUE useSkillTable:TRUE];
}

- (NSString*)attributeName {
   int attr = [self attrGranted];
   return [self getPropertyName:@"Attribute" value:attr onerror:@"No such Attribute"
                    zeroAllowed:TRUE useSkillTable:FALSE];
}

- (NSString*)resistanceName {
   int res = [self itemResistance];
   return [self getPropertyName:@"Resistance" value:res onerror:@"No such Resistance"
                    zeroAllowed:TRUE useSkillTable:FALSE];
}

- (NSString*)occurrenceName {
   int res = [self occurrence];
   return [self getPropertyName:@"Occurrence" value:res onerror:@"No such Occurrence"
                    zeroAllowed:TRUE useSkillTable:FALSE];
}

- (NSString*)knownString {
   if (![self itemClass] || !slot) {
      return @"";
   }
   // TODO: probably we should check for item classes here ?
   int i = [self itemKnown];
   if (i && i != [self occurrence]) {
      identifyActive = TRUE;
      return @"Item is unknown";
   } else {
      identifyActive = FALSE;
      return @"";
   }
}

//------------------------------ writer methods -------------------------------------

- (void)setSlotNr:       (int)val {
   if (val <= 0 || val >= QUICK_SLOT_BASE + QUICK_SLOT_MAX) {
      slot = 1;
   } else {
     if (val == INVENTORY_MAX + 1) 
        slot = EQUIPPED_SLOT_BASE;
     else 
        slot = val;
   }
   [self reload];
}

- (void)setSlotType:     (NSString*)val {
}

- (void)setItemName:     (NSString*)val {
   [line1 setLength:[self getPropertyOffset:@"Item Name"]*4];  // our offsets are for integers
   [line1 appendBytes:[val UTF8String] length:[val length]];
   NSLog(@"name: %@, length: %d", val, [val length]);
}

- (void)setItemClass:    (int)val {
   int offset=[self getPropertyOffset:@"Item Class"];;
   if (offset == -1) return ;
   uint32_t * d = (uint32_t*)[line1 bytes];
   orderCopy((uint32_t)val, d[offset], hostEndian(), LITTLE);
}

- (void)setItemWeight:   (double)val {
   double * weight = (double *)[line2 bytes];
   orderCopy(val, weight[0], hostEndian(), LITTLE);
}

- (void)setSkillRequired:(int)val {
   [self setItemProperty:@"Required Skill" to:val];
}

- (void)setOccurrence:   (int)val {
   [self setItemProperty:@"Occurrence" to:val];
}

- (void)setIconNr:       (int)val {
   [self setItemProperty:@"Icon" to:val];
}

- (void)setItemValue:    (int)val {
   [self setItemProperty:@"Item Value" to:val];
}

- (void)setItemKnown:      (bool)val {
   if (val == FALSE) return;
   [self setOccurrence:1];
   [self setItemProperty:@"Item Known" to:1];
}

- (void)setItemCount:    (int)val {
   [self setItemProperty:@"Count" to:val];
}

- (void)setItemDamage:   (int)val {
   [self setItemProperty:@"Damage" to:val];
}

- (void)setItemArmorRating: (int)val {
   [self setItemProperty:@"Armor Rating" to:val];
}

- (void)setAttrGranted:  (int)val {
   [self setItemProperty:@"Attribute" to:val];
}

- (void)setAttrBonus:    (int)val {
   [self setItemProperty:@"Attribute Bonus" to:val];
}

- (void)setSkillGranted: (int)val {
   [self setItemProperty:@"Skill" to:val];
}

- (void)setSkillBonus:   (int)val {
   [self setItemProperty:@"Skill Bonus" to:val];
}

- (void)setHpBonus:      (int)val {
   [self setItemProperty:@"Hitpoint Bonus" to:val];
}

- (void)setManaBonus:    (int)val {
   [self setItemProperty:@"Mana Bonus" to:val];
}

- (void)setToHitBonus:   (int)val {
   [self setItemProperty:@"ToHit Bonus" to:val];
}

- (void)setDamageBonus:  (int)val {
   [self setItemProperty:@"Damage Bonus" to:val];
}

- (void)setArBonus:      (int)val {
   [self setItemProperty:@"Armor Rating Bonus" to:val];
}

- (void)setItemResistance: (int)val {
   [self setItemProperty:@"Resistance" to:val];
}

- (void)setItemEffect:   (int)val {
   [self setItemProperty:@"Effect" to:val];
}

- (void)setItemScript:   (NSString*)val {
   [line2 setLength:[self getPropertyOffset:@"Script"]*4];  // our offsets are for integers
   [line2 appendBytes:[val UTF8String] length:[val length]];
}

//-------------------------------------------------------------------------

- (bool)identifyButtonIsEnabled {
   return identifyActive;
}

- (bool)identifyButtonIsHidden {
   if (identifyActive) return FALSE;
   return TRUE;
}

- (void)identifyItem: (id)sender {
   if ([self identifyButtonIsEnabled] && ![self identifyButtonIsHidden]) {
      [self setItemKnown:TRUE];
      identifyActive =  FALSE;
      [self saveItem];
      [sender setHidden:TRUE];
      [self knownString];
      [self reload];
   }
   return;
}

- (void)nextSlot: (id)sender {
   slot++;
   if (slot == INVENTORY_MAX + 1) slot++;
   // wrap around
   if (slot > INVENTORY_MAX + EQUIPPED_SLOT_MAX + QUICK_SLOT_MAX)
      slot = 1;
   [self reload];
   [self setSlotNr:slot];
}

- (void)previousSlot: (id)sender {
   slot--;
   // skip unused slot 70
   if (slot == INVENTORY_MAX + 1) slot = INVENTORY_MAX;
   // wrap around
   if (slot == 0) slot = QUICK_SLOT_BASE + QUICK_SLOT_MAX - 1;
   [self reload];
   [self setSlotNr:slot];
}

- (void) getItem {
   // each slot consists of 2 lines plus 1 line seperator
   int raw;
   [line1+2 getBytes:&raw length:sizeof(int)];
   if ( orderRead(raw, LITTLE, hostEndian()) == 0) {
      NSLog(@"slot %d empty", slot);
   } else {
   }

}


- (void)setItem {
}

- (int) findFirstQuickSlot {
   int line;
   for (line = QUICK_SLOT_BASE; line < QUICK_SLOT_BASE + QUICK_SLOT_MAX * 3; line += 3) {
      const uint32_t * quick = (const uint32_t *)[[document dataForIndex:line] bytes];
      if ( orderRead(*(quick + 2), LITTLE, hostEndian()) == 0) break;
   }
   
   if (line >= QUICK_SLOT_BASE + QUICK_SLOT_MAX * 3) {
      return 0;
   }
   return line;
}



// weight, skill, occurrence, icon, value, ?, dam, count, hp+, ar, attr, attr+, skill, skill+, mana+, hit+, dam+, ar+, res
#if 0
- (void)addItem:(int)where itemType:(int)myItemType name:(NSString)itemName
        weight:(float)itemWeight skillRequired:(int)skillNeeded occurrence:(int)occ
        icon:(int)iconNr value:(int)itemValue count:(int)itemCount damage:(int)itemDamage
        armorRating:(int)itemAR attr:itemAttr attrBonus:itemAttrBonus skill:(int)itemSkill
        skillBonus:(int)itemSkillBonus hitPoints:(int)itemHP mana:(int)itemMana
        toHitBonus:(int)itemToHitBonus damageBonus:(int)itemDamBonus arBonus:(int)itemARBonus
        resistance:(int)itemResistance effect:(int)itemEffect script:(NSString)itemScript
{
}
#endif

- (IBAction) show: (id)sender {	
	[window setContentView:itemEditorView];
}

@synthesize window;
@synthesize document;
@synthesize itemEditorView;
@end
