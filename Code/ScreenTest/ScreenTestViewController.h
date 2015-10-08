//
//  ScreenTestViewController.h
//  myDeviceSimpleTest
//
//  Created by Administrator on 2015/10/8.
//
//

#import <UIKit/UIKit.h>
@class myMatrixView;
@interface ScreenTestViewController : UIViewController{
    IBOutlet myMatrixView *myScroll;
    
    NSMutableArray *views;
    
    UIInterfaceOrientation _orientation;
}


@end
