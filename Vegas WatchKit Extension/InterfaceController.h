//
//  InterfaceController.h
//  Vegas WatchKit Extension
//
//  Created by Levan Toturgul on 12/16/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (strong, nonatomic) NSMutableArray *infoFromAppDel;
@property (strong, nonatomic) NSMutableArray *oldInfo;
@property (strong, nonatomic) NSString* userName;


- (IBAction)myButton;
@end
