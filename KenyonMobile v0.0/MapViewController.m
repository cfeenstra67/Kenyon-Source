//
//  MapViewController.m
//  KenyonMobile v0.0
//
//  Created by Cameron Feenstra on 6/18/16.
//  Copyright © 2016 Cameron Feenstra. All rights reserved.
//

#import "MapViewController.h"
#import "buildingSelectionViewController.h"

@interface MapViewController () {
    CLLocationManager *loc;
    BOOL trackHeading;
    BOOL regionChanging;
    
    CLHeading *old;
    
    BOOL resultsFullFrame;
}
@end

@implementation MapViewController {
}

- (void)viewDidLoad {
    resultsFullFrame=NO;
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    MKMapCamera *camera=[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.375844, -82.396818) fromDistance:2769.781106 pitch:0 heading:0];
    loc=[[CLLocationManager alloc] init];
    [loc requestWhenInUseAuthorization];
    [loc startUpdatingLocation];
    [loc startUpdatingHeading];
    [loc setDelegate:self];
    [_mapView setCamera:camera animated:NO];
    //_mapView.myLocationEnabled=YES;
    _mapView.mapType=MKMapTypeSatellite;
    _mapView.rotateEnabled=NO;
    [_mapView setShowsPointsOfInterest:NO];
    //_mapView.showsUserLocation=YES;
    _tableHeight.constant=0;
    _tableMaxHeight=200;
    //_mapView.styleURL=[NSURL URLWithString:@"mapbox://styles/mapbox/satellite-v9"];
    [self configureView];
    //kenyonPurple=[UIColor colorWithRed:(117/255) green:(59/255) blue:(189/255) alpha:1];
    //kenyonPurple=[self.view backgroundColor];
    _kenyonpurple=[UIColor colorWithRed:.458824 green:.231373 blue:.741176 alpha:1];
    trackHeading=NO;
    regionChanging=NO;
    
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.translatesAutoresizingMaskIntoConstraints=YES;
    [self.navigationController.view bringSubviewToFront:_searchBar];
    [self.view sendSubviewToBack:_mapView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [loc stopUpdatingHeading];
        [loc stopUpdatingLocation];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        [loc startUpdatingHeading];
        [loc startUpdatingLocation];
        _mapView.showsUserLocation=YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status==kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        _mapView.showsUserLocation=YES;
        [loc startUpdatingHeading];
        [loc startUpdatingLocation];
    }
    else
    {
        _mapView.showsUserLocation=NO;
        [loc stopUpdatingLocation];
        [loc stopUpdatingHeading];
    }
}

-(void)locationManager:(CLLocationManager*)locationManager didUpdateHeading:(nonnull CLHeading *)newHeading
{
    if(trackHeading&(fabs([old trueHeading]-[newHeading trueHeading])>2)&(!regionChanging))
    {
        MKMapCamera *cam=[_mapView.camera copy];
        [cam setHeading:[newHeading trueHeading]];
        [_mapView setCamera:cam animated:NO];
        old=newHeading;
    }
    //old=newHeading;
}



