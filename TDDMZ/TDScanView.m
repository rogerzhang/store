//
//  TDScanView.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/15/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "TDScanView.h"

@implementation TDScanView

- (void) awakeFromNib;
{
    [super awakeFromNib];
    
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
}

- (IBAction)okAction:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(okAction:)]) {
        [self.delegate okAction: self];
    }
}

- (IBAction)scanAction:(id)sender
{
    if ([self.delegate respondsToSelector: @selector(scanAction:)]) {
        [self.delegate scanAction: self];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([self.delegate respondsToSelector: @selector(okAction:)]) {
            [self.delegate okAction: self];
        }
        return NO;
    }
    
    return YES;
}

@end
