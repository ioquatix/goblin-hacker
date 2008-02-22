//
//  GHStatesEditor.m
//  Goblin Hacker
//
//

#import "GHStatesEditor.h"

#import "GHSavedGameDocument+Character.h"

@implementation GHStatesEditor

+ (NSArray*) states 
{
	static NSArray * states = nil;
	
	if (states == nil) {
		NSString * statesPath = [[NSBundle mainBundle] pathForResource:@"states" ofType:@"plist"];
		states = [[NSArray arrayWithContentsOfFile:statesPath] retain];
	}
	
	return states;
}

- (void) awakeFromNib {
	// NSLog (@"Setting up states table... %@", [[self class] states]);
	[statesTable setDataSource: self];
	[statesTable reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[[self class] states] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	NSDictionary *state = [[[self class] states] objectAtIndex:row];
	if ([@"Value" isEqualTo:[tableColumn identifier]]) {
		// offset is in the stat table for states
		int offset = [[state valueForKey:@"Offset"] intValue];
		// NSLog (@"Delivering value %@ for state %@", [NSNumber numberWithInt:[document characterStat:offset]],
		//                                             [state objectForKey:@"State"]);
		return [NSNumber numberWithInt:[document characterStat:offset]];
	} else {
		// TODO: - use redColor for bad states (not sure if this is possible)
		return [state objectForKey:@"State"];
	}
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn 
			  row:(NSInteger)row {
	if ([@"Value" isEqualTo:[tableColumn identifier]]) {
		// offset read from stat table
		NSDictionary *state = [[[self class] states] objectAtIndex:row];
		int val = [object intValue];
		int offset = [[state valueForKey:@"Offset"] intValue];
		// see if we have to set special "lighting flag"
		if (([@"Cat's Eyes" isEqualTo:[state objectForKey:@"State"]]) && val) {
			if ([document characterStat:54]) {  // regard state of gravedigger's flame
				[[document dataForIndex:27] setByteValue:12 atIndex:16];
				//[document setByteValue:16 line:27 to:12];
				
			} else {
				//[document setByteValue:16 line:27 to:8];
				[[document dataForIndex:27] setByteValue:8 atIndex:16];
			}
		}
		if (([@"Gravedigger's Flame" isEqualTo:[state objectForKey:@"State"]]) && val) {
			if ([document characterStat:52]) {  // regard state of cat's eyes
				//[document setByteValue:16 line:27 to:12];
				[[document dataForIndex:27] setByteValue:12 atIndex:16];
			} else {
				//[document setByteValue:16 line:27 to:4];
				[[document dataForIndex:27] setByteValue:4 atIndex:16];
			}
		}
		[[[document undoManager] prepareWithInvocationTarget:tableView] reloadData];
		[document setCharacterStat:offset to:val];
	}	
}

- (void)bless: (id)sender {
	int c;
	// just a quick hack, setting wanted states
	// TODO: the states, that influence lighting, have to set some more info, probably line 27
	// cat's eyes is a value of 8 on byte offset 16
	// gravedigger is 4 > both on -> 12
	// there are 5 interesting bytes starting byte offset 16 the next 4 bytes seem like float 0.62
	// for cat's eyes and like float 0.92 for gravedigger's flame
	c = [document characterStat:44];           // Air Shielded
	[document setCharacterStat:44 to:1000+c];
	c = [document characterStat:48];           // Enchanted Weapon
	[document setCharacterStat:48 to:1000+c];
	c = [document characterStat:52];           // Cat's Eyes
	[document setCharacterStat:52 to:1000+c];
	
	//[document setByteValue:16 line:27 to:8];
	[[document dataForIndex:27] setByteValue:8 atIndex:16];
	
	// do not switch on gravedigger, defies hide in shadows 
	// c = [document characterStat:54];           // Gravedigger's Flame
	// [document setCharacterStat:54 to:1000+c]; 
	c = [document characterStat:56];           // Blessed
	[document setCharacterStat:56 to:1000+c];
	c = [document characterStat:58];          // Haste
	[document setCharacterStat:58 to:1000+c];
	c = [document characterStat:60];          // Ogre Strength
	[document setCharacterStat:60 to:1000+c];
	c = [document characterStat:62];          // Invisible
	[document setCharacterStat:62 to:1000+c];
	c = [document characterStat:64];          // Leatherskin
	[document setCharacterStat:64 to:1000+c];
	c = [document characterStat:66];          // Nimbleness
	[document setCharacterStat:66 to:1000+c];
	c = [document characterStat:70];          // Reveal Map
	[document setCharacterStat:70 to:1000+c];
	c = [document characterStat:72];          // Stoneskin
	[document setCharacterStat:72 to:1000+c];
	c = [document characterStat:74];          // Keensight
	[document setCharacterStat:74 to:1000+c];
	c = [document characterStat:80];          // Enkindled Weapon
	[document setCharacterStat:80 to:1000+c];
	c = [document characterStat:82];          // Elemental Armor
	[document setCharacterStat:82 to:1000+c];
	c = [document characterStat:84];          // Chameleon
	[document setCharacterStat:84 to:1000+c];
	c = [document characterStat:86];          // Predator Sight
	[document setCharacterStat:86 to:1000+c];
	c = [document characterStat:90];          // Mana-Fortified
	[document setCharacterStat:90 to:1000+c];
	c = [document characterStat:92];          // Greater Protection
	[document setCharacterStat:92 to:1000+c];
	[statesTable reloadData];
}

- (void)uncurse: (id)sender {
	// Curse and disease are in a 1-byte value lineOffset 27, byteOffset 41
	// values: curse:128, fleshrot:64, insanity fever:32, blister pox:16,
	//         eye fungus:8, rusty knuckles:4, dungeon fever:2
	[self setCursed:0];
	//[self cursedState]; 
	
	// just a quick hack, resetting unwanted states
	[document setCharacterStat:42 to:0];   // Stunned
	[document setCharacterStat:46 to:0];   // Poisoned
	[document setCharacterStat:50 to:0];   // Entangled
	[document setCharacterStat:68 to:0];   // Charmed
	[document setCharacterStat:76 to:0];   // Paralyzed
	[document setCharacterStat:78 to:0];   // Scared
	[document setCharacterStat:88 to:0];   // Off-Balance
	
	[statesTable reloadData];
}

- (unsigned char) cursed {
	return [[document dataForIndex:27] byteValueAtIndex:41];
}

- (void) setCursed: (unsigned char)val {
	[[document dataForIndex:27] setByteValue:val atIndex:41];
}

- (NSString*) cursedState {
	unsigned char cursed = [self cursed];
	if (cursed == 0)   return @"";
	if (cursed == 128) return @"Cursed";
	if (cursed < 128)  return @"Diseased";
	else               return @"Cursed+Diseased";
}

+ (void)initialize {
	[self setKeys:[NSArray arrayWithObject:@"cursed"] triggerChangeNotificationsForDependentKey:@"cursedState"];
}

@end
