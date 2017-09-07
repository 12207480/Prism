//
//  TYNetWorkInfo.m
//  PrismMonitorDemo
//
//  Created by tany on 2017/4/14.
//  Copyright © 2017年 tany. All rights reserved.
//

#import "TYNetWorkInfo.h"

@implementation TYNetWorkInfo

- (void)setRequest:(NSURLRequest *)request
{
    _request = request;
    
    _url = request.URL;
    _httpMethod = request.HTTPMethod;
    _requestAllHTTPHeaderFields = request.allHTTPHeaderFields;
    _httpBody = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
}

- (void)setResponse:(NSHTTPURLResponse *)response {
    _response = response;
    
    _MIMEType = response.MIMEType;
    _statusCode = response.statusCode;
    _expectedContentLength = response.expectedContentLength;
    _suggestedFilename = response.suggestedFilename;
    _responseAllHeaderFields = response.allHeaderFields;
}

- (void)setData:(NSData *)data {
    _data = data;
    
    [self parseReponseData];
}

- (void)parseReponseData {
    // 引用自https://github.com/coderyi/NetworkEye
    NSString *mimeType = _response.MIMEType;
    if ([mimeType isEqualToString:@"application/json"] || [mimeType isEqualToString:@"text/plain"] || [mimeType isEqualToString:@"text/html"]) {
        _responseData = [self responseJSONFromData:self.data];
    } else if ([mimeType isEqualToString:@"text/javascript"]) {
        // try to parse json if it is jsonp request
        NSString *jsonString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        // formalize string
        if ([jsonString hasSuffix:@")"]) {
            jsonString = [NSString stringWithFormat:@"%@;", jsonString];
        }
        if ([jsonString hasSuffix:@");"]) {
            NSRange range = [jsonString rangeOfString:@"("];
            if (range.location != NSNotFound) {
                range.location++;
                range.length = [jsonString length] - range.location - 2; // removes parens and trailing semicolon
                jsonString = [jsonString substringWithRange:range];
                NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                _responseData = [self responseJSONFromData:jsonData];
            }
        }
        
    }else if ([mimeType isEqualToString:@"application/xml"] || [mimeType isEqualToString:@"text/xml"]){
        NSString *xmlString = [[NSString alloc]initWithData:self.data encoding:NSUTF8StringEncoding];
        if (xmlString && xmlString.length>0) {
            _responseData = xmlString;
        }
    }
}

-(id)responseJSONFromData:(NSData *)data {
    if(data == nil) return nil;
    NSError *error = nil;
    id returnValue = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error) {
        NSLog(@"JSON Parsing Error: %@", error);
        return nil;
    }
    if (!returnValue || returnValue == [NSNull null]) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnValue options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
@end
