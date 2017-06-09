//
//  wallPost.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "wallPost.h"
#import "recordIDManager.h"

@interface wallPost(){
    CKRecord *myRecord;
}
@end

@implementation wallPost

-(id)initWithDictionary:(NSDictionary *)dict
{
    self=[self init];
    _content=[dict objectForKey:@"content"];
    _postingDate=[dict objectForKey:@"creation"];
    _upvotes=[[dict objectForKey:@"upvotes"] integerValue];
    _comments=[[dict objectForKey:@"comments"] integerValue];
    myRecord=[dict objectForKey:@"recid"];
    _myUser=[dict objectForKey:@"creator"];
    return self;
}

-(id)init
{
    self=[super init];
    _content=nil;
    _postingDate=nil;
    _upvotes=0;
    _comments=0;
    myRecord=nil;
    _myUser=[[recordIDManager shared] userRecordReference];
    return self;
}

-(id)initWithContent:(NSString *)content date:(NSDate *)date
{
    self=[self init];
    _content=content;
    _postingDate=date;
    return self;
}

-(id)initWithRecord:(CKRecord *)rec
{
    NSMutableDictionary *temp=[[NSMutableDictionary alloc] init];
    for(id obj in rec.allKeys)
    {
        [temp setObject:rec[obj] forKey:obj];
    }
    [temp setObject:rec forKey:@"recid"];
    return  [self initWithDictionary:temp];
}

-(CKRecord*)myRecordID
{
    if(myRecord!=nil)
    {
        return myRecord;
    }
    CKRecord *rec=[[CKRecord alloc] initWithRecordType:@"wallPost"];
    [rec setObject:_content forKey:@"content"];
    [rec setObject:_postingDate forKey:@"creation"];
    [rec setObject:[NSNumber numberWithInteger:_upvotes] forKey:@"upvotes"];
    [rec setObject:[NSNumber numberWithInteger:_comments] forKey:@"comments"];
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
