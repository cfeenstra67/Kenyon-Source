//
//  Handbook.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 5/28/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Handbook.h"
#import "FoundationsExtensions.h"



@implementation handbook

static NSDictionary *book=nil;

+ (NSDictionary *) initializeHandbook
{
    if(book==nil)
    {
        [[NSUserDefaults standardUserDefaults] synchronize];
        CGFloat fontSize=[UIFont preferredFontForTextStyle:UIFontTextStyleBody].pointSize;
        NSMutableDictionary* temporary=[[NSMutableDictionary alloc] init];
        
        NSDictionary* source=[[NSDictionary alloc] initWithDictionary:[handbook generateSources] copyItems:YES];
        NSArray* allFiles=[[NSArray alloc] initWithArray:source.allKeys];
        
        NSMutableArray* filepaths=[[NSMutableArray alloc] init];
        for(sourceData* key in allFiles)
        {
            if(!([key.text isEqualToString:@"Student Regulations"]||[key.text isEqualToString:@"Procedures for Withdrawing from the College"]||[key.text isEqualToString:@"The Student Conduct Review System"]||[key.text isEqualToString:@"Summary of College Rules Violations"]))
            {
                [filepaths addObject:key.text];
            }
        }
        
        for(NSString* string in filepaths)
        {
            NSString* path=[[NSBundle mainBundle] pathForResource:string.takeSpaces ofType:@".txt"];
            NSAttributedString* input= [[NSAttributedString alloc] initWithString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
            
            NSAttributedString* attributedInput=[[NSAttributedString alloc] initWithAttributedString:[[[input makeFontSize:fontSize] makeBold:fontSize] makeItalic:fontSize]];
            temporary[string]=attributedInput;
        }
        book= temporary;
        
    }
    return book;
}

+(NSDictionary*)generateSources
{
    NSMutableDictionary* full=[[NSMutableDictionary alloc] init];
    NSString* source=[[NSString alloc] init];
    sourceData* temp=[[sourceData alloc] init];
    
    source=@"Student Handbook";
    full[[temp sourceDataWith:@"Student Rights and Responsibilities" ordering:0]]=source;
    full[[temp sourceDataWith:@"Student Regulations" ordering:1]]=source;
    full[[temp sourceDataWith:@"Procedures for Withdrawing from the College" ordering:2]]=source;
    full[[temp sourceDataWith:@"The Student Conduct Process" ordering:3]]=source;
    //full[[temp sourceDataWith:@"Summary of College Rules Violations" ordering:5]]=source;
    full[[temp sourceDataWith:@"The Student Conduct Review System" ordering:4]]=source;
    full[[temp sourceDataWith:@"Non-Discrimination Statement" ordering:5]]=source;
    
    source=@"Student Regulations";
    full[[temp sourceDataWith:@"Changes to Student Regulations" ordering:0]]=source;
    full[[temp sourceDataWith:@"A. Alcoholic Beverages" ordering:1]]=source;
    full[[temp sourceDataWith:@"B. Non-Sexual Assault" ordering:2]]=source;
    full[[temp sourceDataWith:@"C. Banners, flyers, and posters" ordering:3]]=source;
    full[[temp sourceDataWith:@"D. Bicycle Registration and Regulations" ordering:4]]=source;
    full[[temp sourceDataWith:@"E. Brown Family Environmental Center" ordering:5]]=source;
    full[[temp sourceDataWith:@"F. Computers, Email and Social Media" ordering:6]]=source;
    full[[temp sourceDataWith:@"G. Conduct" ordering:7]]=source;
    full[[temp sourceDataWith:@"H. Damage" ordering:8]]=source;
    full[[temp sourceDataWith:@"I. Demonstrations and Protests" ordering:9]]=source;
    full[[temp sourceDataWith:@"J. Discriminatory Harassment" ordering:10]]=source;
    full[[temp sourceDataWith:@"K. Drugs" ordering:11]]=source;
    full[[temp sourceDataWith:@"L. Endangering Behavior" ordering:12]]=source;
    full[[temp sourceDataWith:@"M. Failure to Comply" ordering:13]]=source;
    full[[temp sourceDataWith:@"N. Fire Safety" ordering:14]]=source;
    full[[temp sourceDataWith:@"O. Hazing" ordering:15]]=source;
    full[[temp sourceDataWith:@"P. Honesty" ordering:16]]=source;
    full[[temp sourceDataWith:@"Q. Housing and Residential Life" ordering:17]]=source;
    full[[temp sourceDataWith:@"R. College Issued Identification Cards" ordering:18]]=source;
    full[[temp sourceDataWith:@"S. Motor Vehicles" ordering:19]]=source;
    full[[temp sourceDataWith:@"T. Organizations Not Affiliated with the College" ordering:20]]=source;
    full[[temp sourceDataWith:@"U. Unauthorized Access" ordering:21]]=source;
    full[[temp sourceDataWith:@"V. Senior Week" ordering:22]]=source;
    full[[temp sourceDataWith:@"W. Sexual and Gender-Based Discrimination" ordering:23]]=source;
    full[[temp sourceDataWith:@"X. Smoking" ordering:24]]=source;
    full[[temp sourceDataWith:@"Y. Social Events" ordering:25]]=source;
    full[[temp sourceDataWith:@"Z. Student Engagement" ordering:26]]=source;
    full[[temp sourceDataWith:@"AA. Student Enterprises" ordering:27]]=source;
    full[[temp sourceDataWith:@"BB. Theft" ordering:28]]=source;
    full[[temp sourceDataWith:@"CC. Weapons" ordering:29]]=source;
    
    source=@"Procedures for Withdrawing from the College";
    full[[temp sourceDataWith:@"Withdrawal from the College" ordering:0]]=source;
    full[[temp sourceDataWith:@"Personal Leaves" ordering:1]]=source;
    full[[temp sourceDataWith:@"Medical Leaves" ordering:2]]=source;
    full[[temp sourceDataWith:@"Mandatory Withdrawal" ordering:3]]=source;
    full[[temp sourceDataWith:@"Applicability" ordering:4]]=source;
    full[[temp sourceDataWith:@"Process for Mandatory Withdrawal" ordering:5]]=source;
    full[[temp sourceDataWith:@"Informal Hearing" ordering:6]]=source;
    full[[temp sourceDataWith:@"Return from a Mandatory Withdrawal" ordering:7]]=source;
    full[[temp sourceDataWith:@"Financial Arrangements" ordering:8]]=source;
    
    source=@"The Student Conduct Review System";
    full[[temp sourceDataWith:@"Introduction" ordering:0]]=source;
    full[[temp sourceDataWith:@"Section 1. Terms Used in the Student Conduct Review System" ordering:1]]=source;
    full[[temp sourceDataWith:@"Section 2. Membership of the Student Conduct Review Board" ordering:2]]=source;
    full[[temp sourceDataWith:@"Section 3. Initial Procedures for the Resolution of Conduct Matters" ordering:3]]=source;
    full[[temp sourceDataWith:@"Section 4. Powers and Duties of the Student Conduct Review Board" ordering:4]]=source;
    full[[temp sourceDataWith:@"Section 5. Rights of the Complainant and Rights of the Respondent in the Conduct Process" ordering:5]]=source;
    full[[temp sourceDataWith:@"Section 6. Student Conduct Review Board Procedures" ordering:6]]=source;
    
    NSDictionary* output=[[NSDictionary alloc] initWithDictionary:full];
    return output;
}

+(NSArray*)sortedKeysForObject:(NSString*)object;
{
    NSArray* unsorted=[[NSMutableArray alloc] initWithArray:[[handbook generateSources] allKeysForObject:object]];
    
    NSMutableArray* sort=[[NSMutableArray alloc] init];
    
    for(NSInteger i=0; i<unsorted.count; i++)
    {
        for(NSInteger j=0; j<unsorted.count; j++)
        {
            sourceData* temp=[[sourceData alloc] init];
            temp=[unsorted objectAtIndex:j];
            if(temp.place==i)
            {
                [sort addObject:temp.text];
            }
        }
    }
    
    NSArray* sorted=[[NSArray alloc] initWithArray:sort];
    return sorted;
}
@end

@implementation sourceData

-(sourceData*)sourceDataWith:(NSString *)content ordering:(NSInteger)spot
{
    sourceData* temp=[[sourceData alloc] init];
    temp.place=spot;
    temp.text=content;
    
    return temp;
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)sectionForString:(NSString *)keyText
{
    NSDictionary* full=[handbook generateSources];
    NSArray* all=[full allKeys];
    for(sourceData* object in all)
    {
        if([keyText isEqualToString:object.text])
        {
            return [full objectForKey:object];
        }
    }
    return @"NOT FOUND";
}

+(sourceData*)sourceDataForString:(NSString *)string
{
    NSDictionary* full=[handbook generateSources];
    NSArray* all=[full allKeys];
    for(sourceData* object in all)
    {
        if([string isEqualToString:object.text])
        {
            return object;
        }
    }
    return [[sourceData alloc] init];
}

@end

//code for finding titles for the navView


@implementation findTitles

+(NSArray*)findBold:(NSAttributedString *)source fontSize:(CGFloat)font
{
    NSMutableArray* result=[[NSMutableArray alloc] init];
    UIFont* boldText=[UIFont boldSystemFontOfSize:font];
    NSDictionary* bold=[NSDictionary dictionaryWithObjectsAndKeys:boldText, NSFontAttributeName, nil];
    
    for(NSInteger i=0; i<source.length; i++)
    {
        NSRange temp;
        if([[source attributesAtIndex:i effectiveRange:&temp] isEqualToDictionary:bold])
        {
            NSAttributedString *entry=[[NSAttributedString alloc] initWithAttributedString:[source attributedSubstringFromRange:temp]];
            
            [result addObject:entry];
            i+=temp.length;
        }
    }
    
    NSArray* final=[[NSArray alloc] initWithArray:result];
    return final;
}

+(NSString*)findSegue:(NSString *)title
{
    NSMutableDictionary* store=[[NSMutableDictionary alloc] init];
    NSString* segueIden1=@"toTextView";
    NSString* segueIden2=@"toNavView";
    NSString* segueIden3=@"toSections";
    store[@"Non-Discrimination Statement"]=segueIden1;
    store[@"Student Rights and Responsibilities"]=segueIden1;
    
    store[@"Student Regulations"]=segueIden3;
    store[@"Changes to Student Regulations"]=segueIden1;
    store[@"A. Alcoholic Beverages"]=segueIden2;
    store[@"B. Non-Sexual Assault"]=segueIden2;
    store[@"C. Banners, flyers, and posters"]=segueIden1;
    store[@"D. Bicycle Registration and Regulations"]=segueIden1;
    store[@"E. Brown Family Environmental Center"]=segueIden1;
    store[@"F. Computers, Email and Social Media"]=segueIden1;
    store[@"G. Conduct"]=segueIden1;
    store[@"H. Damage"]=segueIden1;
    store[@"I. Demonstrations and Protests"]=segueIden1;
    store[@"J. Discriminatory Harassment"]=segueIden2;
    store[@"K. Drugs"]=segueIden1;
    store[@"L. Endangering Behavior"]=segueIden3;
    store[@"M. Failure to Comply"]=segueIden1;
    store[@"N. Fire Safety"]=segueIden1;
    store[@"O. Hazing"]=segueIden2;
    store[@"P. Honesty"]=segueIden1;
    store[@"Q. Housing and Residential Life"]=segueIden2;
    store[@"R. College Issued Identification Cards"]=segueIden1;
    store[@"S. Motor Vehicles"]=segueIden1;
    store[@"T. Organizations Not Affiliated with the College"]=segueIden1;
    store[@"U. Unauthorized Access"]=segueIden1;
    store[@"V. Senior Week"]=segueIden1;
    store[@"W. Sexual and Gender-Based Discrimination"]=segueIden1;
    store[@"X. Smoking"]=segueIden1;
    store[@"Y. Social Events"]=segueIden2;
    store[@"Z. Student Engagement"]=segueIden2;
    store[@"AA. Student Enterprises"]=segueIden1;
    store[@"BB. Theft"]=segueIden1;
    store[@"CC. Weapons"]=segueIden1;
    
    store[@"Procedures for Withdrawing from the College"]=segueIden3;
    store[@"Withdrawal from the College"]=segueIden1;
    store[@"Personal Leaves"]=segueIden1;
    store[@"Medical Leaves"]=segueIden1;
    store[@"Mandatory Withdrawal"]=segueIden1;
    store[@"Applicability"]=segueIden1;
    store[@"Process for Mandatory Withdrawal"]=segueIden1;
    store[@"Informal Hearing"]=segueIden1;
    store[@"Return from a Mandatory Withdrawal"]=segueIden1;
    store[@"Financial Arrangements"]=segueIden1;
    
    store[@"The Student Conduct Process"]=segueIden2;
    
    //store[@"Summary of College Rules Violations"]=segueIden1;
    
    store[@"The Student Conduct Review System"]=segueIden3;
    store[@"Introduction"]=segueIden1;
    store[@"Section 1. Terms Used in the Student Conduct Review System"]=segueIden2;
    store[@"Section 2. Membership of the Student Conduct Review Board"]=segueIden1;
    store[@"Section 3. Initial Procedures for the Resolution of Conduct Matters"]=segueIden1;
    store[@"Section 4. Powers and Duties of the Student Conduct Review Board"]=segueIden1;
    store[@"Section 5. Rights of the Complainant and Rights of the Respondent in the Conduct Process"]=segueIden2;
    store[@"Section 6. Student Conduct Review Board Procedures"]=segueIden2;
    
    return [store objectForKey:title];
}

@end
















