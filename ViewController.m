//
//  ViewController.m
//  JeTT
//
//  Created by Matthew Price on 2013-09-05.
//  Copyright (c) 2013 Matthew Price. All rights reserved.
//

#import "ViewController.h"
#import "crimePreventionViewController.h"
#import "TFHpple.h"
#import "Traffic.h"

@interface ViewController ()

@end

@implementation ViewController

NSString *alertTitle;


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
        
        
    }
    
    // ADD This
    
    int traffic = [newTraffic count];
    [[NSUserDefaults standardUserDefaults] setInteger:traffic forKey:@"trafficCount"];
    NSLog(@"Count is: %lu", (unsigned long)traffic);
    randomButton.hidden = YES;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    [self loadTraffic];
    
}

- (IBAction)crimePreventionButton:(id)sender{
    
    crimePreventionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"crimePreventionViewController"];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)callThePolice:(id)sender {
    
    alertTitle = @"call";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call the police"
                                                    message:@"Press the corresponding number" delegate:self cancelButtonTitle: @"Dismiss"
                                          otherButtonTitles: @"911 Emergency", @"Other Emergencies",@"General Inquiries", @"CrimeStoppers",  nil];
    
    //note above delegate property
    
    [alert show];
    
}

- (IBAction)locatePolice:(id)sender{
    
    alertTitle = @"maps";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Locate the police"
                                                    message:@"Press the corresponding location" delegate:self cancelButtonTitle: @"Dismiss"
                                          otherButtonTitles: @"Police Headquarters (Elgin Street)", @"Police West (Huntmar Drive)", @"Police West (Greenbank Road)", @"Police East (Bank Street)", @"Police East (St. Joseph Boul.)", nil];
    
    //note above delegate property
    
    [alert show];
    
}

- (IBAction)sendTip:(id)sender{
    
    alertTitle = @"Send Tip";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit A Tip" message:@"How would you like to send your tip?" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Email", @"Text (Anonymous)", nil];
    
    [alert show];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    
    if (buttonIndex == 0) { // dismiss
        
        if ([alertTitle isEqual: @"call"]) {
            
            NSLog (@"call button");
            
        }else if ([alertTitle isEqualToString: @"maps"]){
            
            
            NSLog(@"maps");
        } else if ([alertTitle isEqualToString:@"Send Tip"]) {
            NSLog(@"Send Tip");
        }
        NSLog(@"button one");
        
    } if (buttonIndex == 1) { // crimestoppers
        
        NSLog(@"button two");
        
        if ([alertTitle isEqualToString:@"call"]) {
            [self call911Emergency];
            NSLog(@"calling 911");
            
        } else if ([alertTitle isEqualToString:@"maps"]){
            [self locationOne];
            
            NSLog(@"Location one");
            
        }else if ([alertTitle isEqualToString:@"Send Tip"]) {
        
            [self sendEmail];
            
            NSLog(@"sending Email");
        }
        
      
        
    } if (buttonIndex == 2) { // 911
        
        NSLog(@"button three");
        
        if ([alertTitle isEqualToString:@"call"]) {
            [self callOtherEmergencies];
            NSLog(@"Calling Other Emergencies");
            
        } else if ([alertTitle isEqualToString:@"maps"]){
            [self locationTwo];
            
            NSLog(@"Location two");
        } else if ([alertTitle isEqualToString:@"Send Tip"]) {
            [self sendSMS];
            
            NSLog(@"Sending SMS");
            
        }
    } if (buttonIndex == 3) {
        
        NSLog(@"button four");
        if ([alertTitle isEqualToString:@"maps"]) {
            [self locationThree];
            
            NSLog(@"Location three");
        } else if ([alertTitle isEqualToString:@"call"]) {
            
            [self callCentre];
            NSLog(@"calling call centre");
        }
    } if (buttonIndex == 4) {
        
        NSLog(@"button five");
        if ([alertTitle isEqualToString:@"maps"]){
            
            [self locationFour];
            
            NSLog(@"location four");
        } else if ([alertTitle isEqualToString:@"call"]) {
            
            [self callCrimeStoppers];
            NSLog(@"calling crimestoppers");
        }
    } if (buttonIndex == 5) {
        NSLog(@"button five");
        
        if ([alertTitle isEqualToString:@"maps"]){
            
            [self locationFive];
            
            NSLog(@"Location five");
        }
        
    }
    
    
    
}


