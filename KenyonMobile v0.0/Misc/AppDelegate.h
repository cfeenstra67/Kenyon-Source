//
//  AppDelegate.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/28/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
}

@property (weak, nonatomic) NSURL* path;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id<UIApplicationDelegate>delegate;

@end

