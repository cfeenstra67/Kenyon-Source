//
//  postManager.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "wallPostComment.h"

@protocol postManagerDelegate;

@interface postManager : NSObject

+(id)shared;

@property (strong, nonatomic) id<postManagerDelegate> myDelegate;

-(void)getNextBatchWithCursor:(CKQueryCursor*)cursor completion:(void(^)(NSArray<wallPost*>*, CKQueryCursor*))completionBlock;

-(void)setMyDelegate:(id<postManagerDelegate>)myDelegate;

-(void)publishPostWithString:(NSString*)string completion:(void(^)())completionBlock;

-(void)publishPost:(wallPost*)post completion:(void(^)())completionBlock;

-(void)publishComment:(wallPostComment*)comment completion:(void(^)())completionBlock;

-(void)publishCommentWithString:(NSString*)string post:(wallPost*)post completion:(void(^)())completionBlock;

-(NSInteger)batchSize;

@property (strong, nonatomic) CKDatabase *database;

-(void)getCommentsForPost:(wallPost*)post completion:(void(^)(NSArray<wallPostComment*>*))completionBlock;

-(BOOL)reloadDatabase;

-(void)reloadDatabase:(void(^)(BOOL success))completionBlock;

@end

@protocol postManagerDelegate <NSObject>

@optional

-(void)managerDidFetchNewBatch:(postManager*)manager;

-(void)managerDidReset:(postManager*)manager;

-(void)manager:(postManager*)manager DidPublishPost:(wallPost*)post;


@end
