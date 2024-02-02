//
//  MonitoringEngine.h
//  Monitor
//
//  Created by Joss Manger on 1/27/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSSYMonitoring <NSObject>

-(void) setup;
-(void) startMonitoring;
-(void) stopMonitoring;
-(BOOL) isMonitoring;
-(BOOL) toggleMonitoring;
-(void) terminate;

@end

@interface MonitoringEngine: NSObject<JSSYMonitoring> @end

NS_ASSUME_NONNULL_END
