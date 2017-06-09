//
//  Handbook.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/28/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//
#import<Foundation/Foundation.h>

#ifndef Handbook_h
#define Handbook_h

@interface handbook:NSObject

+ (NSDictionary *) initializeHandbook;

+ (NSDictionary*)generateSources;

+(NSArray*)sortedKeysForObject:(NSString*)object;

@end

//Code to help implement menus

@interface sourceData:NSObject <NSCopying>

@property NSInteger place;

@property (weak, nonatomic) NSString* text;

-(sourceData*)sourceDataWith:(NSString*)content ordering:(NSInteger)spot;

-(id)sectionForString:(NSString*)keyText;

+(sourceData*)sourceDataForString:(NSString*)string;

@end

@interface findTitles : NSObject

+(NSArray*)findBold:(NSAttributedString*)source fontSize:(CGFloat)font;

+(NSString*)findSegue:(NSString*)title;

@end

#endif /* Handbook_h */