-(void)locationOne {
    
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(45.412584, -75.686002);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Police Headquarters - 474 Elgin Street"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}

-(void) locationTwo {
    
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(45.294663, -75.927826);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Ottawa Police West - 211 Huntmar Drive"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }

}

- (void) locationThree {
    
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(45.325180, -75.778690);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Ottawa Police West - 245 Greenbank Road"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }

    
}

- (void) locationFour {
    
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(45.330097, -75.599329);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Ottawa Police East - 4561 Bank Street"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }

    
}

- (void) locationFive {
 
    // Check for iOS 6
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        // Create an MKMapItem to pass to the Maps app
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(45.484051, -75.499451);
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:@"Ottawa Police East - 3343 St-Joseph Boulevard"];
        
        // Set the directions mode to "Walking"
        // Can use MKLaunchOptionsDirectionsModeDriving instead
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }

    
}

-(void)callCrimeStoppers{
    
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://16132338477"]];
    
    NSLog(@"outgoing call placed");
    
}

-(void)call911Emergency{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://0987654321"]];
    
    NSLog(@"outgoing call placed");

    
}

-(void)callOtherEmergencies {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://16132306211"]];
    
    NSLog(@"outgoing call placed");
}

-(void)callCentre {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://16132361222"]];
    
    NSLog(@"outgoing call placed");
}

-(void)sendSMS {
    
    // Email Subject
    NSString *emailTitle = @"Ottawa Police Tip Submission";
    // Email Content
    NSString *messageBody = @"Insert your tip here!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@ottawapolice.ca"];
    
    MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
   
    mc.body =@"tip252: "; // SMS BODY
    mc.recipients = [NSArray arrayWithObjects:@"274637", Nil]; //SMS NUMBER
    mc.messageComposeDelegate = self;
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    }
}

-(void)sendEmail {
    
    
    // Email Subject
    NSString *emailTitle = @"Ottawa Police Tip Submission";
    // Email Content
    NSString *messageBody = @"Insert your tip here!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@ottawapolice.ca"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    
}
- (IBAction)socialButton:(id)sender {
    //have ui alert view directing to facebook/twitter page
    
    alertTitle = @"social";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ottawa Police Social Media"
                                                    message:@"Follow us on Twitter, or like us on Facebook for up to the minute social updates" delegate:self cancelButtonTitle: @"Dismiss"
                                          otherButtonTitles: @"Follow on Twitter", @"Like on Facebook", nil];
    
    //note above delegate property
    
    [alert show];


}

/*

- (void)twitterFollow{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:@"MohammadMasudRa" forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                NSLog(@"*******tempDict %@*******",tempDict);
                
                //requestForServiceType
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict];
                [postRequest setAccount:twitterAccount];
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i Error %d", [urlResponse statusCode],error.code];
                    NSLog(@"%@error %@", output,error.description);
                }];
            }
            
        }
    }];
    
}
 
 */

- (IBAction)newsButton:(id)sender{
    
    NSUserDefaults *rssFeeds = [NSUserDefaults standardUserDefaults];

    [rssFeeds setObject:@"News" forKey:@"currentFeed"];
    
    
}

- (IBAction)wanted:(id)sender{
    
    
    NSUserDefaults *rssFeeds = [NSUserDefaults standardUserDefaults];
    
    [rssFeeds setObject:@"Wanted" forKey:@"currentFeed"];

    
}
- (IBAction)submitTip:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Ottawa Police Tip Submission";
    // Email Content
    NSString *messageBody = @"Insert your tip here!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@ottawapolice.ca"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:
(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Failed");
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Wanted"]) {
        
        NSUserDefaults *rssFeeds = [NSUserDefaults standardUserDefaults];
        
        [rssFeeds setObject:@"Wanted" forKey:@"currentFeed"];
    } else if ([segue.identifier isEqualToString:@"News"]) {
        
        NSUserDefaults *rssFeeds = [NSUserDefaults standardUserDefaults];
        
        [rssFeeds setObject:@"News" forKey:@"currentFeed"];
    }
}

// add this

- (IBAction)locationButton:(id)sender{
    
    NSInteger theCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"trafficCount"];
    if (theCount >=1) {
        // add pass
        
        [self performSegueWithIdentifier: @"trafficSegue" sender: self];

    } else if (theCount == 0) {
        
        // add ui alert
        
    }
}

@end
