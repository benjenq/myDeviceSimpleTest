//
//  myMatrixView.m
//  DatasourceTest
//
//  Created by Administrator on 13/5/10.
//  Copyright (c) 2013年 Administrator. All rights reserved.
//

#import "myMatrixView.h"
//#import "myImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation myMatrixView
@synthesize numberOfItems = _numberOfItems;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize matrixRowNCol = _matrixRowNCol;
@synthesize itemViews = _itemViews;
@synthesize scrolldirection = _scrolldirection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self firstSetup];
    }
    return self;
}
-(void)awakeFromNib{
    //NSLog(@"%@:awakeFromNib",[[self class] description]);
    [super awakeFromNib];
    [self firstSetup];

}



-(void)firstSetup{
    //NSLog(@"%@:firstSetup",[[self class] description]);
    [self setUserInteractionEnabled:YES];
    hasFinishLayout = NO;
    _matrixRowNCol = CGPointMake(1, 1);
    _scrolldirection = myMatrixScrollDirectionVertical;

    if (!_baseScrollv) {
        //_baseScrollv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _baseScrollv = [[UIScrollView alloc] initWithFrame:self.bounds];
    }  
    _baseScrollv.contentSize = self.bounds.size;// CGSizeMake(self.bounds.size.width, self.bounds.size.height);// self.bounds.size;
    //NSLog(@"(size=%.0f,%.0f)",_baseScrollv.contentSize.width,_baseScrollv.contentSize.height);
    _baseScrollv.scrollEnabled = YES;
    //_baseScrollv.bounces = YES;
    //_baseScrollv.alwaysBounceHorizontal = YES;
    //_baseScrollv.alwaysBounceVertical = YES;
    _baseScrollv.showsHorizontalScrollIndicator = YES;
    _baseScrollv.pagingEnabled = NO;
    _baseScrollv.showsVerticalScrollIndicator = YES;
    
    //_baseScrollv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG.png"]];
    
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:_baseScrollv.bounds];
        _bgImgView.backgroundColor = [UIColor clearColor];

        /*
         UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
         UIViewAutoresizingFlexibleWidth        = 1 << 1,
         UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
         UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
         UIViewAutoresizingFlexibleHeight       = 1 << 4,
         UIViewAutoresizingFlexibleBottomMargin = 1 << 5 */
        
        _bgImgView.autoresizingMask = UIViewAutoresizingNone ;//| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
        //UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [_baseScrollv addSubview:_bgImgView];        
        
    }

    [self addSubview:_baseScrollv];
    _baseScrollv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleHeight  |
    UIViewAutoresizingFlexibleBottomMargin ;
    
    if (!_ovImgView) {
        _ovImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _ovImgView.backgroundColor = [UIColor clearColor];
        
        _ovImgView.autoresizingMask = UIViewAutoresizingNone ;
        
        [self addSubview:_ovImgView];
        
    }
    
    
    if (!_itemViews) {
        _itemViews = [[NSMutableDictionary alloc] init];
    }
    
    
}
//============= 以上為起始常用函數
#pragma mark 一般函數
- (void)layoutSubviews  //自動呼叫
{
    //NSLog(@"%@:layoutSubviews",[[self class] description]);
    if (hasFinishLayout) {
        return;
    }
    [self reloadData];
    hasFinishLayout = YES;
}

-(void)setDataSource:(id<myMatrixViewDataSource>)dataSource{
    _dataSource = dataSource;
}

-(void)setDelegate:(id<myMatrixViewDelegate>)delegate{
    _delegate = delegate;
}

-(void)setpagingEnabled:(BOOL)enabled{
    _baseScrollv.pagingEnabled = enabled;
}


-(void)setContentBackGroundImage:(UIImage *)BGImg{
    [_bgImgView setBackgroundColor:[UIColor colorWithPatternImage:BGImg]];
}

-(UIImage *)contentbackgroundImage{
    return nil;
}

-(void)setOverLapImage:(UIImage *)OVImg{
    [_ovImgView setBackgroundColor:[UIColor colorWithPatternImage:OVImg]];
}


-(CGPoint)contentOffset{
    return _baseScrollv.contentOffset;
}

-(void)setcontentOffset:(CGPoint)contentOffset{
    [_baseScrollv setContentOffset:contentOffset];
}

