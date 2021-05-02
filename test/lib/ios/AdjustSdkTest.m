//
//  AdjustSdkTest.m
//  Adjust SDK Test
//
//  Created by Uglješa Erceg (@uerceg) on 11th June 2018.
//  Copyright © 2018 Adjust GmbH. All rights reserved.
//

#import "AdjustSdkTest.h"
#import "ATLTestLibrary.h"
#import "ASTCommandListener.h"

@implementation AdjustSdkTest {
    ATLTestLibrary *testLibrary;
    ASTCommandListener *adjustCommandListener;
    NSMutableArray *selectedTests;
    NSMutableArray *selectedTestDirs;
}

RCT_EXPORT_MODULE();

#pragma mark - Public methods

RCT_EXPORT_METHOD(startTestSession:(NSString *)baseUrl controlUrl:(NSString *)controlUrl sdkVersion:(NSString *)sdkVersion) {
    if (![self isFieldValid:baseUrl]) {
        return;
    }

    adjustCommandListener = [[ASTCommandListener alloc] init];
    testLibrary = [ATLTestLibrary testLibraryWithBaseUrl:baseUrl
                                           andControlUrl:controlUrl
                                      andCommandDelegate:adjustCommandListener];

    for (id object in selectedTests) {
        [testLibrary addTest:object];
    }
    for (id object in selectedTestDirs) {
        [testLibrary addTestDirectory:object];
    }

    // Start test session.
    [testLibrary startTestSession:sdkVersion];
}

RCT_EXPORT_METHOD(addInfoToSend:(NSString *)key value:(NSString *)value) {
    if (testLibrary != nil) {
        [testLibrary addInfoToSend:key value:value];
    }
}

RCT_EXPORT_METHOD(sendInfoToServer:(NSString *)basePath) {
    if (testLibrary != nil) {
        [testLibrary sendInfoToServer:basePath];
    }
}

RCT_EXPORT_METHOD(addTest:(NSString *)testToAdd) {
    if (selectedTests == nil) {
        selectedTests = [NSMutableArray array];
    }
    [selectedTests addObject:testToAdd];
}

RCT_EXPORT_METHOD(addTestDirectory:(NSString *)testDirToAdd) {
    if (selectedTestDirs == nil) {
        selectedTestDirs = [NSMutableArray array];
    }

    [selectedTestDirs addObject:testDirToAdd];
}

RCT_EXPORT_METHOD(setTestConnectionOptions) {
    // nothing for now, Android functionality only
}

#pragma mark - Private & helper methods

- (BOOL)isFieldValid:(NSObject *)field {
    if (field == nil) {
        return false;
    }

    // Check if its an instance of the singleton NSNull.
    if ([field isKindOfClass:[NSNull class]]) {
        return false;
    }

    // If 'field' can be converted to a string, check if it has any content.
    NSString *str = [NSString stringWithFormat:@"%@", field];
    if (str != nil) {
        if ([str length] == 0) {
            return false;
        }
        if ([str isEqualToString:@"null"]) {
            return false;
        }
    }

    return true;
}

@end
