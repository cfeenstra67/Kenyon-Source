//
//  wallPostTableViewCell.h
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 2/2/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wallPostTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *postLabel;

@property (strong, nonatomic) IBOutlet UILabel *rightTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftTextLabel;

@end