-(void)configureView
{
    NSMutableArray* temp=[[NSMutableArray alloc] init];
    MKPointAnnotation* test=[[MKPointAnnotation alloc] init];
    [test setCoordinate:CLLocationCoordinate2DMake(40.371342, -82.397264)];
    [temp addObject:test];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.371342, -82.397264) title:@"Old Kenyon"];
    
    [temp addAnnotation:CLLocationCoordinate2DMake(40.371974, -82.396741) title:@"Leonard Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372009, -82.397768) title:@"Hanna Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372650, -82.398082) title:@"Higley Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.369478, -82.397703) title:@"Maintenance Buildings"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.370576, -82.397324) title:@"Taft Cottages"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.371034, -82.397728) title:@"Manning Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.370977, -82.396791) title:@"Bushnell Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372031, -82.395652) title:@"Bolton Theater"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372405, -82.395638) title:@"Shaffer Speech Building"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.371566, -82.395062) title:@"Bolton Dance Studio"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372934, -82.398572) title:@"Tomsich Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.373264, -82.398326) title:@"Hayes Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372975, -82.397731) title:@"Samuel Mather Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372936, -82.396752) title:@"Ascension Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374033, -82.399514) title:@"Horovitz Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374795, -82.399313) title:@"Sunset Cottage"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.375199, -82.399022) title:@"Bailey House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.373760, -82.398194) title:@"Storer Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.373750, -82.397885) title:@"Rosse Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374394, -82.397664) title:@"Chalmers Library"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374421, -82.398067) title:@"Olin Library"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374824, -82.397954) title:@"Gund Gallery"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.375198, -82.398061) title:@"Cromwell Cottage"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.375592, -82.398611) title:@"Lentz House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374377, -82.396611) title:@"Ransom Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374286, -82.396431) title:@"Stephens Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374987, -82.396670) title:@"Church of the Holy Spirit"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.373584, -82.395602) title:@"Peirce Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.373618, -82.395412) title:@"Dempsey Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374319, -82.395545) title:@"Horn Gallery"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374631, -82.395787) title:@"Edelstein House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374855, -82.395787) title:@"Timberlake House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.375081, -82.395830) title:@"Horvitz House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.375342, -82.395806) title:@"O'Connor House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.375629, -82.395765) title:@"Seitz House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.375611, -82.395488) title:@"Acland House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374660, -82.394884) title:@"Acland Street Apartments"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.374017, -82.394501) title:@"Morgan Apartments"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372907, -82.391378) title:@"Gambier Child Care Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.373615, -82.391160) title:@"Gambier Community Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.370629, -82.392794) title:@"Kenyon Athletic Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.372291, -82.392553) title:@"McBride Field"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.369153, -82.390758) title:@"Tennis Courts"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.370052, -82.391119) title:@"Village Maintenance Building"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.366802, -82.390818) title:@"Soccer Field"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.365488, -82.390619) title:@"Baseball Field"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.375656, -82.391858) title:@"Phi Kappa Sigma"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376432, -82.400180) title:@"Ralston House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376469, -82.399214) title:@"Palme House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377203, -82.399325) title:@"Parish House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377162, -82.398987) title:@"Davis House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376391, -82.398357) title:@"Finn House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376369, -82.397811) title:@"Kenyon Inn"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376735, -82.397978) title:@"Weather Vane"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376676, -82.397745) title:@"Campus Safety"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376691, -82.397443) title:@"College Relations Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377165, -82.398284) title:@"Treelaven House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376979, -82.397967) title:@"Health and Counseling Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377248, -82.397982) title:@"Rothenberg Hillel House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377223, -82.397778) title:@"Campus Auto & Fuel"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377010, -82.397446) title:@"Post Office"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377279, -82.397428) title:@"Black Box Theater"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376140, -82.396652) title:@"Wiggins Street Coffee"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376307, -82.396567) title:@"Edwards House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376499, -82.396497) title:@"Village Inn"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376170, -82.396203) title:@"Peoples Bank"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376078, -82.395788) title:@"Crozier Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376126, -82.395443) title:@"Gambier House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376534, -82.395405) title:@"Head Quarters"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377022, -82.396650) title:@"Farr Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377214, -82.396614) title:@"Village Market"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377083, -82.396643) title:@"Gambier Deli"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376830, -82.396625) title:@"Kenyon College Bookstore"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.376744, -82.395463) title:@"Wilson Apartments"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377886, -82.397948) title:@"Lewis Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.378269, -82.398432) title:@"Gund Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.378596, -82.397904) title:@"Norton Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.379313, -82.397640) title:@"Watson Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.379955, -82.397560) title:@"Hoehn-Saric House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.380347, -82.397946) title:@"Eaton Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.380811, -82.398036) title:@"Snowden Multicultural Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.377917, -82.395862) title:@"Gund Commons"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.378387, -82.396325) title:@"McBride Residence"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.379085, -82.396460) title:@"Weaver Cottage"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.378857, -82.395698) title:@"Mather Residence"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.379571, -82.395786) title:@"Caples Residence"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.380116, -82.395685) title:@"Sparrow House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.379586, -82.394847) title:@"Allen House"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.380105, -82.394666) title:@"North Campus Apartments"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.380821, -82.395276) title:@"Craft Center"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.381612, -82.402577) title:@"Psi Upsilon"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.380997, -82.400513) title:@"Delta Kappa Epsilon"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.380942, -82.399573) title:@"Delta Tau Delta"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.381417, -82.398824) title:@"Alpha Delta Phi"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.381592, -82.398135) title:@"Ganter Price Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.381130, -82.396787) title:@"Bexley Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.381320, -82.396773) title:@"Colburn Hall"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.381403, -82.394328) title:@"New Apartments"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.381779, -82.409762) title:@"Franklin Miller Observatory"];
    [temp addAnnotation:CLLocationCoordinate2DMake(40.373593, -82.406245) title:@"Brown Family Environmental Center"];

    //[self.view bringSubviewToFront:_resultTable];
    [_mapView addAnnotations:temp];
    //[self.view bringSubviewToFront:_refreshbutton];
    //[self.view bringSubviewToFront:_deleteButton];
    [self.view bringSubviewToFront:_searchBar];
    [_deleteButton setHidden:YES];
    [_pinButton setHidden:YES];
    [self.view layoutSubviews];
    [self.view sendSubviewToBack:_mapView];
    [_mapView setShowsScale:YES];
    [_refreshbutton setTintColor:_kenyonpurple];
    [_refreshbutton.imageView setTintColor:_kenyonpurple];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    if([[annotation subtitle] isEqualToString:@"Added Pin"])
    {
        MKPinAnnotationView *new= [[MKPinAnnotationView alloc] init];
        [new setCanShowCallout:YES];
        [new setAnimatesDrop:YES];
        [new setTintColor:_kenyonpurple];
        [new setPinTintColor:[UIColor whiteColor]];
        return new;
    }
    if(!NO)
    {
        MKAnnotationView *annView=[[MKAnnotationView alloc] initWithAnnotation:annotation   reuseIdentifier:@"buildingmarker"];
        annView.image=[UIImage imageNamed:@"circle2.png"];
        CGFloat scale=4;
        annView.frame=CGRectMake(annView.frame.origin.x, annView.frame.origin.y, annView.frame.size.width/scale, annView.frame.size.height/scale);
    
        //MKAnnotationView *markerView=[mapView dequeueReusableAnnotationViewWithIdentifier:@"buildingmarker"];
        //markerView.annotation=annotation;
        [annView setCanShowCallout:YES];
        [annView setTintColor:[UIColor colorWithRed:.458824 green:.231373 blue:.741176 alpha:1]];
        return annView;
    }
    else
    {
        return nil;
    }
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    UIButton *rightbutton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightbutton setImage:[UIImage imageNamed:@"pin2.png"] forState:UIControlStateNormal];
    NSUInteger selectedIndex=[[_mapView annotations] indexOfObject:view.annotation];
    rightbutton.tag=selectedIndex;
    for(id<MKAnnotation> ann in [_mapView annotations])
    {
        if(([view. annotation coordinate].latitude==[ann coordinate].latitude)&([view.annotation coordinate].latitude==[ann coordinate].latitude)&([[_mapView annotations] indexOfObject:ann]!=selectedIndex))
        {
            rightbutton.tag=[[_mapView annotations] indexOfObject:ann];
        }
    }
    [rightbutton addTarget:self action:@selector(annotationPinDrop:) forControlEvents:UIControlEventTouchUpInside];
    view.rightCalloutAccessoryView=rightbutton;

}

