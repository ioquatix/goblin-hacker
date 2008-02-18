//
//  GHSavedGameDocument.m
//  Goblin Hacker
//
//  Created by Administrator on 19/12/07.
//  Copyright Orion Transfer Ltd 2007 . All rights reserved.
//

#import "GHSavedGameDocument.h"
#include "Endian.h"
#include <arpa/inet.h>

@implementation GHSavedGameDocument

- (IBAction) reloadDocument: (id)sender {
	[self close];
	
	NSError * err = nil;
	NSURL * url = [self fileURL];
	[[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES error:&err];
	
	if (err) {
		[[NSAlert alertWithError:err] runModal];
	}
}

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"GHSavedGameDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}


- (NSString*) displayName {
	return [self characterName];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	NSMutableData * fileData = [NSMutableData new];
	
	NSUInteger i, count = [characterData count];
	for (i = 0; i < count; i++) {
		NSData * line = [characterData objectAtIndex:i];
		if (i == 0) {
			[fileData appendBytes:"\0\0\0\0" length:4];
		} else {
			[fileData appendBytes:"\r\n" length:2];
		}
		
		[fileData appendData:line];
	}
	
	return fileData;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	[self willChangeValueForKey:@"characterData"];
	const unsigned char *b = (const unsigned char *)[data bytes];
	
	if (b[0] != '\0' || b[1] != '\0' || b[2] != '\0' || b[3] != '\0') {
		NSLog (@"File format appears incorrect!");
	}
	
	NSMutableArray * strs = [NSMutableArray new];
	
	unsigned c = 4, s = 4;
	unsigned sz = [data length];
	while (s < sz) {
		// \r\n
		if (s+1 < sz && b[s] == 0x0d && b[s+1] == 0x0a) {
			[strs addObject:[NSMutableData dataWithBytes:b+c length:s - c]];
			s += 2; // We used up two bytes marker
			c = s; // We used up 
			
			continue;
		}
		
		s++;
	}
	
	if (s > c) {
		[strs addObject:[NSMutableData dataWithBytes:b+c length:s - c]];
	}
		
	characterData = [strs retain];
    
	// NSLog (@"Read %d lines", [characterData count]);
	
	//NSUInteger i, count = [characterData count];
	//NSString * header = [NSString stringWithFormat:@"Dumping %d lines", [characterData count]];
	//[dump addObject:header];
	//for (i = 0; i < count; i++) {
	//	NSString * line = [NSString stringWithFormat:@"%d: %@ => %@", i, [self dataForIndex:i], [self stringForIndex:i]];
	//	[dump addObject:line];
	//}
	
	[self didChangeValueForKey:@"characterData"];
    return YES;
}

- (NSString*) stringForIndex: (NSUInteger)idx {
	return [[[NSString alloc] initWithData:[self dataForIndex:idx] encoding:NSUTF8StringEncoding] autorelease];
}

- (NSMutableData*) dataForIndex: (NSUInteger)idx {
	return [characterData objectAtIndex:idx];	
}

- (void) setString: (NSString*)string forIndex:(NSUInteger)idx {
	[self setData:[string dataUsingEncoding:NSASCIIStringEncoding] forIndex:idx];
}

- (void) setData: (NSData*)data forIndex:(NSUInteger)idx {
	NSMutableData * old = [characterData objectAtIndex:idx];
	[self willChangeValueForKey:@"characterData"];
	[old setData:data];
	[self didChangeValueForKey:@"characterData"];
}

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
	if ([self dataForIndex:5] == nil) return 0;
	const uint32_t * stats = (const uint32_t *)[[self dataForIndex:5] bytes];
	return orderRead(stats[idx], LITTLE, hostEndian());
}

- (void) setCharacterStat: (NSUInteger)idx to: (int)val {
	if ([self dataForIndex:5] == nil) return;
	uint32_t * stats = (uint32_t *)[[self dataForIndex:5] mutableBytes];
	
	// Undo Manager
	uint32_t oldVal = orderRead(stats[idx], LITTLE, hostEndian());
	[[[self undoManager] prepareWithInvocationTarget:self] setCharacterStat:idx to:oldVal];
	
	// Actual Setter
	orderCopy((uint32_t)val, stats[idx], hostEndian(), LITTLE);
}

- (int) spellStat : (NSUInteger)idx section: (int)spellSection {
	if (spellSection != 1 && spellSection != 2) return 0;
	int fileIndex = spellSection - 1 ? 306 : 17;
	
	if ([self dataForIndex:fileIndex] == nil)
		return 0;
	
	const uint32_t * stats = (const uint32_t *)[[self dataForIndex:fileIndex] bytes];
	int ret = orderRead(*(stats + idx), LITTLE, hostEndian());
	return ret;
}

- (void) setSpellStat: (NSUInteger)idx to: (int)val section: (int)spellSection {
	if (spellSection != 1 && spellSection != 2) return;
	int fileIndex = spellSection - 1 ? 306 : 17;
	
	if ([self dataForIndex:fileIndex] == nil)
		return;
	
	uint32_t * stats = (uint32_t *)[[self dataForIndex:fileIndex] mutableBytes];

	// Undo Manager
	uint32_t oldVal = orderRead(stats[idx], LITTLE, hostEndian());
	[[[self undoManager] prepareWithInvocationTarget:self] setSpellStat:idx to:oldVal section:spellSection];
	
	// Actual Setter
	orderCopy((uint32_t)val, stats[idx], hostEndian(), LITTLE);
}

- (unsigned char) byteValue: (NSUInteger)byteOffset line: (int)lineOffset {
   if ([self dataForIndex:lineOffset] == nil) return 0;
   unsigned char * item = (unsigned char *)[[self dataForIndex:lineOffset] bytes];
   return orderRead(item[byteOffset], LITTLE, hostEndian());
}

- (void) setByteValue: (NSUInteger)byteOffset line: (int)lineOffset to:(unsigned char)val {
  	if ([self dataForIndex:lineOffset] == nil) return;
   unsigned char * item = (unsigned char *)[[self dataForIndex:lineOffset] mutableBytes];
   // Undo Manager
	unsigned char oldVal = orderRead(item[byteOffset], LITTLE, hostEndian());
	[[[self undoManager] prepareWithInvocationTarget:self] setByteValue:byteOffset line:lineOffset to:oldVal];
   
   // Actual Setter
	orderCopy((unsigned char)val, item[byteOffset], hostEndian(), LITTLE);
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
