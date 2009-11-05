//
//  GHSpellsEditor.m
//  Goblin Hacker
//
//

#import "GHSpellsEditor.h"

#import "GHSavedGameDocument+Character.h"

@implementation GHSpellsEditor
	
+ (NSArray*) spells 
{
	static NSArray * spells = nil;
	
	if (spells == nil) {
		NSString * spellsPath = [[NSBundle mainBundle] pathForResource:@"spells" ofType:@"plist"];
		spells = [[NSArray arrayWithContentsOfFile:spellsPath] retain];
	}
	
	return spells;
}

- (void) awakeFromEditor {
	[spellsTable setDataSource: self];
	[spellsTable reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[[self class] spells] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
   NSDictionary *spell = [[[self class] spells] objectAtIndex:row];
   NSMutableString * spellStr = [NSMutableString stringWithCapacity:20];
   
	if ([@"Value" isEqualTo:[tableColumn identifier]]) {
		// offset and section are in the stat table for spells
      int sect = [[spell objectForKey:@"Section"] intValue];
      int offset = [[spell objectForKey:@"Offset"] intValue];
      // NSLog (@"Setting spell table entry %@ to %@", [spell valueForKey:@"Spell"], 
      //                  [NSNumber numberWithInt:[document spellStat:offset section:sect]]);
		return [NSNumber numberWithInt:[document spellStat:offset section:sect]];
	} else {
      if ([@"Divination" isEqualTo:[spell objectForKey:@"Realm"]]) {
         [spellStr setString:@"DI  "];
      } else if ([@"Elemental" isEqualTo:[spell objectForKey:@"Realm"]]) {
         [spellStr setString:@"EL  "];
      } else {
         [spellStr setString:@"    "];
      }
      [spellStr appendString:[spell valueForKey:@"Spell"]];
		return spellStr;
	}
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
   NSDictionary *spell = [[[self class] spells] objectAtIndex:row];
	if ([@"Value" isEqualTo:[tableColumn identifier]]) {
		// offset and section are in the stat table for spells
		int val = [object intValue];
      int sect = [[spell objectForKey:@"Section"] intValue];
      int offset = [[spell objectForKey:@"Offset"] intValue];
		[[[document undoManager] prepareWithInvocationTarget:tableView] reloadData];
		[document setSpellStat:offset to:val section:sect];
	}	
}

-(IBAction)giveDivinitySpells: (id)sender {
   NSInteger i, count = [spellsTable numberOfRows];
   NSDictionary *spell;
   int sect, offset;
   for (i=0; i < count; i++) {
      spell = [[[self class] spells] objectAtIndex:i];
      if ([@"Divination" isEqualTo:[spell objectForKey:@"Realm"]]) {
         sect = [[spell objectForKey:@"Section"] intValue];
         offset = [[spell objectForKey:@"Offset"] intValue];
		 NSUInteger cur = [document spellStat:offset section:sect];
         [document setSpellStat:offset to:cur + 1 section:sect];
      }
   }
   [spellsTable reloadData];
}

-(IBAction)giveElementalSpells: (id)sender {
   NSInteger i, count = [spellsTable numberOfRows];
   NSDictionary *spell;
   int sect, offset;
   for (i=0; i < count; i++) {
      spell = [[[self class] spells] objectAtIndex:i];
      if ([@"Elemental" isEqualTo:[spell objectForKey:@"Realm"]]) {
         sect = [[spell objectForKey:@"Section"] intValue];
         offset = [[spell objectForKey:@"Offset"] intValue];
		 NSUInteger cur = [document spellStat:offset section:sect];
         [document setSpellStat:offset to:cur + 1 section:sect];
      }
   }
   [spellsTable reloadData];
}

@end
