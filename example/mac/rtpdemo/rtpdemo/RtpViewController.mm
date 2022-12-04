//
//  RtpViewController.m
//  rtpdemo
//
//  Created by suntongmian on 2022/12/4.
//

#import "RtpViewController.h"

@interface RtpViewController ()

@end

@implementation RtpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)startButtonEvent:(id)sender {
    
}

- (IBAction)stopButtonEvent:(id)sender {
    
}

- (IBAction)exitButtonEvent:(id)sender {
    [self.view.window close];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
