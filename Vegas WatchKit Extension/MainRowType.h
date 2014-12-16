//
//  MainRowType.h
//  Vegas
//
//  Created by Levan Toturgul on 12/16/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>
@interface MainRowType : NSObject

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *usernameLabel;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *messageLabel;



@end
