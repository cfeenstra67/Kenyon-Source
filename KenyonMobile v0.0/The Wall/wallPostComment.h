//
//  wallPostComment.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/2/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "wallPost.h"

@interface wallPostComment : NSObject

@property (strong, nonatomic) NSString *content;

@property (strong, nonatomic) NSDate *postingDate;

@property (strong, nonatomic) CKReference *parentPost;

@property (strong, nonatomic) CKReference *myUser;

-(id)initWithDictionary:(NSDictionary*)dict;

-(id)initWithContent:(NSString*)content date:(NSDate*)date wallPost:(wallPost*)post;

-(id)initWithRecord:(CKRecord*)rec;

-(CKRecord*)myRecord;

-(NSString*)dateString;

@end
