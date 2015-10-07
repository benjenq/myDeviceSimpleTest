//
//  ScreenTestViewController.m
//  myDeviceSimpleTest
//
//  Created by Administrator on 2015/10/8.
//
//

#import "ScreenTestViewController.h"
#import "myMatrixView.h"

@implementation ScreenTestViewController

- (instancetype)initWithInterfaceOrientation:(UIInterfaceOrientation *)orientation{
    self = [super initWithNibName:[[self class] description] bundle:nil];
    if(self){
        _orientation = orientation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleFingerDTap = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(popToRoot:)];
    singleFingerDTap.numberOfTapsRequired = 2;
    singleFingerDTap.numberOfTouchesRequired = 1;
    singleFingerDTap.delaysTouchesEnded = NO;
    [self.view addGestureRecognizer:singleFingerDTap];
    //singleFingerDTap.delegate = self;
    [singleFingerDTap release];
    
    NSLog(@"window=(%.1f,%.1f)",self.navigationController.view.window.frame.size.width,self.navigationController.view.window.frame.size.height);
    
    
    
    
    
    
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews=(%.1f,%.1f)",self.view.frame.size.width,self.view.frame.size.height);
    if (!myScroll) {
        myScroll = [[myMatrixView alloc] initWithFrame:self.view.frame];
        NSLog(@"myScroll=(%.1f,%.1f)",myScroll.frame.size.width,myScroll.frame.size.height);
    }
}
-(void)viewDidLayoutSubviews{
    //NSLog(@"viewDidLayoutSubviews=(%.1f,%.1f)",self.view.frame.size.width,self.view.frame.size.height);
}

-(void)viewWillAppear:(BOOL)animated{
    
    //NSLog(@"viewWillAppear=(%.1f,%.1f)",self.view.frame.size.width,self.view.frame.size.height);
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];    
    
    [myScroll setDataSource:(id<myMatrixViewDataSource>)self];
    [myScroll setDelegate:(id<myMatrixViewDelegate>)self];
    
    [myScroll setpagingEnabled:YES];
    myScroll.scrolldirection = myMatrixScrollDirectionHorizontal;
    
    
    
    
    NSLog(@"%.1f,%.1f",self.view.frame.size.width,self.view.frame.size.height);
    [myScroll setFrame:self.view.frame];
    [self.view addSubview:myScroll];
    
    NSLog(@"myScroll=(%.1f,%.1f)(%.1f,%.1f)",myScroll.frame.origin.x,myScroll.frame.origin.y, myScroll.frame.size.width,myScroll.frame.size.height);
    
    if (!views) {
        views = [[NSMutableArray alloc] init];
    }
    else
    {
        [views removeAllObjects];
    }
    
    int i = 0;
    for (i = 0;i <=7;i++) {
        UIView *v = [self createViewWithIndex:i];
        [views addObject:v];
    }

    NSLog(@"myScroll=(%.1f,%.1f)(%.1f,%.1f)",self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
}


-(UIView *)createViewWithIndex:(int)index{
    UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
    [v setUserInteractionEnabled:NO];
    switch (index) {
        case 0:
        {
            v.backgroundColor = [UIColor blackColor];
            break;
        }
        case 1:
        {
            v.backgroundColor = [UIColor whiteColor];
            break;
        }
        case 2:
        {
            v.backgroundColor = [UIColor redColor];
            break;
        }
        case 3:
        {
            v.backgroundColor = [UIColor greenColor];
            break;
        }
        case 4:
        {
            v.backgroundColor = [UIColor blueColor];
            break;
        }
        case 5:
        {
            v.backgroundColor = [UIColor cyanColor];
            break;
        }
        case 6:
        {
            v.backgroundColor = [UIColor yellowColor];
            break;
        }
        case 7:
        {
            v.backgroundColor = [UIColor magentaColor];
            break;
        }
        default:
            break;
    }
    return v;
}

-(void)popToRoot:(UITapGestureRecognizer *)sender{
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self dismissModalViewControllerAnimated:YES];
    
}

#pragma mark - rotate

- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == _orientation);
}


#pragma mark - myMatrixViewDataSource

- (NSInteger)numberOfSectionsInMatrixView:(myMatrixView *)mView{
    NSLog(@"numberOfSectionsInMatrixView:%i",[views count]);
    return [views count];
}
- (UIView *)matrixView:(myMatrixView *)mView viewForItemAtIndex:(NSUInteger)index{
    return (UIView *)[views objectAtIndex:index];
}

#pragma mark -

-(void)dealloc{
    [views removeAllObjects];
    [myScroll removeFromSuperview];
    [myScroll release];
    [views release]; views = nil;
    
    NSLog(@"<%p>%@ dealloc",self,[[self class] description]);
    [super dealloc];
}

@end
