//
//  DetailViewController.m
//  GetOnDatBus
//
//  Created by Evan Vandenberg on 1/20/15.
//  Copyright (c) 2015 Evan Vandenberg. All rights reserved.
//

#import "DetailViewController.h"
#import "MapViewController.h"
#import "CustomAnnotation.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *busRouteLabel;
@property (weak, nonatomic) IBOutlet UILabel *intermodalLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.busStopAnnotation.busStopName;
    self.addressLabel.text = self.busStopAnnotation.busStopWebAddress;
    self.busRouteLabel.text = self.busStopAnnotation.busTransfers;
    self.intermodalLabel.text = self.busStopAnnotation.intermodalTransfers;
}

-(void)uploadDataToDetailView
{

}

@end
