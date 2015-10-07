//
//  Utility.m
//  TNDengue
//
//  Created by Administrator on 2015/9/16.
//
//

#import "Utility.h"

//機器資訊相關
#include <sys/sysctl.h>
#include <sys/resource.h>
#include <sys/vm.h>
#include <dlfcn.h>
#import "MobileGestalt.h"

NSString *const DataTitle  = @"DataTitle";
@implementation Utility

+(NSString *)GetBundlePath{
    return [[NSBundle mainBundle] bundlePath];
}

+(NSString *)GetDocumentPath{
    return [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]];
}
+(NSString *)GetCachePath{
    return [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) objectAtIndex:0]];
}
+(NSString *)GettmpPath{
    return [NSString stringWithFormat:@"%@",NSTemporaryDirectory()];
}

+(BOOL)fileisExist:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
        return YES;
    else
        return NO;
}

+(BOOL)copyfile:(NSString *)source toPath:(NSString *)destination{
    if (![self fileisExist:source]) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL success = [fileManager copyItemAtPath:source toPath:destination error:&error];
    if (error != nil) {
        NSLog(@"copyfile error:%@",[error description]);
        
    }
    return success;
    
}
#pragma mark - 數字文字轉換
+(NSString *)numberToString:(NSNumber *)val{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,###,###,##0.#########"];
    
    NSString *formattedNumberString = [numberFormatter stringFromNumber:val];
    [numberFormatter release];
    return formattedNumberString;
}
+(NSNumber *)stringToNumber:(NSString *)valStr{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###,###,###,##0.#########"];
    
    NSNumber *formattedNumber = [numberFormatter numberFromString:valStr];
    [numberFormatter release];
    return formattedNumber;
}

#pragma mark - 顏色碼轉換

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}






@end
#pragma mark - 機器資訊相關
@implementation UIDevice (DeviceImplement)

+(NSString *)deviceNameString{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *model = (char*)malloc(size);
    sysctlbyname("hw.machine", model, &size, NULL, 0);
    NSString *sDeviceModel = [NSString stringWithCString:model encoding:NSUTF8StringEncoding];
    free(model);
    return sDeviceModel;
}

+(NSString *)deviceBoardID{
    CFStringRef _boardID = MGCopyAnswer(kMGHardwarePlatform);
    return (NSString *) _boardID;
}

+(NSString *)deviceColorString{
    CFStringRef _colorString = MGCopyAnswer(kMGDeviceColor);
    return (NSString *) _colorString;
}

+(UIColor *)deviceColor{
    return [Utility colorFromHexString:[UIDevice deviceColorString]];
}

@end
