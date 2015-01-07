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
@property (strong, nonatomic) CWInterface *wif;

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
    
    _wif = [CWInterface interface];
    [self updateTitle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterfaceNotification:) name:CWSSIDDidChangeNotification object:nil];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}


-(void)updateTitle{
    NSString *message = [NSString stringWithFormat:@"WiFi: %@",
                         self.wif.ssid];
    NSString *shortString;
    if([message length] > 20){
        shortString = [NSString stringWithFormat:@"%@...",
                       [message substringToIndex:10]];
    } else if (self.wif.ssid == nil){
        shortString = @"WiFi: Off";
    } else {
        shortString = message;
    }
    [_statusItem setTitle:shortString];
    [self showNotification:self.wif.ssid];
}


-(void) handleInterfaceNotification:(NSNotification*) notification;
{
    [self updateTitle];
}

- (IBAction)showNotification:(NSString *)wifiname{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    if(wifiname!=nil){
    notification.title = @"New WiFi connection";
    NSString *namemsg = [NSString stringWithFormat:@"WiFi name: %@",
                         wifiname];
    notification.informativeText = namemsg;
    } else {
        notification.title = @"WiFi disconnected";
    }
    //notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)itemClicked:(id)sender {
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSControlKeyMask) {
    [[NSApplication sharedApplication] terminate:self];
    return;
    }
}

@end
