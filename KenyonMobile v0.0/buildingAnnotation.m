//
//  buildingAnnotation.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 6/19/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "buildingAnnotation.h"

@implementation buildingAnnotation: MKPointAnnotation

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    [super setCoordinate:newCoordinate];
}

+(buildingAnnotation*)initWithXY:(CGFloat)xcoor y:(CGFloat)ycoor
{
    buildingAnnotation* temp=[[buildingAnnotation alloc] init];
    [temp setCoordinate:CLLocationCoordinate2DMake(xcoor, ycoor)];
    return temp;
}

@end

@implementation NSMutableArray (Extensions)

-(void)addAnnotation:(CLLocationCoordinate2D)coordinate title:(NSString*)buildingName
{
    buildingAnnotation *add=[[buildingAnnotation alloc] init];
    [add setCoordinate:coordinate];
    [add setTitle:buildingName];
    [self addObject:add];
}

-(void)addAnnotation:(CLLocationCoordinate2D)coordinate title:(NSString *)buildingName searched:(BOOL)searchValue
{
    buildingAnnotation *add=[[buildingAnnotation alloc] init];
    [add setCoordinate:coordinate];
    [add setTitle:buildingName];
    [self addObject:add];
}

@end

@implementation NSDictionary (Extensions)

+(NSDictionary*)getSearchHelperDictionary
{
    NSMutableDictionary *searchDict=[[NSMutableDictionary alloc] init];
    //building codes
    [searchDict setObject:@"Acland House" forKey:@"ACL"];
    [searchDict setObject:@"Ascension Hall" forKey:@"ASC"];
    [searchDict setObject:@"Bailey House" forKey:@"BAIL"];
    [searchDict setObject:@"Bexley Hall" forKey:@"BH"];
    [searchDict setObject:@"Black Box Theater" forKey:@"BBT"];
    [searchDict setObject:@"Bolton Dance" forKey:@"DAN"];
    [searchDict setObject:@"Bolton Theater" forKey:@"BOL"];
    [searchDict setObject:@"Brown Family Environmental Center" forKey:@"BFEC"];
    [searchDict setObject:@"Chalmers Library" forKey:@"CHL"];
    [searchDict setObject:@"Church of the Holy Spirit" forKey:@"CHAP"];
    [searchDict setObject:@"Colburn Hall" forKey:@"COLBRN"];
    [searchDict setObject:@"Craft Center" forKey:@"CRAFT"];
    [searchDict setObject:@"Crozier Center" forKey:@"CROZ"];
    [searchDict setObject:@"Davis House" forKey:@"DAV"];
    [searchDict setObject:@"Eaton Center" forKey:@"EATON"];
    [searchDict setObject:@"Edelstein House" forKey:@"EDEL"];
    [searchDict setObject:@"Finn House" forKey:@"FINN"];
    [searchDict setObject:@"Higley Hall" forKey:@"FSH"];
    [searchDict setObject:@"Ganter Hall" forKey:@"GNT"];
    [searchDict setObject:@"Gund Commons" forKey:@"GND"];
    [searchDict setObject:@"Gund Gallery" forKey:@"GAL"];
    [searchDict setObject:@"Gund Residence Hall" forKey:@"GRH"];
    [searchDict setObject:@"Hanna Hall" forKey:@"HANNA"];
    [searchDict setObject:@"Hayes Hall" forKey:@"HAYES"];
    [searchDict setObject:@"Hayes Hall" forKey:@"RBH"];
    [searchDict setObject:@"Health and Counseling Center" forKey:@"HCC"];
    [searchDict setObject:@"Higley Hall" forKey:@"HIG"];
    [searchDict setObject:@"Hill Theater" forKey:@"HIL"];
    [searchDict setObject:@"Hoehn-Saric House" forKey:@"HS"];
    [searchDict setObject:@"Horn Gallery" forKey:@"HRN GAL"];
    [searchDict setObject:@"Horvitz Hall" forKey:@"HSA"];
    [searchDict setObject:@"Horwitz House" forKey:@"HRW"];
    [searchDict setObject:@"Kenyon Athletic Center" forKey:@"KAC"];
    [searchDict setObject:@"Lentz House" forKey:@"LEN"];
    [searchDict setObject:@"Leonard Hall" forKey:@"LEO"];
    [searchDict setObject:@"O'Connor House" forKey:@"OCO"];
    [searchDict setObject:@"Old Kenyon" forKey:@"OLDKEN"];
    [searchDict setObject:@"Olin Library" forKey:@"OLN"];
    [searchDict setObject:@"Palme House" forKey:@"PLM"];
    [searchDict setObject:@"Peirce Hall" forKey:@"PRC"];
    [searchDict setObject:@"Ralston House" forKey:@"RAL"];
    [searchDict setObject:@"Rosse Hall" forKey:@"ROS"];
    [searchDict setObject:@"Samuel Mather Hall" forKey:@"SMA"];
    [searchDict setObject:@"Seitz House" forKey:@"SEITZ"];
    [searchDict setObject:@"Snowden Multicultural Center" forKey:@"SNO"];
    [searchDict setObject:@"Storer Hall" forKey:@"STR"];
    [searchDict setObject:@"Sunset Cottage" forKey:@"SUN"];
    [searchDict setObject:@"Timberlake House" forKey:@"TMB"];
    [searchDict setObject:@"Tomsich Hall" forKey:@"TOM"];
    [searchDict setObject:@"Trelaven House" forKey:@"TRL"];
    [searchDict setObject:@"Weaver Cottage" forKey:@"WVR"];
    
    NSDictionary *returnDict=[[NSDictionary alloc] initWithDictionary:searchDict];
    return returnDict;
}

@end
























