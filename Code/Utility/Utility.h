//
//  Utility.h
//  TNDengue
//
//  Created by Administrator on 2015/9/16.
//
//

#import <Foundation/Foundation.h>

extern NSString *const DataTitle;
@interface Utility : NSObject

+(NSString *)GetBundlePath;
+(NSString *)GetDocumentPath;
+(NSString *)GetCachePath;
+(NSString *)GettmpPath;


+(BOOL)fileisExist:(NSString *)filePath;
+(BOOL)copyfile:(NSString *)source toPath:(NSString *)destination;

#pragma mark - 數字文字轉換
+(NSString *)numberToString:(NSNumber *)val;
+(NSNumber *)stringToNumber:(NSString *)valStr;

#pragma mark - 顏色碼轉換

+ (UIColor *)colorFromHexString:(NSString *)hexString;




@end

#pragma mark - 機器資訊相關

@interface UIDevice (DeviceImplement)

+(NSString *)deviceNameString;
+(NSString *)deviceBoardID;
+(NSString *)deviceColorString;
+(UIColor *)deviceColor;

@end
