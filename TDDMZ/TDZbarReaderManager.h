//
//  TDZbarReaderManager.h
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/5/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TDZbarReaderCompletionHandler)(BOOL success, id result);

@interface TDZbarReaderManager : NSObject

+ (instancetype) sharedInstance;

- (void) startToScanBarcodeOnViewController: (UIViewController *)presentingViewController withCompletionHandler: (TDZbarReaderCompletionHandler)completionHandler;

- (void) endScaningBarcode;

@end
