//
//  GHItem+Names.m
//  Goblin Hacker
//
//  Created by Samuel Williams on 21/02/08.
//  Copyright 2008 Samuel Williams, Orion Transfer Ltd. All rights reserved.
//

#import "GHItem+Names.h"

#import "GHSkillsEditor.h"

@implementation GHItem(Names)

- (NSString*)_getSkillName: (NSUInteger) skillIndex nilString: (NSString*) nilString {
	if (skillIndex == 0) {
		return @"";
	}
	
	// Array is base-0
	skillIndex -= 1;
	
	if (skillIndex >= [[GHSkillsEditor skills] count]) {
		return nilString;
	}
	
	NSString * name = [[GHSkillsEditor skills] objectAtIndex:skillIndex];
	
	if (name == nil) {
		return nilString;
	}
	
	return name;
}

- (NSString*)_getPropertyName: (NSString*)propertyString value: (int)propVal nilString: (NSString*)nilString zeroAllowed:(bool)handleZero {	
	if (handleZero && !propVal) return @"";
	
	NSDictionary *itemDict = [[[self class] properties] valueForKey:propertyString];
	
	NSArray * propValues = [itemDict objectForKey:@"Property Values"];
	
	if (propValues == nil) return nilString;
	
	for (NSDictionary *propValDict in propValues) {
		// TODO: Do we need to cache this? Should we reorganise the PLIST file itself?
		if (propVal == [[propValDict objectForKey:@"Value"] intValue])
			return [propValDict objectForKey:@"Name"];
	}
	
	return nilString;
}

- (NSString*)equipmentTypeName {
	int itemType = [self equipmentType];
	return [self _getPropertyName:@"Item Class" value:itemType nilString:@"No such item class" zeroAllowed:NO];
}

- (NSString*)requiredSkillName {
	int skill = [self skillRequired];
	
	return [self _getSkillName:skill nilString:@"No such skill"];
}

- (NSString*)bonusSkillName {
	int skill = [self skillGranted];

	return [self _getSkillName:skill nilString:@"No such skill"];
}

- (NSString*)bonusAttrName {
	int attr = [self attrGranted];
	return [self _getPropertyName:@"Attribute" value:attr nilString:@"No such Attribute" zeroAllowed:YES];
}

- (NSString*)resistanceName {
	int res = [self resistance];
	return [self _getPropertyName:@"Resistance" value:res nilString:@"No such Resistance" zeroAllowed:YES];
}

- (NSString*)occurrenceName {
	int res = [self occurrence];
	return [self _getPropertyName:@"Occurrence" value:res nilString:@"No such Occurrence" zeroAllowed:YES];
}

- (NSString*)knownString {
	// TODO: probably we should check for item classes here ?
	int i = [self identified];
	if (i && i != [self occurrence]) {
		//identifyActive = YES;
		return @"Item is unknown";
	} else {
		//identifyActive = NO;
		return @"";
	}
}

+ (void) initialize {
	[self setKeys:[NSArray arrayWithObject:@"equipmentType"] triggerChangeNotificationsForDependentKey:@"equipmentTypeName"];
	[self setKeys:[NSArray arrayWithObject:@"skillGranted"] triggerChangeNotificationsForDependentKey:@"bonusSkillName"];
	[self setKeys:[NSArray arrayWithObject:@"attrGranted"] triggerChangeNotificationsForDependentKey:@"bonusAttrName"];
	[self setKeys:[NSArray arrayWithObject:@"resistance"] triggerChangeNotificationsForDependentKey:@"resistanceName"];
	[self setKeys:[NSArray arrayWithObject:@"occurrence"] triggerChangeNotificationsForDependentKey:@"occurrenceName"];
	[self setKeys:[NSArray arrayWithObject:@"skillRequired"] triggerChangeNotificationsForDependentKey:@"requiredSkillName"];

}

@end