-(void)removeAllitemViews{
    //NSLog(@"%@ removeAllitemViews:count=%i",[[self class] description],_itemViews.count);
    NSArray *allkey = [_itemViews allKeys];
    for (NSNumber *index in allkey) {
            UIView *view = [_itemViews objectForKey:index];
            if (view != nil || (!view)) {
                
                [view removeFromSuperview];
                [_itemViews removeObjectForKey:index];
                [view release];
        }
    }
    //NSLog(@"%@ removeAllitemViews:count=%i",[[self class] description],_itemViews.count);

    _baseScrollv.contentSize = self.bounds.size;
}

-(void)reloadData{
    [self removeAllitemViews];
    //NSLog(@"ForiMatrixView reloadData");
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInMatrixView:)]){
        _numberOfItems = [_dataSource numberOfSectionsInMatrixView:self];
       // NSLog(@"_numberOfItems=%i",_numberOfItems);
    }

    NSInteger i;
    for (i=0; i<_numberOfItems; i++) {
        //[self getOffSet:i];
        [self addViewAtIndex:i];
    }
    
}

#pragma mark -

#pragma mark 函數

-(CGPoint)getOffSet:(NSInteger)index{
    //NSLog(@"matrixRowNCol:%.0f,%.0f",_matrixRowNCol.x,_matrixRowNCol.y);
    if (CGPointEqualToPoint(_matrixRowNCol, CGPointZero)) {
        _matrixRowNCol = CGPointMake(1, 1);
    }
    
	CGPoint ItemOffSetPoint = CGPointZero;
    
    CGSize frameSize = CGSizeMake(self.frame.size.width / _matrixRowNCol.x, self.frame.size.height / _matrixRowNCol.y);
    
    if (_scrolldirection == myMatrixScrollDirectionVertical) {
        ItemOffSetPoint.x = index%(int)(round(_matrixRowNCol.x)) * frameSize.width;
        ItemOffSetPoint.y = floor(index/(int)(round(_matrixRowNCol.x))) * frameSize.height;
        //ItemOffSetPoint.x = index%(int)(round(_matrixRowNCol.x));
        //ItemOffSetPoint.y = floor(index/(int)(round(_matrixRowNCol.x))) ;
        //NSLog(@"index:%i,ItemOffSetPoint=(%.0f,%.0f)",index,ItemOffSetPoint.x,ItemOffSetPoint.y);
    }
    else if (_scrolldirection == myMatrixScrollDirectionHorizontal) {
        ItemOffSetPoint.x = floor(index/(int)(round(_matrixRowNCol.y))) * frameSize.width;
        ItemOffSetPoint.y = index%(int)(round(_matrixRowNCol.y))* frameSize.height;
        //ItemOffSetPoint.x = floor(index/(int)(round(_matrixRowNCol.y))) ;
        //ItemOffSetPoint.y = index%(int)(round(_matrixRowNCol.y));
        //NSLog(@"index:%i,ItemOffSetPoint=(%.0f,%.0f)",index,ItemOffSetPoint.x,ItemOffSetPoint.y);
    }
    
    
    /*
	ItemOffSetPoint.x = (inRecno -1)%inColNum;
	ItemOffSetPoint.y = floor((inRecno -1)/inColNum);
	return ItemOffSetPoint;
    */
    return ItemOffSetPoint;
}



#pragma mark View management

- (UIView *)addViewAtIndex:(NSInteger)index
{
    //NSLog(@"addViewAtIndex:%i",index);
    UIView *view = nil;
    
    if (index >= 0) {
        if ([_dataSource respondsToSelector:@selector(matrixView:viewForItemAtIndex:)]){
            view = (UIView *)[_dataSource matrixView:self viewForItemAtIndex:index];
            if (view || (view != nil)) {
                CGPoint vieworigin = [self getOffSet:index];
                
                view.frame = CGRectMake(vieworigin.x, vieworigin.y, view.frame.size.width, view.frame.size.height);
                //NSLog(@"(%.0f,%.0f,%.0f,%.0f)",view.frame.origin.x,view.frame.origin.y,view.frame.size.width,view.frame.size.height);
                [self resizebaseScrollvContentSize:view];
                
                [_baseScrollv addSubview:view];
                [_itemViews setObject:view forKey:[NSNumber numberWithInteger:index]];
            
            }
        }
    }
    
    return view;
}

