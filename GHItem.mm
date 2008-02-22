//
//  GHItem.m
//  Goblin Hacker
//
//  Created by Administrator on 19/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GHItem.h"

#include "Endian.h"
#include "NSData+Values.h"

@implementation GHItem

+ (void) initialize {
	[self setKeys:[NSArray arrayWithObjects:@"known", @"occurrence"] triggerChangeNotificationsForDependentKey:@"identified"];
}

+ (NSArray*) items {
	static NSArray * items = nil;
	
	if (items == nil) {
		NSString * itemsPath = [[NSBundle mainBundle] pathForResource:@"item" ofType:@"plist"];
		items = [[NSArray arrayWithContentsOfFile:itemsPath] retain];
	}
	
	return items;
}

+ (NSString*) slotName: (NSInteger)slot {
	if (slot < SLOT_MIN || slot >= SLOT_MAX) return @"INVALID";

	if (slot >= QUICK_SLOT_START) {
		return [NSString stringWithFormat:@"Quickslot %d", 1 + (slot - QUICK_SLOT_START)];
	}
	
	if (slot >= EQUIPPED_SLOT_START) {
		NSString *name = @"Unknown!";
		
		switch (slot - EQUIPPED_SLOT_START) {
			case SLOT_QUIVER:      name = @"Quiver"; break;
			case SLOT_HELMET:      name = @"Helm"; break;
			case SLOT_CLOAK:       name = @"Cloak"; break;
			case SLOT_AMULET:      name = @"Amulet"; break;
			case SLOT_BODY:        name = @"Torso"; break;
			case SLOT_WEAPON:      name = @"Weapon"; break;
			case SLOT_BELT:        name = @"Belt"; break;
			case SLOT_GAUNTLETS:   name = @"Gauntlet"; break;
			case SLOT_PANTS:       name = @"Legs"; break;
			case SLOT_RING_RIGHT:  name = @"Ring (R)"; break;
			case SLOT_RING_LEFT:   name = @"Ring (L)"; break;
			case SLOT_SHIELD:      name = @"Shield"; break;
			case SLOT_BOOTS:       name = @"Feet"; break;
			case SLOT_WEAPON_ALT:  name = @"Alternate Weapon"; break;
		}
		
		return [NSString stringWithFormat:@"Equipment %@", name];
	}
	
	return [NSString stringWithFormat:@"Inventory %d", 1 + (slot - INVENTORY_SLOT_START)];
}

+ (NSDictionary*) properties {
	static NSDictionary * properties = nil;
	
	if (properties == nil) {
		NSMutableDictionary * p = [NSMutableDictionary new];
		
		NSDictionary *details;
		NSUInteger i, count = [[[self class] items] count];
		
		for (i = 0; i < count; i++) {
			details = [[[self class] items] objectAtIndex:i];
			
			[p setObject:details forKey:[details objectForKey:@"Property"]];
	   }
	   
	   properties = [[NSDictionary alloc] initWithDictionary:p];
	   //NSLog (@"Properties: %@", properties);
	}
	
	return properties;
}

- init {
	if (self = [super init]) {
		line1 = [[NSMutableData alloc] initWithLength: 3 * 4];
		line2 = [[NSMutableData alloc] initWithLength:21 * 4];
	}
	
	return self;
}

- initWithProperties: (NSDictionary*)props {
	if (self = [self init]) {
		[self setProperties:props];
	}
	
	return self;
}

- initFromSlot: (NSUInteger)slot ofDocument: (GHSavedGameDocument*)document {
	if (self = [super init]) {
	   line1 = [[document dataForIndex:FIRST_SLOT_LINE + slot*3] mutableCopy];
	   line2 = [[document dataForIndex:FIRST_SLOT_LINE + slot*3 + 1] mutableCopy];
	}
	
	return self;
}

- (void) setProperties: (NSDictionary*) properties {

}

- (NSDictionary*) getProperties {
	return nil;
}

- (NSArray*) itemData {
	return [NSArray arrayWithObjects:line1, line2, nil];
}

