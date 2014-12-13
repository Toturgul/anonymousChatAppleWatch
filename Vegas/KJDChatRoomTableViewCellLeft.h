//
//  KJDChatRoomTableViewCell.h
//  Vegas
//
//  Created by Jan Roures Mintenig on 23/11/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KJDChatRoomTableViewCellLeft : UITableViewCell<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *userMessageTextView;

@end
