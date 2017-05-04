//
//  trafficMapViewController.m
//  JeTT
//
//  Created by Matthew Price on 3/27/2014.
//  Copyright (c) 2014 Matthew Price. All rights reserved.
//

#import "trafficMapViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "TFHpple.h"
#import "Traffic.h"




@interface trafficMapViewController ()


@end

@implementation trafficMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    [self loadTraffic];
    [self currentLocation];
    
}


-(void)currentLocation {
    
    float spanX = 0.10725;
    float spanY = 0.10725;
    self.location = self.locationManager.location;
    NSLog(@"%@", self.location.description); //A quick NSLog to show us that location data is being received.
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
    // [self reverseGeocode:self.location];
    //  [self forwardGeocode];
    
    
    
}

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            //          self.myAddress.text = [NSString stringWithFormat:@"%@", ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO)];
        }
    }];
}

- (void)forwardGeocode {
    
    NSString *testAddress = @"100-200 CENTREPOINTE DR OTTAWA ONTARIO";
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:testAddress completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            float spanX = 0.10725;
            float spanY = 0.10725;
            MKCoordinateRegion region;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            region.span = MKCoordinateSpanMake(spanX, spanY);
            [self.mapView setRegion:region animated:YES];
        }
    }];
}

-(void)loadTraffic {
    
    NSLog(@"loading");
    
    // identify the source
    
    NSURL *trafficUrl = [NSURL URLWithString:@"http://traffic.esolutionsgroup.ca"];
    NSData *trafficHtmlData = [NSData dataWithContentsOfURL:trafficUrl];
    
    // send to hpple to parse
    
    TFHpple *trafficParser = [TFHpple hppleWithHTMLData:trafficHtmlData];
    
    //identify html path for xpath string
    
    NSString *trafficXpathQueryString =@"//tr/td";
    NSArray *trafficNodes = [trafficParser searchWithXPathQuery:trafficXpathQueryString];
    
    // create a mutable array
    
    NSMutableArray *newTraffic = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in trafficNodes) {
        
        Traffic *traffic = [[Traffic alloc] init];
        [newTraffic addObject:traffic];
        
        traffic.title = [[element firstChild] content];
        
        NSLog(@"title is: %@", [traffic.title description]);
        

        
        
        // this is a loop creating an object for each entry found. Could potentially use this code and insert maps right into here to have it create a pin as it creates an entry...
        
        //Here we eliminate the / - issue
        
        NSString *trafficAddress = [traffic.title stringByAppendingString:@"Ottawa, Ontario"];
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"/"];
        trafficAddress = [[trafficAddress componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @"AND"];
        NSLog(@"%@", trafficAddress);
        
        // Since this is a loop here we attempt to have it plot multiple points
      //  NSLog(@"The count is %i", newTraffic.count);

        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:trafficAddress completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                
                
                
                CLPlacemark *placemark = [placemarks lastObject];
                
                
                float spanX = 0.20725;
                float spanY = 0.20725;
                self.location = self.locationManager.location;
                NSLog(@"%@", self.location.description); //A quick NSLog to show us that location data is being received.
                MKCoordinateRegion region;
                region.center.latitude = self.locationManager.location.coordinate.latitude;
                region.center.longitude = self.locationManager.location.coordinate.longitude;
                region.span = MKCoordinateSpanMake(spanX, spanY);
                [self.mapView setRegion:region animated:YES];
                
                /*
                 float spanX = 0.13725;
                 float spanY = 0.13725;
                 MKCoordinateRegion region;
                 region.center.latitude = placemark.location.coordinate.latitude;
                 region.center.longitude = placemark.location.coordinate.longitude;
                 region.span = MKCoordinateSpanMake(spanX, spanY);
                 [self.mapView setRegion:region animated:YES];
                 */
                // Here we plot the map points

                
                NSString* result = [trafficAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSLog(@"Result:%@", result);
                
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
                point.title = result;
              //  point.subtitle = @"Subtitle";
            
             //   NSLog(@"Subtitle is: %@", [point.subtitle description] );
                [_mapView addAnnotation:point];
                
                
            }
        }];
    }
    
    //Save the locations
    /*
    
    Traffic *trafficOne =[newTraffic objectAtIndex:0];
    NSString *pointOne =trafficOne.title;
    
    Traffic *trafficTwo = [newTraffic objectAtIndex:1];
    NSString *pointTwo =  trafficTwo.title;//
    
    NSLog(@"Point one: %@", pointOne);
    NSLog(@"Point two: %@", pointTwo);
    */
    
    /*
     
     CLGeocoder *geocoder = [[CLGeocoder alloc] init];
     [geocoder geocodeAddressString:pointTwo completionHandler:^(NSArray *placemarks, NSError *error) {
     if (error) {
     NSLog(@"%@", error);
     } else {
     CLPlacemark *placemark = [placemarks lastObject];
     float spanX = 0.00725;
     float spanY = 0.00725;
     MKCoordinateRegion region;
     region.center.latitude = placemark.location.coordinate.latitude;
     region.center.longitude = placemark.location.coordinate.longitude;
     region.span = MKCoordinateSpanMake(spanX, spanY);
     [self.mapView setRegion:region animated:YES];
     }
     }];
     
     */
    
    //TESTING
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end