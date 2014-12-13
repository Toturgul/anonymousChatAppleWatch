//
//  KJDImageDisplayViewController.m
//  Vegas
//
//  Created by Karim Mourra on 12/10/14.
//  Copyright (c) 2014 Jan Roures Mintenig. All rights reserved.
//

#import "KJDImageDisplayViewController.h"

@interface KJDImageDisplayViewController ()

@property (strong, nonatomic) UIButton *doneButton;

@end

@implementation KJDImageDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpDisplay];
    [self setUpDoneButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpDisplay
{
    UIImageView* mapView =self.map; //initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];

    [self.view addSubview:self.map];
    mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *mapViewTop = [NSLayoutConstraint constraintWithItem:self.map
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:0.0];
    
    NSLayoutConstraint *mapViewBottom = [NSLayoutConstraint constraintWithItem:self.map
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:-60.0];
    
    NSLayoutConstraint *mapViewWidth = [NSLayoutConstraint constraintWithItem:self.map
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0
                                                                     constant:0.0];
    
    NSLayoutConstraint *mapViewLeft = [NSLayoutConstraint constraintWithItem:self.map
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0
                                                                    constant:0.0];
    
    [self.view addConstraints:@[mapViewTop, mapViewBottom, mapViewWidth, mapViewLeft]];
}

-(void) setUpDoneButton
{
    self.doneButton = [[UIButton alloc] init];
    [self.view addSubview:self.doneButton];
    self.doneButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.doneButton.layer.cornerRadius=10.0f;
    self.doneButton.layer.masksToBounds=YES;
    [self.doneButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Done!" attributes:nil] forState:UIControlStateNormal];
    self.doneButton.titleLabel.textColor=[UIColor whiteColor];
    [self.doneButton addTarget:self action:@selector(doneButtonNormal) forControlEvents:UIControlEventTouchDown];
    [self.doneButton addTarget:self action:@selector(doneButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    NSLayoutConstraint *doneButtonTop = [NSLayoutConstraint constraintWithItem:self.doneButton
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.map
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:4.0];
    
    NSLayoutConstraint *doneButtonBottom = [NSLayoutConstraint constraintWithItem:self.doneButton
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:-4.0];
    
    NSLayoutConstraint *doneButtonRight = [NSLayoutConstraint constraintWithItem:self.doneButton
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:-4.0];
    
    NSLayoutConstraint *doneButtonLeft = [NSLayoutConstraint constraintWithItem:self.doneButton
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:4.0];
    
    [self.view addConstraints:@[doneButtonTop, doneButtonBottom, doneButtonRight, doneButtonLeft]];
}

- (void)doneButtonTapped
{
    self.doneButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.doneButton.titleLabel.textColor=[UIColor whiteColor];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)doneButtonNormal
{
    self.doneButton.backgroundColor=[UIColor colorWithRed:0.016 green:0.341 blue:0.22 alpha:1];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