- (NSInteger)getPropertyOffset: (NSString *)propertyString {
	NSDictionary * details = [[[self class] properties] objectForKey:propertyString];
	
	if (details != nil) {
		return [[details objectForKey:@"Offset"] intValue];
	}
	
	return -1;
}

// retrieval code for integers
- (NSInteger)getItemProperty: (NSString *)propertyString {
	NSInteger offset = [self getPropertyOffset:propertyString];
	
	if (offset == -1) {
		NSLog(@"%s: Trying to get offset for unknown property %@", __PRETTY_FUNCTION__, propertyString);
		return 0;
	}
	
	if (offset*4 > ([line2 length] - 4)) {
		NSLog(@"%s: Invalid offset %d:%d for property %@", __PRETTY_FUNCTION__, offset*4, ([line2 length] - 4), propertyString);
		return 0;
	}
	
	if (line1 == nil || line2 == nil) {
		NSLog(@"%s: Data is nil for property %@", __PRETTY_FUNCTION__, propertyString);
		return 0;
	}
	
	return [line2 intValueAtIndex:offset];
}

- (void)setItemProperty: (NSString*)propertyString to: (NSInteger)val {
	NSInteger offset = [self getPropertyOffset:propertyString];
	
	if (offset == -1) {
		NSLog(@"%s: Trying to set offset for unknown property %@", __PRETTY_FUNCTION__, propertyString);
	}
	
	if (offset*4 > ([line2 length] - 4)) {
		NSLog(@"%s: Invalid offset %d:%d for property %@", __PRETTY_FUNCTION__, offset*4, ([line2 length] - 4), propertyString);
		return;
	}
	
	if (line1 == nil || line2 == nil) {
		NSLog(@"%s: Data is nil for property %@", __PRETTY_FUNCTION__, propertyString);
	}
	
	[line2 setIntValue:val atIndex:offset];
}

- (BOOL) validItem {
	if (line1 == nil || line2 == nil) return NO;
	if ([line1 length] == 0 || [line2 length] == 0) return NO;
	
	return YES;
}

- (BOOL) identified {
	int i = [self known];
	if (i && i != [self occurrence]) {
		// Item is unknown
		return NO;
	}
	
	return YES;
}

- (void) setIdentified: (BOOL)to {
	if (to) {
		[self setKnown:1];
		[self setOccurrence:1];
	} else {
		[self setKnown:0];
		[self setOccurrence:4];
	}
}

#pragma mark -
#pragma mark Getters

- (NSString*)name {
	// return [document stringForIndex:FIRST_SLOT + (slot-1)*3];
	int offset = [self getPropertyOffset:@"Item Name"];

	if (offset == -1) {
		NSLog(@"%s: item.plist corrupt", __PRETTY_FUNCTION__);
		return @"";
	}
	
	NSRange range;
	range.location = offset * 4;
	range.length = [line1 length] - range.location;
	
	NSData * str = [line1 subdataWithRange:range];
	return [[[NSString alloc] initWithData:str encoding:NSUTF8StringEncoding] autorelease];
}

- (int)equipmentType {
	int val;
	int offset = [self getPropertyOffset:@"Item Class"];
	if (offset == -1) return 0;
	uint32_t * d = (uint32_t*)[line1 bytes];   
	val = orderRead(d[offset], LITTLE, hostEndian());
	
	//if (!val) identifyActive = NO;
	return val;
}

- (double)weight {
	assert(line2 != nil);
	
	const double * weight = (const double *)[line2 bytes];
	double ret = orderRead(weight[0], LITTLE, hostEndian());
	return ret;
}
- (int)skillRequired {
	return [self getItemProperty:@"Required Skill"];
}

- (int)occurrence {
	return [self getItemProperty:@"Occurrence"];
}

- (int)iconIndex {
	return [self getItemProperty:@"Icon"];
}

- (int)value {
	return [self getItemProperty:@"Item Value"];
}

- (bool)known {
	return [self getItemProperty:@"Item Known"];
}

