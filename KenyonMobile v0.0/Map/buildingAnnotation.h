//
//  buildingAnnotation.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 6/19/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface buildingAnnotation : MKPointAnnotation

@property (strong, nonatomic) NSArray* tags;

-(void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;

+(buildingAnnotation*)initWithXY:(CGFloat)xcoor y:(CGFloat)ycoor;

@end

@interface NSMutableArray (Extensions)

-(void)addAnnotation:(CLLocationCoordinate2D)coordinate title:(NSString*)buildingName;

-(void)addAnnotation:(CLLocationCoordinate2D)coordinate title:(NSString *)buildingName searched:(BOOL)searchValue;

@end

@interface NSDictionary (Extensions)

+(NSDictionary*)getSearchHelperDictionary;

@end





