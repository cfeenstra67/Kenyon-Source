//
//  assynchronousImagePlacer.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "assynchronousImagePlacer.h"
#import "CLFURLRequestDelegate.h"

@implementation UIImageView (assynchronous)

-(void)CLFsetImageAtURL:(NSURL *)url withPlaceholder:(UIImage *)imagePlaceholder
{
    if(self.image!=nil)
    {
        return;
    }
    void (^fetchImage)(void(^)(UIImage*))=^(void (^completion)(UIImage*)){
        __block BOOL doneFlag=NO;
        __block UIImage *result=nil;
        NSURLSession *newSession=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        /*[[newSession downloadTaskWithURL:url completionHandler:^(NSURL *ul, NSURLResponse *resp, NSError *error){
            NSLog(@"completion called");
            if(error)
            {
                NSLog(@"error downloading image");
            }
            else
            {
                result=[UIImage imageWithContentsOfFile:ul.absoluteString];
                if(result==nil)
                {
                    NSLog(@"nil");
                }
                doneFlag=YES;
            }
        }] resume];*/
        [[newSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *resp, NSError *error){
            if(error)
            {
                NSLog(@"error downloading image");
            }
            else
            {
                result=[UIImage imageWithData:data];
                completion(result);
            }
        }] resume];
        [newSession finishTasksAndInvalidate];
        while(!doneFlag)
        {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
        }
        
    };
    
    NSBlockOperation *block=[NSBlockOperation blockOperationWithBlock:^{
        [self setImage:imagePlaceholder];
        [self layoutIfNeeded];
    }];
    [block setCompletionBlock:^{
        NSLog(@"completed");
        fetchImage(^(UIImage* image){
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self setImage:image];
            }];
        });
        NSLog(@"completed2");
    }];
    [[NSOperationQueue mainQueue] addOperation:block];
    
    //CLFURLRequestDelegate *delegate=[[CLFURLRequestDelegate alloc] init];
    
}

@end
