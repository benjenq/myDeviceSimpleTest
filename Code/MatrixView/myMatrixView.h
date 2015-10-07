//
//  myMatrixView.h
//  DatasourceTest
//
//  Created by Administrator on 13/5/10.
//  Copyright (c) 2013年 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,myMatrixScrollDirection)
{
    myMatrixScrollDirectionVertical = 0,
    myMatrixScrollDirectionHorizontal = 1
};

@protocol myMatrixViewDataSource, myMatrixViewDelegate;
@interface myMatrixView : UIView{
    UIImageView *_bgImgView;
    UIImageView *_ovImgView;
    

    NSInteger _numberOfItems;
    id<myMatrixViewDelegate>  _delegate;
    id<myMatrixViewDataSource> _dataSource;
    NSMutableDictionary *_itemViews;
    CGPoint _matrixRowNCol;
    myMatrixScrollDirection _scrolldirection;
    UIScrollView *_baseScrollv;
}

@property (nonatomic, retain) IBOutlet id<myMatrixViewDataSource> dataSource;   //可在XIB畫面上拉，並自動啟用 setdataSource
@property (nonatomic, retain) IBOutlet id<myMatrixViewDelegate> delegate; //可在XIB畫面上拉，並自動啟用 delegate
@property (nonatomic, strong) NSMutableDictionary *itemViews;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic) CGPoint matrixRowNCol;
@property (nonatomic, assign) myMatrixScrollDirection scrolldirection;
@property (nonatomic,setter = setpagingEnabled:) BOOL pagingEnabled;
@property (nonatomic,setter = setcontentOffset:) CGPoint contentOffset;
@property (nonatomic,retain, setter = setContentBackGroundImage:) UIImage *contentbackgroundImage;
@property (nonatomic,retain, setter = setOverLapImage:) UIImage *overlapImgView;

-(void)reloadData;

-(void)reLayoutitemViewwithAnimate:(BOOL)animate;
- (UIView *)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView *)view;

@end


@protocol myMatrixViewDataSource <NSObject>
- (NSInteger)numberOfSectionsInMatrixView:(myMatrixView *)mView;
- (UIView *)matrixView:(myMatrixView *)mView viewForItemAtIndex:(NSUInteger)index ;

@end

@protocol myMatrixViewDelegate <NSObject>
@end
