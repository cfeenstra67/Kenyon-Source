//
//  commonUseFunctions.m
//  LTHosting
//
//  Created by Cam Feenstra on 1/18/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import "commonUseFunctions.h"

@implementation NSObject (extension)

@end

//Break

@implementation UIImage(extension)

+(UIImage*)imageForLayer:(CALayer *)layer
{
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0.0f);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

@end

@implementation NSArray (extension)

-(NSArray*)arrayWithObjectsOfType:(Class)type
{
    NSMutableArray *temp=[NSMutableArray array];
    for(id object in self)
    {
        if([object class]==type)
        {
            [temp addObject:object];
        }
    }
    return [NSArray arrayWithArray:temp];
}

@end

@implementation CATextLayer (extension)

-(void)adjustBoundsToFit
{
    
}

@end

@implementation UIView (extension)

-(id)copyView
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end

@implementation UITextView (extension)

-(NSInteger)numberOfLines
{
    return ceil(self.contentSize.height/self.font.lineHeight);
}

@end

@implementation UILabel (extension)

-(NSInteger)currentNumberOfLines
{
    CGRect textRect=[self textRectForBounds:CGRectMake(0, 0, self.bounds.size.width, CGFLOAT_MAX) limitedToNumberOfLines:0];
    NSInteger temp=round(textRect.size.height/self.font.lineHeight);
    return temp;
}

@end

@implementation UITextField (extension)

-(NSInteger)currentNumberOfLines
{
    NSAttributedString *atr=self.attributedText;
    CGFloat labelWidth=self.frame.size.width-self.leftView.frame.size.width-self.rightView.frame.size.width;
    return ceil((atr.size.height*atr.size.width)/labelWidth/self.font.lineHeight);
}

@end
