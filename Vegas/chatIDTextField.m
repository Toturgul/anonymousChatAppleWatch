//
//  chatIDTextField.m
//  Vegas
//
//  Created by Jan Roures Mintenig on 24/11/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import "chatIDTextField.h"

@implementation chatIDTextField

- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightBounds = CGRectMake(bounds.size.width-22, bounds.size.height/2.7, 15, 15);
    return rightBounds ;
}

@end
