//
//  AppDelegate.m
//  Monitor
//
//  Created by Joss Manger on 1/24/24.
//

#import "AppDelegate.h"
#import <AVFAudio/AVFAudio.h>

@interface MonitorMonitoring : NSObject

-(void) setup;
-(void) startMonitoring:(id)sender;

@end

@implementation MonitorMonitoring {
    id audioThingy;
    AVAudioEngine *engine;
    AVAudioPlayerNode *player;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        audioThingy =  [[AVAudioEngine alloc] init];
        engine = (AVAudioEngine*)audioThingy;
        
        
    }
    return self;
}

-(void) setup {

    
    NSLog(@"%@",engine.inputNode);
    NSLog(@"%@",engine.outputNode);
    NSLog(@"nodes: %@",engine.attachedNodes);
    
    player = [[AVAudioPlayerNode alloc] init];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"thefly" withExtension:@"mp3"];
    
    NSError *fileError;
    AVAudioFile *file = [[AVAudioFile alloc] initForReading:url error:&fileError];
    
    if (fileError != NULL){
        NSLog(@"%@",fileError);
    }
    
    NSLog(@"%@",file);
   
    [engine attachNode:player];
    [engine connect:player to:engine.mainMixerNode format:file.processingFormat];
    
    [player scheduleFile:file atTime:nil completionHandler:^{
            NSLog(@"file loaded");
    }];
    
//    [engine connect:engine.inputNode to:engine.mainMixerNode format:NULL];
//    [engine connect:engine.mainMixerNode to:engine.outputNode format:NULL];
//
//    [[engine mainMixerNode] installTapOnBus:0 bufferSize:4068 format:NULL block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
//            NSLog(@"Buffer %3.0f",[buffer floatChannelData]);
//    }];
    
    
    
    [self printEngine:NULL];
    
}

-(void)printEngine:( AVAudioEngine* _Nullable )theEngine{
    
    if (theEngine == NULL) {
        theEngine = engine;
    }
    
    NSLog(@"nodes: %@",theEngine.attachedNodes);
    
    for (AVAudioNode *current in theEngine.attachedNodes){
        NSLog(@"%@...",current);
        for (int j = 0; j < [current numberOfInputs]; j++){
            NSLog(@"inputs %d for node: %@ - input format: %@",j, [current nameForInputBus:j],[current inputFormatForBus:j]);
        }
        NSLog(@"...");
        for (int j = 0; j < [current numberOfOutputs]; j++){
            NSLog(@"output %d for node: %@ - output format %@",j, [current nameForOutputBus:j],[current outputFormatForBus:j]);
        }
    }
    
    AVAudioMixerNode *mixer = engine.mainMixerNode;
    AVAudioNodeBus nextBus = [mixer nextAvailableInputBus];
    NSLog(@"next mixer bus: %lu",nextBus);
}

- (void)startMonitoring:(id)sender{
    NSError *error;
    [engine prepare];
    [engine startAndReturnError:&error];
    [player play];
    
    NSLog(@"%@",engine.attachedNodes);
    NSLog(@"%@",engine.inputNode);
    NSLog(@"%@",engine.outputNode);
    //[[engine mainMixerNode] setOutputVolume:1.0];
    
    if (error){
        NSLog(@"error: %@",error);
        exit(EXIT_FAILURE);
    }
    
    NSLog(@"enginer is running: %d",engine.isRunning);
   
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
    
    [_model setup];
    [_model startMonitoring:self];
    
}

-(NSMenu*) getMenu{
    
    NSMenu *monitorMenu = [[NSMenu alloc] init];
    
    NSMenuItem *isMonitoring = [[NSMenuItem alloc] initWithTitle:@"Is Monitoring" action:@selector(startMonitoring:) keyEquivalent:@""];
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


