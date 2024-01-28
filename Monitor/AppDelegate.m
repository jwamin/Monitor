//
//  AppDelegate.m
//  Monitor
//
//  Created by Joss Manger on 1/24/24.
//

#import "AppDelegate.h"
#import "MonitoringEngine.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (strong) NSStatusItem *item;
@property (strong) MonitoringEngine *monitoring;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _monitoring = [[MonitoringEngine alloc] init];
    
    
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    _item = [bar statusItemWithLength:NSVariableStatusItemLength];
    [[_item button] setImage: [NSImage imageWithSystemSymbolName:@"hifispeaker" accessibilityDescription:NULL]];
    
    [[_item button] setTitle:@"Monitor"];
    [[[_item button] cell] setHighlighted:YES];
    
    [_item setMenu:[self getMenu]];
    
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
    
    BOOL isMonitoring = [_monitoring isMonitoring:NULL];
    if (isMonitoring) {
        [_monitoring stopMonitoring:sender];
    } else {
        [_monitoring startMonitoring:sender];
    }
    NSControlStateValue final = [_monitoring isMonitoring:NULL] ? NSControlStateValueOn : NSControlStateValueOff;
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


