//
//  Texture1.m
//  OpenGLSample
//
//  Created by mac on 17.03.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import "Texture1.h"

static BOOL initialized = NO;
static GLKVector2 vertices[4];
static GLKVector2 triangleVertices[6];
static int vertexIndices[6] = {
    0, 1, 2,
    3, 2, 0
};
static GLKBaseEffect *effect;

@implementation Texture1

@synthesize position;
@synthesize textureCoordinates;

@synthesize left, right, bottom, top;

- (id)init
{
    self = [super init];
    if (self) {
        position = GLKVector2Make(0,0);
        
        left   = -2;
        right  =  2;
        bottom = -3;
        top    =  3;
    }
    return self;
}

+ (void)initialize {
    if (!initialized) {
        
        vertices[0] = GLKVector2Make(-1.5, -1.0); // Left  bottom front
        vertices[1] = GLKVector2Make( 1.5, -1.0); // Right bottom front
        vertices[2] = GLKVector2Make( 1.5,  1.0); // Right top    front
        vertices[3] = GLKVector2Make(-1.5,  1.0); // Left  top    front
        
        for (int i = 0; i < 6; i++) {
            triangleVertices[i] = vertices[vertexIndices[i]];
        }
        
        effect = [[GLKBaseEffect alloc] init];
        
        initialized = YES;
    }
}

- (void)draw
{
    effect.transform.projectionMatrix = GLKMatrix4MakeOrtho(left, right, bottom, top, 1, -1);
    effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(position.x, position.y, 0.0);
    
    if (texture != nil) {
        effect.texture2d0.envMode = GLKTextureEnvModeReplace;
        effect.texture2d0.target = GLKTextureTarget2D;
        effect.texture2d0.name = texture.name;
    }
    
    [effect prepareToDraw];
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glVertexAttribPointer(GLKVertexAttribPosition,  2, GL_FLOAT, GL_FALSE, 0, triangleVertices);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, self.textureCoordinates);

    glDrawArrays(GL_TRIANGLE_FAN, 0, 6);
    
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
}

- (void)setTextureImage:(UIImage *)image
{
    NSError *error;
    texture = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:&error];
    if (error) {
        NSLog(@"Error loading texture from image: %@",error);
    }
}

- (GLKVector2 *)textureCoordinates {
    if (textureCoordinateData == nil)
        textureCoordinateData = [NSMutableData dataWithLength:sizeof(GLKVector2)*6];
    return [textureCoordinateData mutableBytes];
}

@end
