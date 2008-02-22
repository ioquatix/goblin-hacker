//
//  GHSavedGameDocument+Character.h
//  Goblin Hacker
//
//  Created by Administrator on 21/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHSavedGameDocument.h"

@interface GHSavedGameDocument (Character)

- (NSString*) characterName;
- (void) setCharacterName: (NSString*)s;
- (NSString*) characterClass;
- (void) setCharacterClass: (NSString*)s;
- (NSString*) characterAxiom;
- (void) setCharacterAxiom: (NSString*)s;
- (NSString*) characterOrigin;
- (void) setCharacterOrigin: (NSString*)s;

- (int) gold;
- (void) setGold: (int)amount;

+ (NSArray*) levels;
- (NSString*) levelName;

- (int) currentLevel;
- (void) setCurrentLevel: (int)lvl;

- (int) characterStat: (NSUInteger)idx;
- (void) setCharacterStat: (NSUInteger)idx to: (int)val;

- (int) spellStat: (NSUInteger)idx section: (int)spellSection;
- (void) setSpellStat: (NSUInteger)idx to: (int)val section: (int)spellSection;

- (int) currentMP;
- (void) setCurrentMP: (int)mp;

- (int) totalMP;
- (void) setTotalMP: (int)mp;

- (int) currentHP;
- (void) setCurrentHP: (int)hp;

- (int) totalHP;
- (void) setTotalHP: (int)hp;

- (int) currentXP;
- (void) setCurrentXP: (int)xp;

- (int) attrPoints;
- (void) setAttrPoints: (int)ap;

- (int) skillPoints;
- (void) setSkillPoints: (int)sp;

- (int) strength;
- (int) dexterity;
- (int) endurance;
- (int) speed;
- (int) intelligence;
- (int) wisdom;
- (int) perception;
- (int) concentration;

- (void) setStrength: (int)v;
- (void) setDexterity: (int)v;
- (void) setEndurance: (int)v;
- (void) setSpeed: (int)v;
- (void) setIntelligence: (int)v;
- (void) setWisdom: (int)v;
- (void) setPerception: (int)v;
- (void) setConcentration: (int)v;



@end
