//
//  postManager.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "postManager.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface postManager(){
    NSInteger batchSize;
    
}
@end

@implementation postManager


-(id)init
{
    if(self=[super init])
    {
        _database=[[CKContainer containerWithIdentifier:@"iCloud.com.camfeen.Kenyon-Source"] publicCloudDatabase];
        batchSize=100;
    }
    return self;
}

+(id)shared
{
    static dispatch_once_t onceToken;
    static postManager *man=nil;
    dispatch_once(&onceToken, ^{
        man=[[self alloc] init];
    });
    return man;
}

-(void)getNextBatchWithCursor:(CKQueryCursor *)curs completion:(void (^)(NSArray<wallPost *> *, CKQueryCursor*))completionBlock
{
    if(![self reloadDatabase])
    {
        completionBlock([[NSArray alloc] init],nil);
        return;
    }
    __block NSMutableArray<wallPost*>* newPosts=[[NSMutableArray alloc] init];
    CKQueryOperation *qop;
    if(curs==nil)
    {
        NSPredicate *allPosts=[NSPredicate predicateWithValue:YES];
        CKQuery *postQuery=[[CKQuery alloc] initWithRecordType:@"wallPost" predicate:allPosts];
        postQuery.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        qop=[[CKQueryOperation alloc] initWithQuery:postQuery];
        [qop setResultsLimit:batchSize];
    }
    else
    {
        qop=[[CKQueryOperation alloc] initWithCursor:curs];
        [qop setResultsLimit:batchSize];
    }
    [qop setRecordFetchedBlock:^(CKRecord *rec){
        NSLog(@"%@",rec.recordID.recordName);
        [newPosts addObject:[[wallPost alloc] initWithRecord:rec]];
    }];
    [qop setQueryCompletionBlock:^(CKQueryCursor *curso, NSError *error){
        if(error)
        {
            NSLog(@"error occurred");
        }
        [_myDelegate managerDidFetchNewBatch:self];
        completionBlock([NSArray arrayWithArray:newPosts],[curso copy]);
    }];
    [qop setCompletionBlock:^{
        
    }];
    [_database addOperation:qop];
}

-(void)setMyDelegate:(id<postManagerDelegate>)myDelegate
{
    NSLog(@"delegate set");
    _myDelegate=myDelegate;
}

-(void)publishPostWithString:(NSString *)string completion:(void(^)())completionBlock
{
    wallPost *newP=[[wallPost alloc] initWithContent:string date:[NSDate date]];
    [self publishPost:newP completion:completionBlock];
}

-(void)publishPost:(wallPost *)post completion:(void(^)())completionBlock
{
    [_database saveRecord:[post myRecordID] completionHandler:^(CKRecord *rec, NSError *err){
        completionBlock();
    }];
}

-(void)publishComment:(wallPostComment *)comment completion:(void(^)())completionBlock
{
    [_database saveRecord:[comment myRecord] completionHandler:^(CKRecord *rec, NSError *err){
        completionBlock();
    }];
    
}

-(void)publishCommentWithString:(NSString *)string post:(wallPost *)post completion:(void(^)())completionBlock
{
    [self publishComment:[[wallPostComment alloc] initWithContent:string date:[NSDate date] wallPost:post] completion:^{
        [self commentWasAddedToPost:post completion:^{
            completionBlock();
        }];
    }];
    
}

-(void)commentWasAddedToPost:(wallPost*)post completion:(void(^)())completionBlock
{
    CKRecord *postRect=post.myRecordID;
    NSNumber *newNum=[NSNumber numberWithInteger:post.comments+1];
    [postRect setObject:newNum forKey:@"comments"];
    [_database saveRecord:postRect completionHandler:^(CKRecord *rec, NSError *err){
        completionBlock();
    }];
}

-(NSInteger)batchSize
{
    return batchSize;
}

-(BOOL)reloadDatabase
{
    __block BOOL success=NO;
    __block BOOL doneFlag=NO;
    [self reloadDatabase:^(BOOL suc){
        success=suc;
        doneFlag=YES;
    }];
    while(!doneFlag)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
    return success;
}

-(void)reloadDatabase:(void(^)(BOOL success))completionBlock
{
    _database=nil;
    _database=[[CKContainer containerWithIdentifier:@"iCloud.com.camfeen.Kenyon-Source"] publicCloudDatabase];
    if(_database==nil||![self isConnected])
    {
        completionBlock(NO);
    }
    else
    {
        completionBlock(YES);
    }
}

-(BOOL)isConnected
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com/"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data)
        return YES;
    else
        return NO;
}

-(void)getCommentsForPost:(wallPost*)post completion:(void (^)(NSArray<wallPostComment *> *))completionBlock
{
    [self getCommentsForPostWithRecord:post.myRecordID completion:completionBlock];
}

-(void)getCommentsForPostWithRecord:(CKRecord*)rec completion:(void(^)(NSArray<wallPostComment*>*))completionBlock
{
    if(![self reloadDatabase])
    {
        completionBlock([[NSArray alloc] init]);
        return;
    }
    __block NSMutableArray<wallPostComment*>* comments=[[NSMutableArray alloc] init];
    CKReference *ref=[[CKReference alloc] initWithRecord:rec action:CKReferenceActionNone];
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"parentPost == %@",ref];
    _database=nil;
    _database=[[CKContainer containerWithIdentifier:@"iCloud.com.camfeen.Kenyon-Source"] publicCloudDatabase];
    CKQuery *query=[[CKQuery alloc] initWithRecordType:@"comment" predicate:pred];
    query.sortDescriptors=@[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    CKQueryOperation *qop=[[CKQueryOperation alloc] initWithQuery:query];
    [qop setResultsLimit:CKQueryOperationMaximumResults];
    [qop setRecordFetchedBlock:^(CKRecord *rec){
        NSLog(@"record fetched");
        [comments addObject:[[wallPostComment alloc] initWithRecord:rec]];
    }];
    [qop setQueryCompletionBlock:^(CKQueryCursor *cursor, NSError *error){
        NSLog(@"query completed");
        if(error)
        {
            NSLog(@"error completing query");
        }
        completionBlock([NSArray arrayWithArray:comments]);
    }];
    [_database addOperation:qop];
}

@end
