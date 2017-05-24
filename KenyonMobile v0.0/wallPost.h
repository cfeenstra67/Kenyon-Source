//
//  wallPost.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@interface wallPost : NSObject

@property (strong, nonatomic) NSDate *postingDate;

@property (strong, nonatomic) NSString *content;

@property NSInteger upvotes;

@property NSInteger comments;

@property (strong, nonatomic, readonly) CKRecord *myRecordID;

@property (strong, nonatomic, readonly) CKReference *myUser;

-(id)initWithDictionary:(NSDictionary*)dict;

-(id)initWithContent:(NSString*)content date:(NSDate*)date;

-(id)initWithRecord:(CKRecord*)rec;

-(NSString*)dateString;

@end
