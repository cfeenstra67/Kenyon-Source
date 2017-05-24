//
//  CLFURLRequestDelegate.m
//  KenyonMobile v0.0
//
//  Created by Cam Feenstra on 1/30/17.
//  Copyright © 2017 Cameron Feenstra. All rights reserved.
//

#import "CLFURLRequestDelegate.h"

@implementation CLFURLRequestDelegate

//NSURLSessionDelegate

-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error;
{
    
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    
}

//NSURLConnectionDownloadDelegate

-(void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

-(void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL{
    NSLog(@"finished downloading");
    
}

//NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(nonnull NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

@end
