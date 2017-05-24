//
//  FoundationsExtensions.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/30/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UiKit.h>

#ifndef FoundationsExtensions_h
#define FoundationsExtensions_h


@interface NSString (Relations)

-(NSString*)takeSpaces;

@end

@interface NSAttributedString (Relations)

-(NSAttributedString*)makeBold:(CGFloat)fontSize;

-(NSAttributedString*)makeItalic:(CGFloat)fontSize;

-(NSAttributedString*)makeFontSize:(CGFloat)fontSize;

@end;

@interface UILabel (Relations)

+(CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width;

@end



#endif /* FoundationsExtensions_h */
