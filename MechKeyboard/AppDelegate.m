//
//  AppDelegate.m
//  MechKeyboard
//
//  Created by Julius Cebreros on 7/4/15.
//  Copyright (c) 2015 Julius Cebreros. All rights reserved.
//

#import "KeySound.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "MechKeyboard-Swift.h"
@import AppKit;
@import ApplicationServices;


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSPopover *popover;
@property (atomic) float volume;
@property (strong, nonatomic) EventMonitor *monitor;
@property (strong, nonatomic) PopupViewController *popupVC;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.image = [NSImage imageNamed:@"keyboard11.png"];
    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
    AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
    
    KeySound *keyPress = [[KeySound alloc] init:@"sounds/laptop_notebook_return_or_enter_key_press"];
    KeySound *flagsPress = [[KeySound alloc] init:@"sounds/laptop_notebook_delete_key_press"];
    KeySound *flags2Press = [[KeySound alloc] init:@"sounds/laptop_notebook_spacebar_press"];

    self.volume = 0.25;
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSFlagsChangedMask handler:^(NSEvent *event){
        NSUInteger val = [event modifierFlags];

        if(val & NSShiftKeyMask){
            [flagsPress play:_volume];
            return;
        }
        if(val & NSCommandKeyMask || val & NSControlKeyMask || val & NSAlternateKeyMask || val & NSControlKeyMask || val & NSAlternateKeyMask){
            [flags2Press play:_volume];
            return;
        }
        if(val & NSAlphaShiftKeyMask){
            [flagsPress play:_volume];
        }

    }];
    
    

    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *event){
        switch([event keyCode]){
            case 49: //spacebar
                [flagsPress play:_volume];
                break;
            case 51: //delete
                [flags2Press play:_volume];
                break;
            default:
                [keyPress play:_volume];
        }
    }];
    
    self.popover = [[NSPopover alloc] init];
    self.popupVC =[[PopupViewController alloc] initWithNibName:@"PopupViewController" bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AdjustVolume" object:nil];
   
    
    _popover.contentViewController = _popupVC;
    [_statusItem setAction:@selector(itemClicked:)];

    
    self.monitor = [[EventMonitor alloc] initWithMask:NSLeftMouseDownMask | NSRightMouseDownMask handler:^(NSEvent *event){
        if(_popover.shown){
            [self closePopover:event];
        }
    }];
    [_monitor start];

}

- (void) volumeChanged:(NSNotification *)notification{
    _volume = _popupVC.volume;

}

- (void) itemClicked:(id)sender{
    if(_popover.shown){
        [self closePopover:sender];
    }else{
        [self showPopover:sender];
    }
    
}

- (void) closePopover:(id)sender{
    [_popover performClose:sender];
    [_monitor stop];
}

- (void) showPopover:(id)sender{
    [_popupVC setControllerVolume:_volume];
    [_popover showRelativeToRect:_statusItem.button.bounds ofView:_statusItem.button preferredEdge:NSMinYEdge];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
