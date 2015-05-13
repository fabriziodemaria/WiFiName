//
//  AppDelegate.m
//  StatusBarApp
//
//  Created by Fabrizio Demaria on 05/01/15.
//  Copyright (c) 2015 Fabrizio Demaria. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreWLAN/CoreWLAN.h>
#import "NewWindowController.h"

@interface AppDelegate ()
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) CWInterface *wif;
@property (weak) IBOutlet NSMenu *myMenu;
@property (strong, nonatomic) NewWindowController *controllerWindow;
@property  (strong, nonatomic) NSUserDefaults *defaults;
@end


@implementation AppDelegate

//NSStatusItem *statusItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    _statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    //_statusItem.toolTip = @"Ctrl + Click to quit";
    [_statusItem setTarget:self];
    [_statusItem setAction:@selector(itemClicked:)];
    
    _wif = [CWInterface interface];
    [self updateIcon];
    [self updateTitle];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterfaceNotification:) name:CWSSIDDidChangeNotification object:nil];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    // create menu
    [_statusItem setMenu:_myMenu]; // attach
    //[self performSelectorInBackground:@selector(stren) withObject:nil];
}
- (IBAction)QuitPressed:(id)sender {
        [[NSApplication sharedApplication] terminate:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}


- (IBAction)showAbout:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
     self.controllerWindow = [[NewWindowController alloc] initWithWindowNibName:@"NewWindowController"];
    [self.controllerWindow showWindow:self];
}


- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}


-(void)updateTitle{
    NSString *message = [NSString stringWithFormat:@"%@",
                         self.wif.ssid];
    NSString *shortString;
    if([message length] > 20){
        shortString = [NSString stringWithFormat:@"%@...",
                       [message substringToIndex:20]];
    } else if (self.wif.ssid == nil){
        shortString = @"Wifi Off";
    } else {
        shortString = message;
    }
    [_statusItem setTitle:[NSString stringWithFormat:@"%@", shortString]];
    [self showNotification:self.wif.ssid];
    
}

-(void)updateIcon {
    long power = [self getTotalPower];
    NSImage *image = nil;

    if(power > -40 && power > 0){
        image = [NSImage imageNamed:@"wifi3.pdf"];
    }
    if(power <= -40 && power >- 55){
        image = [NSImage imageNamed:@"wifi3.pdf"];
    }
    if(power <= -55 && power > -70){
        image = [NSImage imageNamed:@"wifi2.pdf"];
    }
    if(power <= -70 && power >- 80){
        image = [NSImage imageNamed:@"wifi1.pdf"];
    }
    if(power <= -80){
        image = [NSImage imageNamed:@"wifi1.pdf"];
    }
    
    [_statusItem setImage:image];
}


-(void) handleInterfaceNotification:(NSNotification*) notification;
{
    [self updateIcon];
    [self updateTitle];
}

- (IBAction)showNotification:(NSString *)wifiname{
    
    //Check preferences about notifications
    NSNumber *notificationsActive = [[NSNumber alloc] initWithInt:(int)[_defaults integerForKey:@"notificationsActive"]];
    if([notificationsActive isEqualToNumber:[NSNumber numberWithInt:0]]) return;
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    if(wifiname==nil){
        notification.title = @"Wi-Fi disconnected";
    }
    
    
    //notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];

    if(wifiname!=nil){
    
    long tot = [self getTotalPower]/1;
    NSString *power = nil;
        if(tot==0){
            power = [NSString stringWithFormat:@", hotspot mode"];
        }
        if(tot>-40 && tot >0){
            power = [NSString stringWithFormat:@", exceptional signal"];
        }
        if(tot<=-40 && tot >-55){
            power = [NSString stringWithFormat:@", very good signal"];
        }
        if(tot<=-55 && tot >-70){
            power = [NSString stringWithFormat:@", good signal"];
        }
        if(tot<=-70 && tot >-80){
            power = [NSString stringWithFormat:@", weak signal"];
        }
        if(tot<=-80){
            power = [NSString stringWithFormat:@", very weak signal"];
        }
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"New Wi-Fi connection";
    NSString *namemsg = [NSString stringWithFormat:@"Wi-Fi name: %@ %@",
                         wifiname, power];
    notification.informativeText = namemsg;
    //notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}

- (long)getTotalPower {
    long sum = 0;
    for(int i = 0; i < 1; i++) {
        long tmp[1];
        
        [NSThread sleepForTimeInterval:1];
        NSLog(@"%ld", self.wif.rssiValue);
        tmp[i] = self.wif.rssiValue;
        sum = sum + tmp[i];
    }
    return sum;
}

- (void)itemClicked:(id)sender {
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSControlKeyMask) {
    [[NSApplication sharedApplication] terminate:self];
    return;
    }
}

@end
