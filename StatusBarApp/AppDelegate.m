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
    // create menu
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(menu2Action) keyEquivalent:@""];
    [menu addItem:item2];
    
    [_statusItem setMenu:menu]; // attach
    //[self performSelectorInBackground:@selector(stren) withObject:nil];
}

-(void)menu2Action{
    [[NSApplication sharedApplication] terminate:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

-(void)stren{
    while (true) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%ld", self.wif.rssiValue);
    }
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
    if(wifiname==nil){
        notification.title = @"WiFi disconnected";
    }
    //notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];

    if(wifiname!=nil){
    
    long sum = 0;
    for(int i = 0; i < 1; i++) {
        long tmp[1];
        
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%ld", self.wif.rssiValue);
        tmp[i] = self.wif.rssiValue;
        sum = sum + tmp[i];
    }
    
    long tot = sum/1;
    NSString *power = nil;
    
    if(tot>-40){
        power = [NSString stringWithFormat:@"exceptional signal"];
    }
    if(tot<=-40 && tot >-55){
        power = [NSString stringWithFormat:@"very good signal"];
    }
    if(tot<=-55 && tot >-70){
        power = [NSString stringWithFormat:@"good signal"];
    }
    if(tot<=-70 && tot >-80){
        power = [NSString stringWithFormat:@"weak signal"];
    }
    if(tot<=-80){
        power = [NSString stringWithFormat:@"very weak signal"];
    }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"New WiFi connection";
    NSString *namemsg = [NSString stringWithFormat:@"WiFi name: %@, %@",
                         wifiname, power];
    notification.informativeText = namemsg;
    //notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
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
