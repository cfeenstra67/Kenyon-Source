//
//  recordIDManager.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/3/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "recordIDManager.h"

@implementation recordIDManager


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)init
{
    if(self=[super init])
    {
        
    }
    return self;
}

static recordIDManager *share=nil;
static CKRecord *myRec=nil;

+(id)shared
{
    if(share==nil)
    {
        share=[[self alloc] init];
    }
    return share;
}

-(void)reset
{
    share=nil;
}

-(CKReference*)userRecordReference
{
    return [[CKReference alloc] initWithRecord:[self userRecord] action:CKReferenceActionNone];
}

-(CKRecord*)userRecord
{
    if(myRec!=nil)
    {
        return myRec;
    }
    __block CKRecord *result=nil;
    __block BOOL doneFlag=NO;
    [self findUserRecord:^(CKRecord *rec){
        result=rec;
        doneFlag=YES;
    }];
    while(!doneFlag)
    {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
    return myRec;
}

-(void)findUserRecord:(void(^)(CKRecord*))completion
{
    if(![self isConnected])
    {
        return;
    }
    CKDatabase *database=[[CKContainer containerWithIdentifier:@"iCloud.com.camfeen.Kenyon-Source"] privateCloudDatabase];
    NSPredicate *T=[NSPredicate predicateWithValue:YES];
    CKQuery *query=[[CKQuery alloc] initWithRecordType:@"User" predicate:T];
    CKQueryOperation *qop=[[CKQueryOperation alloc] initWithQuery:query];
    __block CKRecord *result=nil;
    [qop setRecordFetchedBlock:^(CKRecord*rec){
        result=rec;
    }];
    [qop setCompletionBlock:^{
        NSLog(@"completed");
        if(result==nil)
        {
            [self createUserRecord:^(CKRecord* arec){
                myRec=arec;
                completion(arec);
            }];
        }
        else
        {
            myRec=result;
            completion(result);
        }
    }];
    [database addOperation:qop];
}

-(void)createUserRecord:(void(^)(CKRecord*))completion
{
    if(![self isConnected])
    {
        return;
    }
    CKDatabase *database=[[CKContainer containerWithIdentifier:@"iCloud.com.camfeen.Kenyon-Source"] privateCloudDatabase];
    CKRecord *rec=[[CKRecord alloc] initWithRecordType:@"User"];
    [database saveRecord:rec completionHandler:^(CKRecord *rec, NSError *err){
        if(err)
        {
            NSLog(@"error saving user account");
        }
        //resultString=rec.recordID.recordName;
        //[resultString writeToFile:[[NSBundle mainBundle] pathForResource:@"userRecordID" ofType:@".txt"] atomically:NO encoding:NSUTF8StringEncoding error:nil];
        completion(rec);
    }];
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

@end
