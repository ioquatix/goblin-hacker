//
//  GHSavedGameDocument.h
//  Goblin Hacker
//
//  Created by Samuel Williams on 19/12/07.
//  Copyright Orion Transfer Ltd 2007 . All rights reserved.
//
//  This software was originally produced by Orion Transfer Ltd.
//    Please see http://www.oriontransfer.org for more details.
//

/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/



#import <Cocoa/Cocoa.h>



@interface GHSavedGameDocument : NSDocument
{
	NSArray * characterData;
}

- (IBAction) reloadDocument: (id)sender;

- (NSString*) stringForIndex: (NSUInteger)idx;
- (NSMutableData*) dataForIndex: (NSUInteger)idx;

- (void) setString: (NSString*)string forIndex:(NSUInteger)idx;
- (void) setData: (NSData*)data forIndex:(NSUInteger)idx;

- (NSString*) displayName;

@end