-(IBAction)annotationPinDrop:(id)sender
{
    UIButton *clicked=(UIButton *)sender;
    buildingAnnotation *selected=[[_mapView annotations] objectAtIndex:clicked.tag];
    BOOL alreadyThere=NO;
    id<MKAnnotation> found;
    for(id<MKAnnotation> annot in [_mapView annotations])
    {
        if(([[annot subtitle] isEqualToString:@"Added Pin"])&(([annot coordinate].latitude==selected.coordinate.latitude)&([annot coordinate].longitude==selected.coordinate.longitude)))
        {
            found=annot;
            alreadyThere=YES;
        }
    }
    if(!alreadyThere)
    {
        [_mapView deselectAnnotation:selected animated:YES];
        MKPointAnnotation *newPoint=[[MKPointAnnotation alloc] init];
        [newPoint setCoordinate:selected.coordinate];
        [[_mapView viewForAnnotation:selected] setCanShowCallout:NO];
        [newPoint setSubtitle:@"Added Pin"];
        [newPoint setTitle:selected.title];
        [_mapView addAnnotation:newPoint];
        [_mapView bringSubviewToFront:[_mapView viewForAnnotation:newPoint]];
        if([_deleteButton isHidden])
        {
            [UIView transitionWithView:_deleteButton duration:.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [_deleteButton setHidden:NO];
                [_pinButton setHidden:NO];
            }completion:NULL];
        }
        
    }
    else
    {
        [[_mapView viewForAnnotation:selected] setCanShowCallout:YES];
        [_mapView deselectAnnotation:found animated:NO];
        [_mapView removeAnnotation:found];
        BOOL others=NO;
        for(MKPointAnnotation *point in [_mapView annotations])
        {
            if([[_mapView viewForAnnotation:point] isKindOfClass:[MKPinAnnotationView class]])
            {
                others=YES;
                break;
            }
        }
        if(!others)
        {
            [UIView transitionWithView:_pinButton duration:.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [_pinButton setHidden:YES];
                [_deleteButton setHidden:YES];
            }completion:NULL];
            [self dismissTable];
        }
        
    }
    
}

