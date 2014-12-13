//
//  KJDChatRoomTableViewCell.m
//  Vegas
//
//  Created by Jan Roures Mintenig on 23/11/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import "KJDChatRoomTableViewCell.h"

@implementation KJDChatRoomTableViewCell


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
