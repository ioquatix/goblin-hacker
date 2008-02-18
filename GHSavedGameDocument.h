//
//  GHSavedGameDocument.h
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright Orion Transfer Ltd 2007 . All rights reserved.
//


#import <Cocoa/Cocoa.h>



@interface GHSavedGameDocument : NSDocument
{
	NSArray * characterData;

    IBOutlet id characterEditorView;
    IBOutlet id inventoryEditorView;
    IBOutlet id itemEditorView;
    IBOutlet id skillsEditorView;	
    IBOutlet id spellsEditorView;	
    IBOutlet id statesEditorView;	
}

- (IBAction) reloadDocument: (id)sender;

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

- (int) currentLevel;
- (void) setCurrentLevel: (int)lvl;

- (int) characterStat: (NSUInteger)idx;
- (void) setCharacterStat: (NSUInteger)idx to: (int)val;
- (int) spellStat: (NSUInteger)idx section: (int)spellSection;
- (void) setSpellStat: (NSUInteger)idx to: (int)val section: (int)spellSection;
- (unsigned char) byteValue: (NSUInteger)byteOffset line: (int)lineOffset;
- (void) setByteValue: (NSUInteger)byteOffset line: (int)lineOffset to:(unsigned char)val;

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

- (NSString*) stringForIndex: (NSUInteger)idx;
- (NSMutableData*) dataForIndex: (NSUInteger)idx;

- (void) setString: (NSString*)string forIndex:(NSUInteger)idx;
- (void) setData: (NSData*)data forIndex:(NSUInteger)idx;

+ (NSArray*) levels;
- (NSString*) levelName;
@end
