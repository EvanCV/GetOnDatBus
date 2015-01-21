//
//  ViewController.m
//  GetOnDatBus
//
//  Created by Evan Vandenberg on 1/20/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "MapViewController.h"
#import "BusStopDetails.h"
#import "CustomAnnotation.h"
#import "DetailViewController.h"
#import <MapKit/MapKit.h>


@interface MapViewController () <MKMapViewDelegate>

@property NSString *urlString;
@property NSMutableArray *transportationWebDataArray;
@property NSMutableArray *busStopDetailsArray;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.busStopDetailsArray =[NSMutableArray new];
    self.urlString = @"https://s3.amazonaws.com/mobile-makers-lib/bus.json";
    [self pullDataFromTrainSite:self.urlString];
    //[self mapView:self.mapView regionWillChangeAnimated:YES];
}


-(void)pullDataFromTrainSite :(NSString *)webURL
{
    NSURL *url = [NSURL URLWithString:webURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        [self downloadComplete:data];
    }];
}


-(void)downloadComplete:(NSData *)data
{
    // called when done with connection
    NSDictionary *pullWebDataDict = [NSDictionary new];
    pullWebDataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.transportationWebDataArray = [pullWebDataDict objectForKey:@"row"];

    for (NSDictionary *searchDict in self.transportationWebDataArray)
    {
        BusStopDetails *busDetails = [BusStopDetails new];

        busDetails.busStopID = searchDict[@"_id"];
        busDetails.busTransfers = searchDict[@"routes"];
        busDetails.intermodalTransfers = searchDict[@"inter_modal"];
        busDetails.stopLatitude = searchDict[@"latitude"];
        busDetails.stopLongitude = searchDict[@"longitude"];
        busDetails.busStopWebAddress = searchDict[@"_address"];
        busDetails.busStopName = searchDict[@"cta_stop_name"];

        [self.busStopDetailsArray addObject:busDetails];
    }

    [self placePinOnCoordinateLocations];

    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(41.878, -87.633);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.45, 0.45);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
}


//Place a pin at each stops coordinates
-(void)placePinOnCoordinateLocations
{
    for (BusStopDetails *details in self.busStopDetailsArray)
    {
        CLLocationCoordinate2D  ctrpoint;
        ctrpoint.latitude = [details.stopLatitude doubleValue];
        ctrpoint.longitude = [details.stopLongitude doubleValue];

        //Set public property from CustomAnnotation class
        CustomAnnotation *annotation = [CustomAnnotation new];
        annotation.busStopAnnotation = details;
        [self.mapView addAnnotation:annotation];
        annotation.coordinate = ctrpoint;
        annotation.title = details.busStopName;
        annotation.subtitle = details.busTransfers;
    }
}


//Set accessory button when pin is clicked
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    CustomAnnotation *customAnnotation = annotation;
    if ([customAnnotation.busStopAnnotation.intermodalTransfers isEqualToString:@"Metra"])
    {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
    if ([customAnnotation.busStopAnnotation.intermodalTransfers isEqualToString:@"Pace"])
    {
        pin.pinColor = MKPinAnnotationColorGreen;
    }

        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        return pin;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CustomAnnotation *annotation = view.annotation;
    [self performSegueWithIdentifier:@"DetailViewController" sender:annotation.busStopAnnotation];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *vc = segue.destinationViewController;
    vc.busStopAnnotation = sender;
    NSLog(@"Bus Stop AnnontE %@", vc.busStopAnnotation);
}


    

@end
