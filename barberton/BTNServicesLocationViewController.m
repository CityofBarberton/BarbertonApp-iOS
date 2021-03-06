//
//  BTNServicesLocationViewController.m
//  barberton
//
//  Created by Christopher Stoll on 1/14/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import "BTNServicesLocationViewController.h"
#import "BTNPlist.h"

@interface BTNServicesLocationViewController ()
@property NSNumber *locationLat;
@property NSNumber *locationLon;
@property BOOL useUserLocation;
@end

@implementation BTNServicesLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self getLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.useUserLocation) {
        [self zoomToUser];
    }
}

- (void)getLocation {
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    NSMutableDictionary *issueDict = [[NSMutableDictionary alloc] initWithDictionary:sharedPlist.currentIssue];
    
    self.locationLat = issueDict[@"lat"];
    self.locationLon = issueDict[@"lon"];
    
    if (([self.locationLat floatValue] == 0) && ([self.locationLon floatValue] == 0)) {
        self.useUserLocation = YES;
        [self zoomToUser];
    } else {
        self.useUserLocation = NO;
        [self dropPinAndZoom];
    }
}

- (void)dropPinAndZoom {
    // drop pin
    CLLocationCoordinate2D  locationCoordinate;
    locationCoordinate.latitude = [self.locationLat floatValue];
    locationCoordinate.longitude = [self.locationLon floatValue];
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = locationCoordinate;
    [self.mapView addAnnotation:pointAnnotation];
    
    // zoom
    MKCoordinateRegion mapRegion;
    mapRegion.center = locationCoordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:mapRegion animated: YES];
}

- (void)zoomToUser {
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    
    if ((self.mapView.userLocation.coordinate.latitude == 0) && (self.mapView.userLocation.coordinate.longitude == 0)) {
        // given no other location, put them in Lake Anna
        mapRegion.center.latitude = 41.015;
        mapRegion.center.longitude = -81.6106;
    }
    
    [self.mapView setRegion:mapRegion animated: YES];
}

- (IBAction)saveLocation:(id)sender {
    BTNPlist *sharedPlist = [BTNPlist sharedPlist];
    NSMutableDictionary *issueDict = [[NSMutableDictionary alloc] initWithDictionary:sharedPlist.currentIssue];
    
    CLLocation *currentLocation = self.mapView.userLocation.location;
    NSNumber *locationLat = [[NSNumber alloc] initWithFloat:currentLocation.coordinate.latitude];
    NSNumber *locationLon = [[NSNumber alloc] initWithFloat:currentLocation.coordinate.longitude];
    
    [issueDict setValue:@"(see map)" forKey:PLIST_LOCATION];
    [issueDict setValue:locationLat forKey:PLIST_LAT];
    [issueDict setValue:locationLon forKey:PLIST_LON];
    sharedPlist.currentIssue = issueDict;
    
    [sharedPlist save];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
