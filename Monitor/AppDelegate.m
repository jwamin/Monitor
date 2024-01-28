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
    
}

-(NSMenu*) getMenu{
    
    NSMenu *monitorMenu = [[NSMenu alloc] init];
    
    NSMenuItem *isMonitoring = [[NSMenuItem alloc] initWithTitle:@"Is Monitoring" action:@selector(toggleMonitoring:) keyEquivalent:@"M"];
    
    [isMonitoring setEnabled:TRUE];
    
    [monitorMenu insertItem:isMonitoring atIndex:0];
    
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
    [[mainItem button] setImage: [NSImage imageWithSystemSymbolName: (isMonitoring) ? @"hifispeaker.fill" : @"hifispeaker" accessibilityDescription:NULL] ];
    
    //Update Menu Item
    //[[mainItem button] setTitle: isMonitoring ? @"Stop Monitoring" : @"Start Monitoring"];
    
    NSControlStateValue final = isMonitoring ? NSControlStateValueOn : NSControlStateValueOff;
    
    [sender setState:final];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [_monitoring terminate];
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end


