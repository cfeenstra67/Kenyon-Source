//
//  wallPostComment.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/2/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "wallPostComment.h"
#import "recordIDManager.h"

@implementation wallPostComment

-(id)initWithDictionary:(NSDictionary *)dict
{
    self=[self init];
    _content=[dict objectForKey:@"content"];
    NSLog(@"content: %@",_content);
    _postingDate=[dict objectForKey:@"creation"];
    _parentPost=[dict objectForKey:@"parentPost"];
    _myUser=[dict objectForKey:@"creator"];
    return self;
}

-(id)init
{
    self=[super init];
    _content=nil;
    _postingDate=nil;
    _parentPost=nil;
    _myUser=[[recordIDManager shared] userRecordReference];
    return self;
}

-(id)initWithContent:(NSString *)content date:(NSDate *)date wallPost:(wallPost *)post
{
    self=[self init];
    _content=content;
    _postingDate=date;
    _parentPost=[[CKReference alloc] initWithRecord:post.myRecordID action:CKReferenceActionNone];
    return self;
}

-(id)initWithRecord:(CKRecord *)rec
{
    NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
    for(id obj in rec.allKeys)
    {
        [temp setObject:rec[obj] forKey:obj];
    }
    return  [self initWithDictionary:temp];
}

-(CKRecord*)myRecord
{
    CKRecord *rec=[[CKRecord alloc] initWithRecordType:@"comment"];
    [rec setObject:_content forKey:@"content"];
    [rec setObject:_postingDate forKey:@"creation"];
    [rec setObject:_parentPost forKey:@"parentPost"];
    [rec setObject:_myUser forKey:@"creator"];
    return rec;
}

-(NSString*)dateString
{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    [format setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
    [format setDateFormat:@"h:mm a, M/d/yyyy"];
    return [format stringFromDate:_postingDate];
}

@end
