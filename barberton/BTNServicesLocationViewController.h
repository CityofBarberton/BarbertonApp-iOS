//
//  BTNServicesLocationViewController.h
//  barberton
//
//  Created by Christopher Stoll on 1/14/14.
//  Copyright (c) 2014 Christopher Stoll. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BTNServicesLocationViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)saveLocation:(id)sender;

@end
