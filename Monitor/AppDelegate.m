//
//  AppDelegate.m
//  Monitor
//
//  Created by Joss Manger on 1/24/24.
//

#import "AppDelegate.h"
#import <AVFAudio/AVFAudio.h>


@interface MonitorMonitoring : NSObject

-(void) startMonitoring:(id)sender;

@end

@implementation MonitorMonitoring {
    id audioThingy;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        audioThingy = [[AVAudioPlayer alloc] init];
    }
    return self;
}

- (void)startMonitoring:(id)sender{
    
}


@end


@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (strong) NSStatusItem *item;

@property (strong) MonitorMonitoring *model;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
    _model = [[MonitorMonitoring alloc] init];
    
    
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    _item = [bar statusItemWithLength:NSVariableStatusItemLength];
    [[_item button] setImage: [NSImage imageWithSystemSymbolName:@"hifispeaker" accessibilityDescription:NULL]];
    
    [[_item button] setTitle:@"Monitor"];
    [[[_item button] cell] setHighlighted:YES];
    
    [_item setMenu:[self getMenu]];
    
}

-(NSMenu*) getMenu{
    
    NSMenu *monitorMenu = [[NSMenu alloc] init];
    
    NSMenuItem *isMonitoring = [[NSMenuItem alloc] initWithTitle:@"Is Monitoring" action:NULL keyEquivalent:@""];
    [isMonitoring setEnabled:TRUE];
    [isMonitoring setState:NSControlStateValueOn];
    
    [monitorMenu insertItem:isMonitoring atIndex:0];
    
    NSMenuItem *quit = [[NSMenuItem alloc] initWithTitle:@"Quit" action:NULL keyEquivalent:@"#Q"];
    [quit setEnabled:YES];
    
    [monitorMenu insertItem:quit atIndex:1];
    
    return monitorMenu;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}


@end