-(void)mapView:(MKMapView*)mapView regionWillChangeAnimated:(BOOL)animated
{
    regionChanging=YES;
}

-(void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
    CGFloat minwidth=500;
    if(_mapView.camera.altitude<minwidth)
    {
        //[mapView setRegion:MKCoordinateRegionMake(mapView.region.center, MKCoordinateSpanMake(minwidth*(mapView.region.span.latitudeDelta/mapView.region.span.longitudeDelta), minwidth)) animated:YES];
        MKMapCamera *temp=[_mapView.camera copy];
        [temp setAltitude:500];
        [_mapView setCamera:temp animated:YES];
    }
    [mapView setUserInteractionEnabled:YES];
    regionChanging=NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)mapView:(MKMapView*)mapView didSelectAnnotation:(nonnull id<MKAnnotation>)annotation
{
    
}

- (IBAction)refresh:(id)sender {
    //[_mapView setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.375844, -82.396818) fromDistance:2769.781106 pitch:0 heading:0 animated:YES]];
    [_mapView setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.375844, -82.396818) fromDistance:2769.781106 pitch:0 heading:0] animated:YES];
}


- (IBAction)getFrame:(id)sender {
    //NSLog(@"center:%f, %f h:%f p:%f a:%f",_mapView.camera.centerCoordinate.latitude,_mapView.camera.centerCoordinate.longitude,_mapView.camera.heading,_mapView.camera.pitch, _mapView.camera.altitude);
    [self.view endEditing:YES];
    [_mapView becomeFirstResponder];
    for(UIGestureRecognizer *gesture in [_mapView gestureRecognizers])
    {
        [gesture setEnabled:YES];
    }

    if(_tableHeight.constant>0)
    {
        [self dismissTable];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_mapView setUserInteractionEnabled:NO];
    [_mapView setSelectedAnnotations:[[NSArray alloc] init]];
    
    _searchResults=[self searchResultsForSearchString:searchBar.text];
    [self sortSearchResults];
    if(_searchResults.count<=1)
    {
        [self.view endEditing:YES];
        if(_searchResults.count==0)
        {
            _searchBar.text=nil;
            return;
        }
        [self fadeResultsOutToHeight:0.0f];
        [_mapView selectAnnotation:[_searchResults firstObject] animated:YES];
        [self centerCameraCloseAtLocation:[[_searchResults firstObject] coordinate]];
        _tableHeight.constant=0;
        [self.view layoutSubviews];
        _searchBar.text=nil;
    }
    else
    {
        [_mapView resignFirstResponder];
        [self fadeResultsOutToHeight:_tableMaxHeight];
        MKMapCamera *camera=[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.371742, -82.396974) fromDistance:4311.327057 pitch:0 heading:_mapView.camera.heading];
        [_mapView setCamera:camera animated:YES];
        [self.view endEditing:YES];
    }
    
}

