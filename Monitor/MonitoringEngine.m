//
//  MonitoringEngine.m
//  Monitor
//
//  Created by Joss Manger on 1/27/24.
//

#import "MonitoringEngine.h"

#import <AVFAudio/AVFAudio.h>

@implementation MonitoringEngine {
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

    AVAudioInputNode *inputNode = [engine inputNode];
    AVAudioFormat *inputFormat = [inputNode inputFormatForBus:0];
    
    //Collapses audio channels down to stereo - mono -> stereo, >= stereo = stereo
    UInt8 numberOfOutputChannels = inputFormat.channelCount > 1 ? 2 : 1;
    
    AVAudioFormat *fixerFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:inputFormat.sampleRate channels:numberOfOutputChannels];
    
    [engine connect:engine.inputNode to:engine.mainMixerNode format:fixerFormat];
    
    [self printEngine:NULL];
    
}

-(void)printEngine:( AVAudioEngine* _Nullable )theEngine{
    
    if (theEngine == NULL) {
        theEngine = engine;
    }
    
    NSLog(@"Attached nodes: %@",engine.attachedNodes);
    NSLog(@"Main input node %@",engine.inputNode);
    NSLog(@"Main Output Node%@",engine.outputNode);
    NSLog(@"Main Mixer Node%@",engine.mainMixerNode);
    
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

    //unused
    [player play];
    
    if (error){
        NSLog(@"error: %@",error);
        exit(EXIT_FAILURE);
    }
    
    NSLog(@"enginer is running: %d",engine.isRunning);
   
}

- (void)stopMonitoring:(id)sender {
    
    [engine stop];
    
}

-(BOOL)isMonitoring:(id)sender{
    return engine.isRunning;
}

- (void)terminate{
    [engine stop];
    [engine reset];
    engine = NULL;
}

@end
