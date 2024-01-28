//
//  MonitoringEngine.h
//  Monitor
//
//  Created by Joss Manger on 1/27/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitoringEngine : NSObject

-(void) setup;
-(void) startMonitoring:(id)sender;
-(void) stopMonitoring:(id)sender;
-(BOOL) isMonitoring:(id __nullable)sender;
-(void) terminate;

@end

NS_ASSUME_NONNULL_END
