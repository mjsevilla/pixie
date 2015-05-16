//
//  GPUImageTwoPassTextureSamplingFilter.h
//  Pixie
//
//  Created by Nicole on 5/16/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

#ifndef Pixie_GPUImageTwoPassTextureSamplingFilter_h
#define Pixie_GPUImageTwoPassTextureSamplingFilter_h

#import "GPUImageTwoPassFilter.h"

@interface GPUImageTwoPassTextureSamplingFilter : GPUImageTwoPassFilter
{
   GLint verticalPassTexelWidthOffsetUniform, verticalPassTexelHeightOffsetUniform, horizontalPassTexelWidthOffsetUniform, horizontalPassTexelHeightOffsetUniform;
   GLfloat verticalPassTexelWidthOffset, verticalPassTexelHeightOffset, horizontalPassTexelWidthOffset, horizontalPassTexelHeightOffset;
   CGFloat _verticalTexelSpacing, _horizontalTexelSpacing;
}

// This sets the spacing between texels (in pixels) when sampling for the first. By default, this is 1.0
@property(readwrite, nonatomic) CGFloat verticalTexelSpacing, horizontalTexelSpacing;

@end

#endif
