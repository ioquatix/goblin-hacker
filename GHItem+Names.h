//
//  GHItem+Names.h
//  Goblin Hacker
//
//  Created by Administrator on 21/02/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GHItem.h"

@interface GHItem(Names)

- (NSString*)equipmentTypeName;
- (NSString*)requiredSkillName;
- (NSString*)bonusSkillName;
- (NSString*)bonusAttrName;
- (NSString*)resistanceName;
- (NSString*)occurrenceName;

@end
