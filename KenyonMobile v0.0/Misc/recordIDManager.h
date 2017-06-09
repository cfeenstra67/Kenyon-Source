//
//  recordIDManager.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/3/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>

@interface recordIDManager : UIView

-(CKRecord*)userRecord;

-(CKReference*)userRecordReference;

+(id)shared;

-(void)reset;

@end
