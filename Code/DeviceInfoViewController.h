//
//  DeviceInfoViewController.h
//  myDeviceSimpleTest
//
//  Created by Administrator on 15/10/8.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DeviceInfoViewController : UIViewController {
    IBOutlet UILabel *lb_deveceName;
    IBOutlet UILabel *lb_deveceModelRegion;
    IBOutlet UILabel *lb_deveceBoardID;
    IBOutlet UILabel *lb_CPUVendor;
    IBOutlet UILabel *lb_deveceColor;
    
    IBOutlet UIImageView *_imgV_CPU;
    
    NSString *_imageName;

}

@end
