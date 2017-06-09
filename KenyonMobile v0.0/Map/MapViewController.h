//
//  MapViewController.h
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 6/18/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "buildingAnnotation.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)refresh:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *refreshbutton;

- (IBAction)getFrame:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *resultTable;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSArray<id<MKAnnotation>> *searchResults;

@property NSUInteger tableMaxHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@property(weak, nonatomic) UITapGestureRecognizer *tapAnnotationView;

-(void)centerCameraCloseAtLocation:(CLLocationCoordinate2D)location;

@property (weak, nonatomic) IBOutlet UIView *deleteButton;

- (IBAction)deletePins:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *compassButton;

- (IBAction)compassButton:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (strong, nonatomic) UIColor *kenyonpurple;

@property (weak, nonatomic) IBOutlet UIView *pinButton;

- (IBAction)showPinTable:(id)sender;

-(void)showTable;

-(void)dismissTable;

-(void)sortSearchResults;

-(void)sortPinResults;
- (IBAction)backPressed:(id)sender;

@end
