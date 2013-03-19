//
//  Texture2.h
//  OpenGLSample
//
//  Created by mac on 17.03.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Texture2 : NSObject{
    GLKVector3 position;
    GLKVector3 rotation;
    
    GLKTextureInfo *texture;
    NSMutableData *textureCoordinateData;
    
    BOOL fadeAnimation;
    BOOL fadeIncr;
    float alpha;
}

@property GLKVector3 position, rotation;

@property(readonly) GLKVector2 *textureCoordinates;
@property BOOL fadeAnimation;

- (void)draw;
- (void)updateAnimation:(NSTimeInterval)dt;
- (void)setTextureImage:(UIImage *)image;

@end

