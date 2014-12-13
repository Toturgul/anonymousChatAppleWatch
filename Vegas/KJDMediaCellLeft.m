//
//  KJDMediaCellLeft.m
//  Vegas
//
//  Created by Karim Mourra on 12/10/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import "KJDMediaCellLeft.h"

@implementation KJDMediaCellLeft

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        reuseID = reuseIdentifier;
        _nameLabel = [[UILabel alloc] init];
        
//        UILabel* nameLabel = [[UILabel alloc] init];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
        [_nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_nameLabel];
        
        UIImageView* mediaView = [[UIImageView alloc] init];
//        [mainLabel setTextColor:[UIColor blackColor]];
        mediaView.image = [UIImage imageNamed:@"background.png"];
        [mediaView setBackgroundColor:[UIColor redColor]];
//        [mainLabel setBackgroundColor:[UIColor colorWithHue:66 saturation:100 brightness:63 alpha:1]];
//        [mainLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
//        [mainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:mediaView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_nameLabel, mediaView);
        if (reuseID == KJDMediaLeft)
        {
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nameLabel]|"
                                                                           options: 0
                                                                           metrics:nil
                                                                             views:views];
            [self.contentView addConstraints:constraints];
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel]-[mediaView]|"
                                                                  options: 0
                                                                  metrics:nil
                                                                    views:views];
            
            [self.contentView addConstraints:constraints];
            
            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mediaView]|"
                                                                 options: 0
                                                                 metrics:nil
                                                                   views:views];
            [self.contentView addConstraints:constraints];
        }
//        if (reuseID == kCellIDTitleMain) {
//            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nameLabel]|"
//                                                                           options:0
//                                                                           metrics:nil
//                                                                             views:views];
//            [self.contentView addConstraints:constraints];
//            
//            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mainLabel]|"
//                                                                  options: 0
//                                                                  metrics:nil
//                                                                    views:views];
//            [self.contentView addConstraints:constraints];
//            
//            constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel][mainLabel(==nameLabel)]|"
//                                                                  options: 0
//                                                                  metrics:nil
//                                                                    views:views];
//            [self.contentView addConstraints:constraints];
//            
//        }
    }
    return self;
}
@end