-(NSArray*)searchResultsForSearchString:(NSString*)searchString
{
    NSMutableArray *nameHits=[[NSMutableArray alloc] init];
    NSDictionary *buildingCodes=[NSDictionary getSearchHelperDictionary];
    for(id<MKAnnotation> annotation in _mapView.annotations)
    {
        if([[annotation title] localizedCaseInsensitiveContainsString:searchString])
        {
            [nameHits addObject:annotation];
        }
    }
    for(NSString* string in [buildingCodes allKeys])
    {
        if([searchString caseInsensitiveCompare:string]==NSOrderedSame)
        {
            for(id<MKAnnotation> annotation in _mapView.annotations)
            {
                if([[annotation title] isEqualToString:[buildingCodes objectForKey:string]])
                {
                    [nameHits addObject:annotation];
                }
            }
        }
    }
    return [NSArray arrayWithArray:nameHits];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _searchResults=[[NSArray alloc] init];
    [_mapView deselectAnnotation:[_mapView.selectedAnnotations firstObject] animated:YES];
    //MKMapCamera *camera=[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.369589, -82.396923) fromDistance:5597.485133 pitch:0 heading:0];
    //[_mapView setCamera:camera animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchResults=[self searchResultsForSearchString:searchText];
    [_resultTable reloadData];
    if([searchText isEqualToString:@""]&&resultsFullFrame)
    {
        [self fadeResultsOutToHeight:0.0f];
    }
    else if(!resultsFullFrame&&![searchText isEqualToString:@""])
    {
        [self fadeResultsIn];
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

-(void)fadeResultsIn
{
    if(resultsFullFrame)
    {
        return;
    }
    [_resultTable setAlpha:0.0f];
    [self.view bringSubviewToFront:_resultTable];
    _tableHeight.constant=_mapView.frame.size.height;
    [self.view layoutIfNeeded];
    [_resultTable setFrame:_mapView.frame];
    [UIView animateWithDuration:.25 animations:^{
        [_resultTable setAlpha:1.0f];
        resultsFullFrame=YES;
    }];
    
}

-(void)fadeResultsOutToHeight:(CGFloat)endHeight
{
    if(!resultsFullFrame)
    {
        return;
    }
    if(endHeight>0)
    {
        [UIView animateWithDuration:.25 animations:^{
            [_resultTable setFrame:CGRectMake(_resultTable.frame.origin.x, _resultTable.frame.origin.y+_resultTable.frame.size.height-endHeight, _resultTable.frame.size.width, endHeight)];
        }completion:^(BOOL finished){
            resultsFullFrame=NO;
            _tableHeight.constant=endHeight;
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        [UIView animateWithDuration:.25 animations:^{
            [_resultTable setAlpha:0.0f];
        }completion:^(BOOL finished){
            resultsFullFrame=NO;
            _tableHeight.constant=endHeight;
            [self.view layoutIfNeeded];
        }];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_searchResults.count<1)
    {
        return 0;
    }
    else
    {
        return _searchResults.count;
        
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    cell.textLabel.text=[[_searchResults objectAtIndex:indexPath.row] title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self fadeResultsOutToHeight:0.0f];
    if(_searchBar.isFirstResponder)
    {
        [_searchBar setText:@""];
        [_searchBar endEditing:YES];
    }
    [_mapView selectAnnotation:[_searchResults objectAtIndex:indexPath.row]animated:YES];
    [self centerCameraCloseAtLocation:[[_searchResults objectAtIndex:indexPath.row] coordinate]];
    
}

-(void)centerCameraCloseAtLocation:(CLLocationCoordinate2D)location
{
    [_mapView setCamera:[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(location.latitude-.0005, location.longitude) fromDistance:1000 pitch:0 heading: _mapView.camera.heading] animated:YES];
}

- (IBAction)deletePins:(id)sender {
    if((_tableHeight.constant>0)&([[_mapView viewForAnnotation:[_searchResults firstObject]] isKindOfClass:[MKPinAnnotationView class]]&((_searchResults.count==1)||([[_mapView viewForAnnotation:[_searchResults objectAtIndex:1]] isKindOfClass:[MKPinAnnotationView class]]))))
    {
        [_mapView deselectAnnotation:[[_mapView selectedAnnotations] firstObject] animated:NO];
        [self dismissTable];
    }
    for(MKPointAnnotation *ann in [_mapView annotations])
    {
        [[_mapView viewForAnnotation:ann] setCanShowCallout:YES];
        if([[_mapView viewForAnnotation:ann] isKindOfClass:[MKPinAnnotationView class]])
        {
            [_mapView removeAnnotation:ann];
        }
    }
    [UIView transitionWithView:_pinButton duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [_pinButton setHidden:YES];
        [_deleteButton setHidden:YES];
    }completion:NULL];
}

- (IBAction)compassButton:(id)sender {
    if(trackHeading)
    {
        //[_mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
        MKMapCamera *temp=[_mapView.camera copy];
        temp.heading=0;
        [_mapView setCamera:temp animated:YES];
        //[_mapView.camera setHeading:0];
        trackHeading=NO;
    }
    else
    {
        //[_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
        //[_mapView setShowsCompass:NO];
        MKMapCamera *temp=[_mapView.camera copy];
        temp.heading=[[loc heading] trueHeading];
        [_mapView setCamera:temp animated:YES];
        trackHeading=YES;
    }
        
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)showPinTable:(id)sender {
    if((_tableHeight.constant>0)&([[_mapView viewForAnnotation:[_searchResults firstObject]] isKindOfClass:[MKPinAnnotationView class]]&((_searchResults.count==1)||([[_mapView viewForAnnotation:[_searchResults objectAtIndex:1]] isKindOfClass:[MKPinAnnotationView class]]))))
    {
        [self dismissTable];
        return;
    }
    MKMapCamera *camera=[MKMapCamera cameraLookingAtCenterCoordinate:CLLocationCoordinate2DMake(40.371742, -82.396974) fromDistance:4311.327057 pitch:0 heading:_mapView.camera.heading];
    [_mapView setCamera:camera animated:YES];
    NSMutableArray *pins=[[NSMutableArray alloc] init];
    for(MKPointAnnotation *ann in [_mapView annotations])
    {
        if([[_mapView viewForAnnotation:ann] isKindOfClass:[MKPinAnnotationView class]])
        {
            [pins addObject:ann];
        }
    }
    _searchResults=[NSArray arrayWithArray:pins];
    [self sortPinResults];
    [_resultTable reloadData];
    _searchBar.text=nil;
    [self.view endEditing:YES];
    if(_tableHeight.constant==0)
    {
        [self showTable];
    }
}

-(void)showTable
{
    _tableHeight.constant=_tableMaxHeight;
    [_resultTable setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.view.frame.size.height, _resultTable.frame.size.width, _tableHeight.constant)];
    [UIView transitionWithView:_resultTable duration:.25 options: UIViewAnimationOptionTransitionNone animations:^{
        [_resultTable setFrame:CGRectMake(_resultTable.frame.origin.x, _resultTable.frame.origin.x-_tableHeight.constant, _resultTable.frame.size.width, _tableHeight.constant)];
    }completion:NULL];
}

-(void)dismissTable
{
    /*[UIView animateWithDuration:.25 animations:^{
        [_resultTable setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.view.frame.size.height, _resultTable.frame.size.width, 0)];
        //[_mapView setFrame:CGRectMake(_mapView.frame.origin.x, _mapView.frame.origin.y, _mapView.frame.size.width, _mapView.frame.size.height+_tableMaxHeight)];
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finish)
     {
         _tableHeight.constant=0;
     }];*/
    _searchBar.text=nil;
    [UIView animateKeyframesWithDuration:.4 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:.25 animations:^{
            _tableHeight.constant=0;
            [self.view layoutIfNeeded];
        }];
    }completion:NULL];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)sortSearchResults
{
    NSSet <id<MKAnnotation>> *noDups=[NSSet setWithArray:_searchResults];
    NSMutableArray <id<MKAnnotation>> *minusPins=[[NSMutableArray alloc] initWithArray:[noDups allObjects]];
    NSMutableArray <MKPointAnnotation *> *pins=[[NSMutableArray alloc] init];
    NSMutableArray <NSString*> *names=[[NSMutableArray alloc] init];
    for(MKPointAnnotation *ann in minusPins)
    {
        if([ann.subtitle isEqualToString:@"Added Pin"])
        {
            [pins addObject:ann];
        }
        
    }
    for(MKPointAnnotation *pin in pins)
    {
        for(MKPointAnnotation *ann in minusPins)
        {
            if(([ann.title isEqualToString:pin.title])&(![ann.subtitle isEqualToString:pin.subtitle]))
            {
                [minusPins removeObject:ann];
                break;
            }
        }
    }
    for(MKPointAnnotation *ann in minusPins)
    {
        [names addObject:ann.title];
    }
    NSMutableArray <id<MKAnnotation>> *final=[[NSMutableArray alloc] initWithArray:minusPins];
    [names sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for(MKPointAnnotation *ann in minusPins)
    {
        final[[names indexOfObject:ann.title]]=ann;
    }
    _searchResults=[NSArray arrayWithArray:final];
}

-(void)sortPinResults
{
    NSMutableArray <id<MKAnnotation>> *final=[[NSMutableArray alloc] initWithArray:_searchResults];
    NSMutableArray<NSString*> *names=[[NSMutableArray alloc] init];
    for(id<MKAnnotation> ann in final)
    {
        [names addObject:[ann title]];
    }
    [names sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray <id<MKAnnotation>> *temp=[[NSArray alloc] initWithArray:final];
    for(id<MKAnnotation> ann in temp)
    {
        final[[names indexOfObject:ann.title]]=ann;
    }
    _searchResults=[NSArray arrayWithArray:final];
}

- (IBAction)backPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"toMain"])
    {
        _mapView.mapType=MKMapTypeStandard;
    }
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue*)segue
{
    buildingSelectionViewController *prev=[segue sourceViewController];
    _searchBar.text=prev.picked;
    [self searchBarSearchButtonClicked:_searchBar];
    [_mapView setUserInteractionEnabled:YES];
    [_mapView becomeFirstResponder];
}


@end





























