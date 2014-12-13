//
//  KJDMediaCellLeft.h
//  Vegas
//
//  Created by Karim Mourra on 12/10/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString * const KJDMediaLeft = @"CellWithMediaLeft";
//static NSString * const kCellIDTitleMain = @"CellWithTitleMain";

@interface KJDMediaCellLeft : UITableViewCell
{
    NSString *reuseID;
}

@property (nonatomic, strong) UILabel *nameLabel;

//@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *mediaContent;

@end
