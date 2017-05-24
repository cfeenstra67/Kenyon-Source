//
//  assynchronousImagePlacer.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (assynchronous)

-(void)CLFsetImageAtURL:(NSURL*)url withPlaceholder:(UIImage*)imagePlaceholder;

@end
