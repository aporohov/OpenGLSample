//
//  AppDelegate.m
//  OpenGLSample
//
//  Created by mac on 16.03.13.
//  Copyright (c) 2013 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "Texture1.h"
#import "Texture2.h"

@interface AppDelegate ()
{
    CGFloat redColor;
    CGFloat greenColor;
    CGFloat blueColor;
    
    GLKView *view;
    
    Texture1 *tex1;
    Texture2 *tex2;
    
    //norm coef for tex1 and tex2
    float norm1x;
    float norm1y;
    float norm2x;
    float norm2y;
    
    //difference between touch point and center of object
    float dx;
    float dy;
    
    BOOL tex1Moving;
    BOOL tex2Moving;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    
    view = [[GLKView alloc]initWithFrame:[[UIScreen mainScreen]bounds] context:context];
    view.delegate = self;
    
    GLKViewController *controller = [[GLKViewController alloc]init];
    controller.delegate = self;
    controller.view = view;
    
    [self randBackgroundColors];
    
    tex1 = [[Texture1 alloc] init];
    tex1.position = GLKVector2Make(0.0, 0.0);
    [tex1 setTextureImage:[UIImage imageNamed:@"planetexpress.png"]];
    tex1.textureCoordinates[0] = GLKVector2Make(0,1);
    tex1.textureCoordinates[1] = GLKVector2Make(1,1);
    tex1.textureCoordinates[2] = GLKVector2Make(1,0);
    tex1.textureCoordinates[3] = GLKVector2Make(0,0);
    tex1Moving = NO;
    norm1x = 320/4;
    norm1y = 460/6;
    
    tex2 = [[Texture2 alloc] init];
    tex2.position = GLKVector3Make(0.0, 1.0, 0.0);
    [tex2 setTextureImage:[UIImage imageNamed:@"image.png"]];
    tex2.textureCoordinates[0] = GLKVector2Make(0,1);
    tex2.textureCoordinates[1] = GLKVector2Make(1,1);
    tex2.textureCoordinates[2] = GLKVector2Make(1,0);
    tex2.textureCoordinates[3] = GLKVector2Make(0,0);
    tex2Moving = NO;
    norm2x = 320/3;
    norm2y = 460/4;
    
    UIButton *fadeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    fadeButton.frame = CGRectMake(50, 400, 220, 50);
    [fadeButton addTarget:self
               action:@selector(buttonClicked)
     forControlEvents:UIControlEventTouchDown];
    [fadeButton setTitle:@"Fade in/out" forState:UIControlStateNormal];
    [view addSubview:fadeButton];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = controller;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)buttonClicked
{
    NSLog(@"start fade");
    tex2.fadeAnimation = YES;
}

#pragma mark - GLKViewControllerDelegate

- (void)glkViewControllerUpdate:(GLKViewController *)controller
{ 
    if(tex2.fadeAnimation){
        NSTimeInterval dt = [controller timeSinceLastDraw];
        [tex2 updateAnimation:dt];
    }
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(redColor, greenColor, blueColor, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    [tex1 draw];
    [tex2 draw];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!tex2.fadeAnimation){
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        CGPoint touchLocation = [touch locationInView:view];
        touchLocation = CGPointMake(touchLocation.x, 460 - touchLocation.y);
        
        CGRect rect1 = CGRectMake((160-1.5*norm1x)+norm1x*tex1.position.x, (230-norm1y)-norm1y*tex1.position.y, 3*norm1x, 2*norm1y);
        CGRect rect2 = CGRectMake((160-0.5*norm2x)+norm2x*tex2.position.x, (230-0.5*norm2y)-norm2y*tex2.position.y, 1*norm2x, 1*norm2y);
        
        if (CGRectContainsPoint(rect2, CGPointMake(touchLocation.x, 460 - touchLocation.y))) {
            NSLog(@"texture2 tapped");
            tex2Moving = YES;
            dx = touchLocation.x - 160 - norm2x * tex2.position.x;
            dy = touchLocation.y - 250 - norm2y * tex2.position.y;
        }
        else if (CGRectContainsPoint(rect1, CGPointMake(touchLocation.x, 460 - touchLocation.y))) {
            NSLog(@"texture1 tapped");
            tex1Moving = YES;
            dx = touchLocation.x - 160 - norm1x * tex1.position.x;
            dy = touchLocation.y - 250 - norm1y * tex1.position.y;
            [self randBackgroundColors];
        }
        else{
            NSLog(@"nothing tapped");
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* touch in touches)
    {
        CGPoint newPoint = [touch locationInView:_window];
        
        if(tex2Moving){
            
            [tex2 setPosition:GLKVector3Make((newPoint.x - dx - 160)/norm2x, (230 - newPoint.y - dy)/norm2y, 0.0)];
            tex2.rotation = GLKVector3Make(0.0,(160 - newPoint.x+dx)/140,0.0);
        }
        else if(tex1Moving){
        
            [tex1 setPosition:GLKVector2Make((newPoint.x - dx - 160)/norm1x, (230 - newPoint.y - dy)/norm1y)];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    tex1Moving = NO;
    tex2Moving = NO;
}

//randomize background color
- (void)randBackgroundColors{
    redColor = ( arc4random() % 256 / 256.0 );
    greenColor = ( arc4random() % 256 / 256.0 );
    blueColor = ( arc4random() % 256 / 256.0 );
}

@end
