//
//  GHSavedGameDocument+Character.m
//  Goblin Hacker
//
//  Created by Administrator on 21/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GHSavedGameDocument+Character.h"

#import "NSData+Values.h"

@implementation GHSavedGameDocument (Character)

- (NSString*) characterName {
	return [self stringForIndex:0];
}

- (NSString*) characterClass {
	return [self stringForIndex:4];
}

- (NSString*) characterAxiom {
	return [self stringForIndex:3];
}

- (NSString*) characterOrigin {
	return [self stringForIndex:2];
}

- (void) setCharacterName: (NSString*)s {
	[self setString:s forIndex:0];
}

- (void) setCharacterClass: (NSString*)s {
	[self setString:s forIndex:4];
}

- (void) setCharacterAxiom: (NSString*)s {
	[self setString:s forIndex:3];
}

- (void) setCharacterOrigin: (NSString*)s {
	[self setString:s forIndex:2];
}

- (int) characterStat: (NSUInteger)idx {
	return [characterData intValueAtIndex:idx line:5];
}

- (void) setCharacterStat: (NSUInteger)idx to: (int)val {
	[characterData setIntValue:val atIndex:idx ofLine:5];
}

- (int) spellStat : (NSUInteger)idx section: (int)spellSection {
	if (spellSection != 1 && spellSection != 2) {
		NSLog(@"%s: Spell section incorrect: %d", __PRETTY_FUNCTION__, spellSection);
		return 0;
	}
	
	NSUInteger line = spellSection - 1 ? 306 : 17;

	return [characterData intValueAtIndex:idx line:line];
}

- (void) setSpellStat: (NSUInteger)idx to: (int)val section: (int)spellSection {
	if (spellSection != 1 && spellSection != 2) {
		NSLog(@"%s: Spell section incorrect: %d", __PRETTY_FUNCTION__, spellSection);
		return;
	}
	
	NSUInteger line = spellSection - 1 ? 306 : 17;

	[characterData setIntValue:val atIndex:idx ofLine:line];
}

- (int) gold {
	return [self characterStat:39];
}

- (void) setGold: (int)amount {
	[self setCharacterStat:39 to:amount];
}

- (int) currentLevel {
	return [self characterStat:38];
}

- (void) setCurrentLevel: (int)lvl {
	[self setCharacterStat:38 to:lvl];
}

- (int) currentXP {
	return [self characterStat:37];
}

- (void) setCurrentXP: (int)xp {
	[self setCharacterStat:37 to:xp];
}

- (int) attrPoints {
	return [self characterStat:40];
}

- (void) setAttrPoints: (int)ap {
	[self setCharacterStat:40 to:ap];
}

- (int) skillPoints {
	return [self characterStat:41];
}

- (void) setSkillPoints: (int)sp {
	[self setCharacterStat:41 to:sp];
}

- (int) currentMP {
	return [self characterStat:36];
}

- (void) setCurrentMP: (int)mp {
	[self setCharacterStat:36 to:mp];
}

- (int) totalMP {
	return [self characterStat:34];
}

- (void) setTotalMP: (int)mp {
	[self setCharacterStat:34 to:mp];
}

- (int) currentHP {
	return [self characterStat:35];
}

- (void) setCurrentHP: (int)hp {
	[self setCharacterStat:35 to:hp];
}

- (int) totalHP {
	return [self characterStat:33];
}

- (void) setTotalHP: (int)hp {
	[self setCharacterStat:33 to:hp];
}

- (int) strength {
	return [self characterStat:1];
}

- (int) dexterity {
	return [self characterStat:2];
}

- (int) endurance {
	return [self characterStat:3];
}

- (int) speed {
	return [self characterStat:4];
}

- (int) intelligence {
	return [self characterStat:5];
}

- (int) wisdom {
	return [self characterStat:6];
}

- (int) perception {
	return [self characterStat:7];
}

- (int) concentration {
	return [self characterStat:8];
}

- (void) setStrength: (int)v {
	[self setCharacterStat:1 to:v];
}

- (void) setDexterity: (int)v {
	[self setCharacterStat:2 to:v];
}

- (void) setEndurance: (int)v {
	[self setCharacterStat:3 to:v];
}

- (void) setSpeed: (int)v {
	[self setCharacterStat:4 to:v];
}

- (void) setIntelligence: (int)v {
	[self setCharacterStat:5 to:v];
}

- (void) setWisdom: (int)v {
	[self setCharacterStat:6 to:v];
}

- (void) setPerception: (int)v {
	[self setCharacterStat:7 to:v];
}

- (void) setConcentration: (int)v {
	[self setCharacterStat:8 to:v];
}


+ (NSArray*) levels 
{
	static NSArray * levels = nil;
	
	if (levels == nil) {
		NSString * levelsPath = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
		levels = [[NSArray arrayWithContentsOfFile:levelsPath] retain];
	}
	
	return levels;
}

- (NSString*) levelName {
	NSUInteger currentLevel = [self currentLevel];
	NSUInteger maxLevel = [[[self class] levels] count];
	
	if (currentLevel < 1) currentLevel = 1;
	if (currentLevel >= maxLevel) currentLevel = maxLevel - 1;
	
	NSDictionary * level = [[[self class] levels] objectAtIndex:currentLevel];
	
	return [NSString stringWithFormat:@"%@ (%@XP)", [level objectForKey:@"Title"], [level objectForKey:@"Experience"]];
}

+ (void) initialize {
	[self setKeys:[NSArray arrayWithObject:@"currentLevel"] triggerChangeNotificationsForDependentKey:@"levelName"];
}

@end
