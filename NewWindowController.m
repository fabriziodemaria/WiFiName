//
//  NewWindowController.m
//  WiFiName
//
//  Created by Fabrizio Demaria on 11/01/15.
//  Copyright (c) 2015 Fabrizio Demaria. All rights reserved.
//

#import "NewWindowController.h"

@interface NewWindowController ()
@property (weak) IBOutlet NSTextField *twitterlabel;
@property  (strong, nonatomic) NSUserDefaults *defaults;
@property (weak) IBOutlet NSButton *notificationCheck;
@property (weak) IBOutlet NSImageView *image;


@end

@implementation NewWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *notificationsActive = [[NSNumber alloc] initWithInt:(int)[_defaults integerForKey:@"notificationsActive"]];
    if([notificationsActive isEqualToNumber:[NSNumber numberWithInt:0]]){ _notificationCheck.state = NSOffState;}else{
        _notificationCheck.state=NSOnState;
    }
    [_image setImage:[NSImage imageNamed:@"wifi.png"]];
}

- (IBAction)QuitPressed:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (IBAction)settingsChanged:(NSButton*)sender {
    if(sender.state == NSOnState) {
        [self.defaults setInteger:1 forKey:@"notificationsActive"];
    }
    if(sender.state == NSOffState) {
        [self.defaults setInteger:0 forKey:@"notificationsActive"];
    }
    
}
@end
