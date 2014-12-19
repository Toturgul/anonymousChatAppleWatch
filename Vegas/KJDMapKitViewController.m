//
//  KJDMapKitViewController.m
//  ChatCode
//
//  Created by Karim Mourra on 11/26/14.
//  Copyright (c) 2014 Karim. All rights reserved.
//

#import "KJDMapKitViewController.h"
#import "KJDChatRoomViewController.h"
#import <MapKit/MapKit.h>


@interface KJDMapKitViewController ()

@property(strong, nonatomic) MKMapView* mapView;
@property (strong, nonatomic) UIButton *yesButton;
@property (strong, nonatomic) UIButton *noButton;
@property (strong, nonatomic) UILabel *pageTitle;

@property (strong,nonatomic) CLLocation *currentCoordinates;

@end

@implementation KJDMapKitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDesiredAccuracy:kCLDistanceFilterNone];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager  requestWhenInUseAuthorization];
    }
//    [self setupNavigationBar];
    [self setUpMapView];
    
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    if (self.locationManager.location)
    {
        [self locationManager:self.locationManager didUpdateLocations:@[self.locationManager.location]];
    }
    
    MKCoordinateRegion regionToDisplay = MKCoordinateRegionMakeWithDistance(self.currentCoordinates.coordinate, 10, 10);
    
    [self.mapView setRegion:regionToDisplay animated:YES];
    [self setUpYesButton];
    [self setUpNoButton];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentCoordinates = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"KJD -There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated

{
    self.currentCoordinates = [[CLLocation alloc] initWithLatitude:38.8833 longitude:-77.0167];
    [self.locationManager startUpdatingLocation];
//    [self.navigationController setNavigationBarHidden:NO];
}

//-(void)setupNavigationBar
//{
//    self.navigationItem.title=@"Share this location?";
//    self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.view.backgroundColor = [UIColor clearColor];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//}

-(void) setUpMapView
{
    self.mapView = [[MKMapView alloc] init];//WithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 100)];
    [self.view addSubview:self.mapView];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *mapViewTop = [NSLayoutConstraint constraintWithItem:self.mapView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.0
                                                                     constant:0.0];
    
    NSLayoutConstraint *mapViewBottom = [NSLayoutConstraint constraintWithItem:self.mapView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-60.0];
    
    NSLayoutConstraint *mapViewWidth = [NSLayoutConstraint constraintWithItem:self.mapView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    NSLayoutConstraint *mapViewLeft = [NSLayoutConstraint constraintWithItem:self.mapView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:0.0];
    
    [self.view addConstraints:@[mapViewTop, mapViewBottom, mapViewWidth, mapViewLeft]];
}

-(void) setUpUpperBar
{
    
}

-(void) setUpYesButton
{
    self.yesButton = [[UIButton alloc] init];
    [self.view addSubview:self.yesButton];
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.yesButton.layer.cornerRadius=10.0f;
    self.yesButton.layer.masksToBounds=YES;
    [self.yesButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Send!" attributes:nil] forState:UIControlStateNormal];
    self.yesButton.titleLabel.textColor=[UIColor whiteColor];
    [self.yesButton addTarget:self action:@selector(yesButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.yesButton addTarget:self action:@selector(yesButtonNormal) forControlEvents:UIControlEventTouchDown];

    self.yesButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    NSLayoutConstraint *yesButtonTop = [NSLayoutConstraint constraintWithItem:self.yesButton
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:-56.0];
    
    NSLayoutConstraint *yesButtonBottom = [NSLayoutConstraint constraintWithItem:self.yesButton
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:-4.0];
    
    NSLayoutConstraint *yesButtonWidth = [NSLayoutConstraint constraintWithItem:self.yesButton
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:0.5
                                                                       constant:-6.0];
    
    NSLayoutConstraint *yesButtonRight = [NSLayoutConstraint constraintWithItem:self.yesButton
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:-4.0];
    
    [self.view addConstraints:@[yesButtonTop, yesButtonBottom, yesButtonWidth, yesButtonRight]];
}

- (void)yesButtonTapped
{
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.yesButton.titleLabel.textColor=[UIColor whiteColor];
    
    UIImage* mapImage = [self imageWithView:self.mapView];

    [self dismissViewControllerAnimated:YES completion:^{
        [self sendMapImage:mapImage];
        
    }];
}
-(void) sendMapImage:(UIImage*)map
{
    NSString* photoInString = [self imageToNSString:map];
    
    [self.chatRoom.firebase setValue:@{@"user":self.user.name,
                                       @"map":photoInString}];
}
-(NSString *)imageToNSString:(UIImage *)image{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1); //UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

-(void)yesButtonNormal
{
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.016 green:0.341 blue:0.22 alpha:1];
}

-(void) setUpNoButton
{
    self.noButton = [[UIButton alloc] init];
    [self.view addSubview:self.noButton];
    self.noButton.backgroundColor=[UIColor redColor];
    self.noButton.layer.cornerRadius=10.0f;
    self.noButton.layer.masksToBounds=YES;
    [self.noButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel" attributes:nil] forState:UIControlStateNormal];
    self.noButton.titleLabel.textColor=[UIColor whiteColor];
        [self.noButton addTarget:self action:@selector(noButtonNormal) forControlEvents:UIControlEventTouchDown];
        [self.noButton addTarget:self action:@selector(noButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.noButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    NSLayoutConstraint *noButtonTop = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-56.0];
    
    NSLayoutConstraint *noButtonBottom = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-4.0];
    
    NSLayoutConstraint *noButtonWidth = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:0.5
                                                                       constant:-6.0];
    
    NSLayoutConstraint *noButtonLeft = [NSLayoutConstraint constraintWithItem:self.noButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:4.0];
    
    [self.view addConstraints:@[noButtonTop, noButtonBottom, noButtonWidth, noButtonLeft]];
}

- (void)noButtonTapped
{
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.027 green:0.58 blue:0.373 alpha:1];
    self.yesButton.titleLabel.textColor=[UIColor whiteColor];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)noButtonNormal
{
    self.yesButton.backgroundColor=[UIColor colorWithRed:0.016 green:0.341 blue:0.22 alpha:1];
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
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