- (int)stackCount {
	return [self getItemProperty:@"Count"];
}

- (int)baseDamage {
	return [self getItemProperty:@"Damage"];
}

- (int)armorRating {
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

- (int)resistance{
	int resist;
	resist = [self getItemProperty:@"Resistance"];
	// display text field
	return resist;
}

- (int)effect{
	return [self getItemProperty:@"Effect"];
}

- (NSString*)script {
	// return [document stringForIndex:FIRST_SLOT + (slot-1)*3];
	int offset = [self getPropertyOffset:@"Script"];

	if (offset == -1) {
		NSLog(@"%s: item.plist corrupt", __PRETTY_FUNCTION__);
		return @"";
	}
	
	NSRange range;
	range.location = offset * 4;
	range.length = [line2 length] - range.location;
	
	NSData * str = [line2 subdataWithRange:range];
	return [[[NSString alloc] initWithData:str encoding:NSUTF8StringEncoding] autorelease];
}

#pragma mark -
#pragma mark Setters

- (void)setName: (NSString*)val {
	[line1 setLength:[self getPropertyOffset:@"Item Name"]*4];  // our offsets are for integers
	[line1 appendBytes:[val UTF8String] length:[val length]];
	NSLog(@"name: %@, length: %d", val, [val length]);
}

- (void)setEquipmentType: (int)val {
	int offset=[self getPropertyOffset:@"Item Class"];;
	if (offset == -1) return ;
	uint32_t * d = (uint32_t*)[line1 bytes];
	orderCopy((uint32_t)val, d[offset], hostEndian(), LITTLE);
}

- (void)setWeight: (double)val {
	double * weight = (double *)[line2 bytes];
	orderCopy(val, weight[0], hostEndian(), LITTLE);
}

- (void)setSkillRequired:(int)val {
	[self setItemProperty:@"Required Skill" to:val];
}

- (void)setOccurrence: (int)val {
	[self setItemProperty:@"Occurrence" to:val];
}

- (void)setIconIndex: (int)val {
	[self setItemProperty:@"Icon" to:val];
}

- (void)setValue: (int)val {
	[self setItemProperty:@"Item Value" to:val];
}

- (void)setKnown: (bool)val {
	[self setItemProperty:@"Item Known" to:val];
}

- (void)setStackCount: (int)val {
	[self setItemProperty:@"Count" to:val];
}

- (void)setBaseDamage: (int)val {
	[self setItemProperty:@"Damage" to:val];
}

- (void)setArmorRating: (int)val {
	[self setItemProperty:@"Armor Rating" to:val];
}

- (void)setAttrGranted: (int)val {
	[self setItemProperty:@"Attribute" to:val];
}

- (void)setAttrBonus: (int)val {
	[self setItemProperty:@"Attribute Bonus" to:val];
}

- (void)setSkillGranted: (int)val {
	[self setItemProperty:@"Skill" to:val];
}

- (void)setSkillBonus: (int)val {
	[self setItemProperty:@"Skill Bonus" to:val];
}

- (void)setHpBonus: (int)val {
	[self setItemProperty:@"Hitpoint Bonus" to:val];
}

- (void)setManaBonus: (int)val {
	[self setItemProperty:@"Mana Bonus" to:val];
}

- (void)setToHitBonus: (int)val {
	[self setItemProperty:@"ToHit Bonus" to:val];
}

- (void)setDamageBonus: (int)val {
	[self setItemProperty:@"Damage Bonus" to:val];
}

- (void)setArBonus: (int)val {
	[self setItemProperty:@"Armor Rating Bonus" to:val];
}

- (void)setResistance: (int)val {
	[self setItemProperty:@"Resistance" to:val];
}

- (void)setEffect: (int)val {
	[self setItemProperty:@"Effect" to:val];
}

- (void)setScript: (NSString*)val {
	[line2 setLength:[self getPropertyOffset:@"Script"]*4];  // our offsets are for integers
	[line2 appendBytes:[val UTF8String] length:[val length]];
}

@end
