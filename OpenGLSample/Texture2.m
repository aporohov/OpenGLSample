//
//  Texture2.m
//  OpenGLSample
//
//  Created by mac on 17.03.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import "Texture2.h"

#define M_TAU (2*M_PI)

static BOOL initialized = NO;
static GLKVector3 vertices[4];
static GLKVector3 triangleVertices[6];
static int vertexIndices[6] = {
    0, 1, 2,
    3, 2, 0
};
static GLKBaseEffect *effect;
static GLKVector4 colors[4];
static GLKVector4 triangleColors[6];

@implementation Texture2

@synthesize position, rotation;
@synthesize textureCoordinates;
@synthesize fadeAnimation;

- (id)init
{
    self = [super init];
    if (self) {
        
        position = GLKVector3Make(0,0,0);
        rotation = GLKVector3Make(0,0,0);
        
        vertices[0] = GLKVector3Make(-0.5, -0.5,  0.0); // Left  bottom front
        vertices[1] = GLKVector3Make( 0.5, -0.5,  0.0); // Right bottom front
        vertices[2] = GLKVector3Make( 0.5,  0.5,  0.0); // Right top    front
        vertices[3] = GLKVector3Make(-0.5,  0.5,  0.0); // Left  top    front
        
        for (int i = 0; i < 6; i++) {
            triangleVertices[i] = vertices[vertexIndices[i]];
        }
        
        alpha = 1.0;
        
        effect = [[GLKBaseEffect alloc] init];
        
        fadeAnimation = NO;
        fadeIncr = NO;
        
        initialized = YES;
        
        [self setColors];
    }
    
    return self;
}

- (void)setColors
{
    colors[0] = GLKVector4Make(0.0, 0.0, 0.0, alpha);
    colors[1] = GLKVector4Make(0.0, 0.0, 0.0, alpha);
    colors[2] = GLKVector4Make(0.0, 0.0, 0.0, alpha);
    colors[3] = GLKVector4Make(0.0, 0.0, 0.0, alpha);
    
    for (int i = 0; i < 6; i++) {
        triangleColors[i] = colors[vertexIndices[i]];
    }
}

- (void)draw
{
    GLKMatrix4 xRotationMatrix = GLKMatrix4MakeXRotation(rotation.x);
    GLKMatrix4 yRotationMatrix = GLKMatrix4MakeYRotation(rotation.y);
    GLKMatrix4 zRotationMatrix = GLKMatrix4MakeZRotation(rotation.z);
    
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(position.x, position.y, position.z);
    
    GLKMatrix4 modelMatrix =
    GLKMatrix4Multiply(translateMatrix,
                             GLKMatrix4Multiply(zRotationMatrix,
                                             GLKMatrix4Multiply(yRotationMatrix, xRotationMatrix)));
    
    GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 5, 0, 0, 0, 0, 1, 0);
    effect.transform.modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
    
    effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 2.0/3.0, 2, -1);
    
    if (texture != nil) {
        effect.texture2d0.envMode = GLKTextureEnvModeDecal;
        effect.texture2d0.target = GLKTextureTarget2D;
        effect.texture2d0.name = texture.name;
    }
    
    [effect prepareToDraw];
    
    glEnable(GL_CULL_FACE);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    glEnable(GL_BLEND);
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);      //blending for texture2

    glVertexAttribPointer(GLKVertexAttribPosition,  3, GL_FLOAT, GL_FALSE, 0, triangleVertices);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, self.textureCoordinates);
    glVertexAttribPointer(GLKVertexAttribColor,     4, GL_FLOAT, GL_FALSE, 0, triangleColors);
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 6);
    
    glDisable(GL_BLEND);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
    glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
    glDisableVertexAttribArray(GLKVertexAttribColor);
}

- (void)updateAnimation:(NSTimeInterval)dt
{
    if (fadeIncr) {
        alpha += 1.0 * dt;
    } else {
        alpha -= 1.0 * dt;
    }
    if (alpha >= 1.0) {
        alpha = 1.0;
        fadeIncr = NO;
        NSLog(@"stop fade animation");
        fadeAnimation = NO;
    }
    if (alpha <= 0.0) {
        alpha = 0.0;
        fadeIncr = YES;
    }
    [self setColors];
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
