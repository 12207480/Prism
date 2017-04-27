//
//  TYURLProtocol.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/13.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYURLProtocol.h"
#import "NSURLSessionConfiguration+TYURLProtocol.h"

#define kTYURLRequestKey @"TYURLRequestKey"

static BOOL isRegisterProtocol = NO;
static BOOL hookNSURLSessionConfiguration = YES;

@interface TYURLProtocol() <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *ty_connection;
@property (nonatomic, strong) NSURLRequest *ty_request;
@property (nonatomic, strong) NSURLResponse *ty_response;
@property (nonatomic, strong) NSMutableData *ty_data;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation TYURLProtocol

+ (NSHashTable *)hashTable {
    static NSHashTable<NSObject *> *hashTable = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hashTable = [NSHashTable weakObjectsHashTable];
    });
    return hashTable;
}

#pragma mark - public

+ (void)start {
    if (isRegisterProtocol) {
        return;
    }
    isRegisterProtocol = YES;
    [NSURLProtocol registerClass:self];
    if (hookNSURLSessionConfiguration) {
        [NSURLSessionConfiguration start];
    }
}

+ (void)stop {
    if (!isRegisterProtocol) {
        return;
    }
    isRegisterProtocol = NO;
    [NSURLProtocol unregisterClass:self];
    if (hookNSURLSessionConfiguration) {
        [NSURLSessionConfiguration stop];
    }
}

+ (void)setHookNSURLSessionConfiguration:(BOOL)hook {
    hookNSURLSessionConfiguration = hook;
    if (!hook) {
        [NSURLSessionConfiguration stop];
    }
}

+ (void)addDelegate:(id<TYURLProtocolDelegate>)delegate {
    if (!delegate) {
        return;
    }
    [[self hashTable]addObject:delegate];
    if ([self hashTable].count > 0) {
        [self start];
    }
}

+ (void)removeDelegate:(id<TYURLProtocolDelegate>)delegate {
    if (!delegate) {
        return;
    }
    [[self hashTable]removeObject:delegate];
    if ([self hashTable].count == 0) {
        [self stop];
    }
}

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"]
        && ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:kTYURLRequestKey inRequest:request]) {
        return NO;
    }
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [NSURLProtocol setProperty:@(YES) forKey:kTYURLRequestKey inRequest:mutableRequest];
    return [mutableRequest copy];
}

- (void)startLoading {
    _startDate = [NSDate date];
    NSURLRequest *request = [[self class] canonicalRequestForRequest:self.request];
    self.ty_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    self.ty_request = self.request;
}

- (void)stopLoading {
    [self.ty_connection cancel];
    _endDate = [NSDate date];
    
    for (id<TYURLProtocolDelegate> delegate in [[self class]hashTable]) {
        if ([delegate respondsToSelector:@selector(URLProtocolDidCatchURLRequest:)]) {
            [delegate URLProtocolDidCatchURLRequest:self];
        }
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [self.client URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

#pragma mark - NSURLConnectionDataDelegate

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    if (response != nil) {
        self.ty_response = response;
        [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.ty_response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    if (!self.ty_data) {
        self.ty_data = [NSMutableData dataWithData:data];
    }else {
        [self.ty_data appendData:data];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}

@end
