//
//  commonUseFunctions.h
//  LTHosting
//
//  Created by Cam Feenstra on 1/18/17.
//  Copyright © 2017 Cam Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface NSObject (extension)

@end

@interface UIImage (extension)

+(UIImage*)imageForLayer:(CALayer*)layer;

@end

@interface NSArray (extension)

-(NSArray*)arrayWithObjectsOfType:(Class)type;

@end

@interface CATextLayer (extension)

-(void)adjustBoundsToFit;

@end

@interface UIView (extension)

-(id)copyView;

@end

@interface UITextView (extension)

-(NSInteger)numberOfLines;

@end

@interface UILabel (extension)

-(NSInteger)currentNumberOfLines;

@end

@interface UITextField (extension)

-(NSInteger)currentNumberOfLines;

@end
