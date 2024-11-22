//
//  GalleryViewManager.m
//  CameraRoll
//
//  Created by Дмитрий Ворошилло on 02.11.2024.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(GalleryViewManager, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(onSelectMedia, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(isMultiSelectEnabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(multiSelectStyle, NSDictionary)
RCT_EXTERN_METHOD(getSelectedMedia:(nonnull NSNumber *)viewTag
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
@end

