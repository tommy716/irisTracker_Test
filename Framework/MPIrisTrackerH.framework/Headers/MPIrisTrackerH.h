//
//  MPIrisTrackerH.h
//  MPIrisTrackerH
//
//  Created by Yuki Yamato on 2021/05/05.
//
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

@class MPLandmark;
@class MPIrisTrackerH;

@protocol MPTrackerDelegate <NSObject>
- (void)faceMeshDidUpdate:(MPIrisTrackerH *)tracker
       didOutputLandmarks:(NSArray<MPLandmark *> *)landmarks
                timestamp:(long)timestamp;

- (void)irisTrackingDidUpdate:(MPIrisTrackerH *)tracker
           didOutputLandmarks:(NSArray<MPLandmark *> *)landmarks
                    timestamp:(long)timestamp;

- (void)frameWillUpdate:(MPIrisTrackerH *)tracker
    didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer
               timestamp:(long)timestamp;

- (void)frameDidUpdate:(MPIrisTrackerH *)tracker
    didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

@interface MPIrisTrackerH : NSObject
- (instancetype)init;

- (void)start;

@property(weak, nonatomic) id<MPTrackerDelegate> delegate;
@end

@interface MPLandmark : NSObject
@property(nonatomic, readonly) float x;
@property(nonatomic, readonly) float y;
@property(nonatomic, readonly) float z;
@end
