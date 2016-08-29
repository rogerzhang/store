//
//  TDZbarReaderManager.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDZbarReaderManager.h"
#import "ZBarSDK.h"

@interface TDZbarReaderManager()<ZBarReaderDelegate>

@property (nonatomic, retain) ZBarReaderViewController *reader;
@property (nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, copy) TDZbarReaderCompletionHandler completionHandler;

@end

@implementation TDZbarReaderManager

+ (instancetype) sharedInstance;
{
    static TDZbarReaderManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [TDZbarReaderManager new];
        sharedInstance.reader = [ZBarReaderViewController new];
        sharedInstance.reader.readerDelegate = sharedInstance;
    });
    
    return sharedInstance;
}

- (void) startToScanBarcodeOnViewController: (UIViewController *)presentingViewController withCompletionHandler: (TDZbarReaderCompletionHandler)completionHandler;
{
    self.presentingViewController = presentingViewController;
    self.completionHandler = completionHandler;
    
    ZBarImageScanner *scanner = self.reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
     
                   config: ZBAR_CFG_ENABLE
     
                       to: 0];
    
    [self.presentingViewController presentViewController: self.reader animated: YES completion: ^{}];
}

- (void) endScaningBarcode;
{
    self.presentingViewController = nil;
    self.completionHandler = NULL;
}

- (void) imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary<NSString *,id> *)info;
{
    TD_LOG(@"Barcode info=%@",info);

    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    
    for(symbol in results)break;
    
    NSString *result = symbol.data;
    UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    if (result && image)
    {
        TD_LOG(@"%@", result);
    }
    
    assert(result);
    
    if (self.completionHandler)
    {
        self.completionHandler(YES, result);
    }
    
    [self.reader dismissViewControllerAnimated: YES completion: NULL];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker;
{
    if (self.completionHandler)
    {
        self.completionHandler(NO, nil);
    }
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*)reader withRetry: (BOOL)retry;
{}

@end
