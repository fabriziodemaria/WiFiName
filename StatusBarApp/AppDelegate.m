//
//  AppDelegate.m
//  StatusBarApp
//
//  Created by Fabrizio Demaria on 05/01/15.
//  Copyright (c) 2015 Fabrizio Demaria. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreWLAN/CoreWLAN.h>

@interface AppDelegate ()
@property (strong, nonatomic) NSStatusItem *statusItem;
@end


@implementation AppDelegate

//NSStatusItem *statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    _statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.toolTip = @"Ctrl + Click to quit";
    [_statusItem setTarget:self];
    [_statusItem setAction:@selector(itemClicked:)];
    [self performSelectorInBackground:@selector(func1) withObject:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)func1{
    while(true){
        CWInterface *wif = [CWInterface interface];
        NSLog(@"SSID: %@", wif.ssid);
        NSString *message = [NSString stringWithFormat:@"WiFi: %@",
                            wif.ssid];
        NSString *shortString;
        if([message length] > 20){
            shortString = [NSString stringWithFormat:@"%@...",
                           [message substringToIndex:10]];
        } else if (wif.ssid == nil){
            shortString = @"WiFi: Off";
        } else {
            shortString = message;
        }
        [_statusItem setTitle:shortString];
        [NSThread sleepForTimeInterval:5];
    }
}

- (void)itemClicked:(id)sender {
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSControlKeyMask) {
    [[NSApplication sharedApplication] terminate:self];
    return;
    }
}

@end
