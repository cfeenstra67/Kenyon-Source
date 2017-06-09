//
//  localSettings.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "localSettings.h"

@interface localSettings(){
    NSMutableDictionary *settings;
}
@end

@implementation localSettings

-(id)init
{
    if(self=[super init])
    {
        settings=[[NSMutableDictionary alloc] init];
        [self updateTextSettings];
    }
    return self;
}

+(localSettings*)shared
{
    static dispatch_once_t onceToken;
    __block localSettings *temp;
    dispatch_once(&onceToken, ^{
        temp=[[self alloc] init];
    });
    return temp;
}

-(id)objectForKey:(id)aKey
{
    return [settings objectForKey:aKey];
}

-(void)updateTextSettings
{
    [settings setObject:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle2] forKey:@"tableFont"];
    [settings setObject:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] forKey:@"bodyFont"];
    [settings setObject:[UIFont preferredFontForTextStyle:UIFontTextStyleTitle1] forKey:@"titleFont"];
}

@end
