//
//  AppDelegate.m
//  Monitor
//
//  Created by Joss Manger on 1/24/24.
//

#import "AppDelegate.h"
#import "MonitoringEngine.h"

@interface AppDelegate ()

@property (strong) MonitoringEngine *monitoring;

@end


@implementation AppDelegate {
    NSStatusItem *mainItem;
    NSMenuItem *mainMenuItem;
    NSMenuItem *monitoringRow;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _monitoring = [[MonitoringEngine alloc] init];
    
    
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    mainItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [[mainItem button] setImage: [NSImage imageWithSystemSymbolName:@"hifispeaker" accessibilityDescription:NULL]];
    
    [[[mainItem button] cell] setHighlighted:YES];
    
    [mainItem setMenu:[self getMenu]];
    
    [_monitoring setup];
    
    [self updateStatusBarUI:NO fromSender:mainMenuItem];
    
}

-(NSMenu*) getMenu{
    
    NSMenu *monitorMenu = [[NSMenu alloc] init];
    
    mainMenuItem = [[NSMenuItem alloc] initWithTitle:@"Is Monitoring" action:@selector(toggleMonitoring:) keyEquivalent:@"M"];
    
    [mainMenuItem setEnabled:TRUE];
    
    [monitorMenu insertItem:mainMenuItem atIndex:0];
    
    monitoringRow = [[NSMenuItem alloc] initWithTitle:@"Monitoring Enabled" action:NULL keyEquivalent:@""];
    
    NSMenuItem *quit = [[NSMenuItem alloc] initWithTitle:@"Quit" action:NULL keyEquivalent:@"Q"];
    [quit setTarget:[NSApplication sharedApplication]];
    [quit setAction:@selector(terminate:)];
    [quit setEnabled:YES];
    
    [monitorMenu insertItem:quit atIndex:1];
    
    return monitorMenu;
}

-(void) toggleMonitoring:(NSMenuItem*)sender {
    
    BOOL isMonitoring = [_monitoring toggleMonitoring];
    
    [self updateStatusBarUI:isMonitoring fromSender:sender];

}

-(void) updateStatusBarUI:(BOOL)isMonitoring fromSender:(NSMenuItem*)sender {
    
    //Update Main Icon
    [[mainItem button] setImage: [NSImage imageWithSystemSymbolName: (isMonitoring) ? @"hifispeaker.fill" : @"hifispeaker" accessibilityDescription:NULL] ];
    
    
    //Update Menu Items
    NSControlStateValue final = isMonitoring ? NSControlStateValueOn : NSControlStateValueOff;
    
    if (isMonitoring) {
        [[mainItem menu] insertItem:monitoringRow atIndex:0];
    } else {
        if ([[[mainItem menu] itemArray] containsObject:monitoringRow])
            [[mainItem menu] removeItem:monitoringRow];
    }
    [monitoringRow setState:final];
    
    [mainMenuItem setTitle: isMonitoring ? @"Stop Monitoring" : @"Start Monitoring"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [_monitoring terminate];
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end


