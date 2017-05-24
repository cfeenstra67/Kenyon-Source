//
//  FoundationsExtensions.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/30/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//code for spaces add and remove

@implementation NSString (Extensions)

-(NSString*)takeSpaces
{
    NSString* stringNoSpaces=[self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return stringNoSpaces;
}

/*-(NSString*)giveSpaces;
 {
 
 }*/

@end

//code to add bolds to section strings

@implementation NSAttributedString (Extensions)

-(NSAttributedString*)makeBold:(CGFloat)fontSize
{
    NSMutableAttributedString* temp=[[NSMutableAttributedString alloc] initWithAttributedString:self];
    
    NSUInteger counter=0;
    
    UIFont* boldText=[UIFont boldSystemFontOfSize:fontSize];
    
    while([[temp.string substringFromIndex:counter] rangeOfString:@"/bold/"].location!=NSNotFound)
    {
        NSRange begin=[temp.string rangeOfString:@"/bold/"];
        NSRange end=[temp.string rangeOfString:@"/endbold/"];
        NSUInteger stringLoc=begin.location+begin.length;
        NSUInteger stringLength=end.location-stringLoc;
        NSRange bold=NSMakeRange(stringLoc, stringLength);
        NSString* text=[temp.string substringWithRange:bold];
        
        NSDictionary* boldAttribute=[NSDictionary dictionaryWithObjectsAndKeys:boldText, NSFontAttributeName, nil];
        [temp setAttributes:boldAttribute range:bold];
        
        [temp deleteCharactersInRange:end];
        [temp deleteCharactersInRange:begin];
        
        NSRange newRange=[temp.string rangeOfString:text];
        counter=newRange.location+newRange.length;
    }
    
    NSAttributedString* final=[[NSAttributedString alloc] initWithAttributedString:temp];
    return final;
}

-(NSAttributedString*)makeItalic:(CGFloat)fontSize
{
    NSMutableAttributedString* temp=[[NSMutableAttributedString alloc] initWithAttributedString:self];
    
    NSUInteger counter=0;
    
    UIFont* boldText=[UIFont italicSystemFontOfSize:fontSize];
    
    while([[temp.string substringFromIndex:counter] rangeOfString:@"/italic/"].location!=NSNotFound)
    {
        NSRange begin=[temp.string rangeOfString:@"/italic/"];
        NSRange end=[temp.string rangeOfString:@"/enditalic/"];
        NSUInteger stringLoc=begin.location+begin.length;
        NSUInteger stringLength=end.location-stringLoc;
        NSRange bold=NSMakeRange(stringLoc, stringLength);
        NSString* text=[temp.string substringWithRange:bold];
        
        NSDictionary* boldAttribute=[NSDictionary dictionaryWithObjectsAndKeys:boldText, NSFontAttributeName, nil];
        [temp setAttributes:boldAttribute range:bold];
        
        [temp deleteCharactersInRange:end];
        [temp deleteCharactersInRange:begin];
        
        NSRange newRange=[temp.string rangeOfString:text];
        counter=newRange.location+newRange.length;
    }
    
    NSAttributedString* final=[[NSAttributedString alloc] initWithAttributedString:temp];
    return final;
}

-(NSAttributedString*)makeFontSize:(CGFloat)fontSize
{
    NSMutableAttributedString* temp=[[NSMutableAttributedString alloc] initWithAttributedString:self];
    [temp addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, self.length)];
    return [[NSAttributedString alloc] initWithAttributedString:temp];
}

@end

@implementation UILabel (Relations)

+(CGFloat)heightForText:(NSString*)text font:(UIFont*)font withinWidth:(CGFloat)width
{
    CGSize size=[text sizeWithAttributes:@{NSFontAttributeName: font}];
    CGFloat area=size.height*size.width;
    CGFloat height=roundf(area/width);
    return ceilf(height/font.lineHeight)*font.lineHeight;
}


@end





