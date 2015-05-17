//
//  GPUImageTwoPassFilter.h
//  Pixie
//
//  Created by Nicole on 5/16/15.
//  Copyright (c) 2015 Mike Sevilla. All rights reserved.
//

#ifndef Pixie_GPUImageTwoPassFilter_h
#define Pixie_GPUImageTwoPassFilter_h

#import "GPUImageFilter.h"

@interface GPUImageTwoPassFilter : GPUImageFilter
{
   GPUImageFramebuffer *secondOutputFramebuffer;
   
   GLProgram *secondFilterProgram;
   GLint secondFilterPositionAttribute, secondFilterTextureCoordinateAttribute;
   GLint secondFilterInputTextureUniform, secondFilterInputTextureUniform2;
   
   NSMutableDictionary *secondProgramUniformStateRestorationBlocks;
}

// Initialization and teardown
- (id)initWithFirstStageVertexShaderFromString:(NSString *)firstStageVertexShaderString firstStageFragmentShaderFromString:(NSString *)firstStageFragmentShaderString secondStageVertexShaderFromString:(NSString *)secondStageVertexShaderString secondStageFragmentShaderFromString:(NSString *)secondStageFragmentShaderString;
- (id)initWithFirstStageFragmentShaderFromString:(NSString *)firstStageFragmentShaderString secondStageFragmentShaderFromString:(NSString *)secondStageFragmentShaderString;
- (void)initializeSecondaryAttributes;

@end

#endif