-(void)reLayoutitemViewwithAnimate:(BOOL)animate{
    NSArray *allkey = [_itemViews allKeys];
    _baseScrollv.contentSize = self.bounds.size;
    for (NSNumber *index in allkey) {
        UIView *view = [_itemViews objectForKey:index];
        if (view != nil || (!view)) {
            //NSLog(@"Found:%i",view.tag);
            CGPoint newOffSet = [self getOffSet:[index integerValue]];
            view.frame = CGRectMake(newOffSet.x, newOffSet.y, view.frame.size.width, view.frame.size.height);
            [self resizebaseScrollvContentSize:view];
            if (animate) {
                [self viewWithAnimation:view];                
            }
        }
    }
    
}

-(void)viewWithAnimation:(UIView *)view{
    /*
    CATransition *animation = [CATransition animation] ;
	[animation setType:kCATransitionReveal];
    //[animation setSubtype:kCATransitionFromRight];
    //[animation setSubtype:kCATransitionFromLeft];
    //[animation setSubtype:kCATransitionFromTop];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setDuration:0.55];
    animation.removedOnCompletion = YES;
    
	
	//[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.8f : 0.001f : 0.2f : 1.0f]];
    
    //[self.navigationController pushViewController:self.myDataViewCTL animated:NO];
    [view.layer addAnimation:animation forKey:nil];
    */
    
    
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.1f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.delegate = nil;
    transition.type = kCATransitionFade;
    //transition.subtype = kCATransitionFromRight;
    transition.removedOnCompletion = YES;
    [view.layer addAnimation:transition forKey:nil];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setToValue:[NSNumber numberWithDouble:1.0]];
    [animation setFromValue:[NSNumber numberWithDouble:1.2]];
     [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.8f : 0.001f : 0.2f : 1.1f]];
    //animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [animation setAutoreverses:NO];
    [animation setDuration:(0.2f + 0.047f * [self indexOfItemView:view])];
    [animation setRepeatCount:0];
    [animation setBeginTime:0.0f ];
    animation.removedOnCompletion = YES;
    
    
    
    
    [view.layer addAnimation:animation forKey:nil];
    
    
    
}

-(void)resizebaseScrollvContentSize:(UIView *)refView{
    if (refView != nil || (!refView)) {
        if (_baseScrollv.contentSize.width < (refView.frame.origin.x + refView.frame.size.width)) {
            _baseScrollv.contentSize = CGSizeMake(refView.frame.origin.x + refView.frame.size.width,_baseScrollv.contentSize.height);
        }
        if (_baseScrollv.contentSize.height < (refView.frame.origin.y + refView.frame.size.height)) {
            _baseScrollv.contentSize = CGSizeMake(_baseScrollv.contentSize.width,refView.frame.origin.y + refView.frame.size.height);
        }
        _bgImgView.frame = CGRectMake(0, 0, _baseScrollv.contentSize.width, _baseScrollv.contentSize.height);
    }
}



- (UIView *)itemViewAtIndex:(NSInteger)index
{
    return [_itemViews objectForKey:[NSNumber numberWithInteger:index]];
}

- (NSInteger)indexOfItemView:(UIView *)view
{
    NSInteger index = [[_itemViews allValues] indexOfObject:view];
    if (index != NSNotFound)
    {
        return [[[_itemViews allKeys] objectAtIndex:index] integerValue];
    }
    return NSNotFound;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)removeFromSuperview{
    [super removeFromSuperview];
    [self removeAllitemViews];
    self.delegate = nil;
    self.dataSource = nil;
}

-(void)dealloc{
    
    
    [_itemViews removeObjectsForKeys:[_itemViews allKeys]];
    [_itemViews release];
    
    
    [_ovImgView removeFromSuperview];
    [_ovImgView release];
    
    [_bgImgView removeFromSuperview];
    [_bgImgView release];
    

    [_baseScrollv removeFromSuperview];
    [_baseScrollv release];
    
     NSLog(@"<%p>%@ dealloc",self,[[self class] description]);
    [super dealloc];
}

@end
