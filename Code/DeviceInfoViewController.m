//
//  DeviceInfoViewController.m
//  myDeviceSimpleTest
//
//  Created by Administrator on 15/10/8.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import "DeviceInfoViewController.h"

#import "ScreenTestViewController.h"

@implementation DeviceInfoViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"裝置與螢幕測試";

    lb_deveceName.text = [UIDevice deviceNameString];
    lb_deveceBoardID.text = [UIDevice deviceBoardID];
    if ([lb_deveceBoardID.text.uppercaseString isEqualToString:@"S8000"]) {
        lb_CPUVendor.text = @"Samsung(三星)";
    }
    else if ([lb_deveceBoardID.text.uppercaseString isEqualToString:@"S8003"]) {
        lb_CPUVendor.text = @"TSMC(台積電)";
    }
    else{
        lb_CPUVendor.text = @"";
    }
    lb_deveceColor.text = [UIDevice deviceColorString];

    [lb_deveceColor setBackgroundColor:[UIDevice deviceColor]];
    
    if ([lb_deveceColor.text isEqualToString:@"black"] || [lb_deveceColor.text isEqualToString:@"white"] ) {
        if ([lb_deveceColor.text isEqualToString:@"black"]) {
            lb_deveceColor.backgroundColor = [UIColor blackColor];
            lb_deveceColor.textColor = [UIColor whiteColor];
        }
        else if ([lb_deveceColor.text isEqualToString:@"white"]) {
            lb_deveceColor.backgroundColor = [UIColor whiteColor];
            lb_deveceColor.textColor = [UIColor blackColor];
        }
        return;
    }
    
    
    UIColor *color = lb_deveceColor.backgroundColor;
    
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        lb_deveceColor.textColor = [UIColor colorWithRed:1-red green:1-green blue:1-blue alpha:1];
    }
    
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if ([device respondsToSelector:selector]) {
        NSLog(@"DeviceColor: %@ DeviceEnclosureColor: %@", [device performSelector:selector withObject:@"DeviceColor"], [device performSelector:selector withObject:@"DeviceEnclosureColor"]);
        NSString *colorStr = [device performSelector:selector withObject:@"DeviceEnclosureColor"];
        lb_deveceColor.text = colorStr;
        lb_deveceColor.backgroundColor = [Utility colorFromHexString:colorStr];
        
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [lb_deveceColor.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
        lb_deveceColor.textColor = [UIColor colorWithRed:1-red green:1-green blue:1-blue alpha:1];
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(IBAction)goToScreenTest:(id)sender{
    ScreenTestViewController *vc = [[ScreenTestViewController alloc] initWithNibName:[[ScreenTestViewController class] description] bundle:nil];
    [self.navigationController presentModalViewController:vc animated:YES];
    [vc release];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
