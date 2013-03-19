//
//  Texture1.h
//  OpenGLSample
//
//  Created by mac on 17.03.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Texture1 : NSObject{
    GLKVector2 position;

    GLKTextureInfo *texture;
    NSMutableData *textureCoordinateData;
    
    //view frame
    float left, right, bottom, top;
}

@property GLKVector2 position;
@property float left, right, bottom, top;
@property(readonly) GLKVector2 *textureCoordinates;

- (void)draw;
- (void)setTextureImage:(UIImage *)image;

@end
