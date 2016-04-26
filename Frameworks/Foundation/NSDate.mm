//******************************************************************************
//
// Copyright (c) 2015 Microsoft Corporation. All rights reserved.
//
// This code is licensed under the MIT License (MIT).
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//******************************************************************************
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

#import "Starboard.h"
#import "StubReturn.h"
#import <Foundation/NSDate.h>
#import <CoreFoundation/CoreFoundation.h>

#import "LoggingNative.h"
#import "NSRaise.h"
#import "BridgeHelpers.h"
#import "NSCFDate.h"

NSDateFormatter* _getDescriptionFormatter() {
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss Z"];
    [formatter setTimeZone:static_cast<NSTimeZone*>(CFTimeZoneCreateWithTimeIntervalFromGMT(kCFAllocatorSystemDefault, 0.0))];
    return formatter;
}

NSDateFormatter* _getLocaleDescriptionFormatter(NSLocale* locale) {
    CFDateFormatterRef formatter = CFDateFormatterCreate(kCFAllocatorSystemDefault,
                                                         static_cast<CFLocaleRef>(locale),
                                                         kCFDateFormatterFullStyle,
                                                         kCFDateFormatterFullStyle);
    CFDateFormatterSetProperty(formatter, kCFDateFormatterTimeZone, CFTimeZoneCopySystem());

    return static_cast<NSDateFormatter*>(formatter);
}

@implementation NSDate

/**
 @Status Interoperable
*/
+ ALLOC_PLACEHOLDER_SUBCLASS_WITH_ZONE(NSDate, NSDatePlaceholder);

/**
 @Status Interoperable
*/
+ (double)timeIntervalSinceReferenceDate {
    return CFAbsoluteTimeGetCurrent();
}

/**
 @Status Interoperable
*/
- (double)timeIntervalSinceReferenceDate {
    return NSInvalidAbstractInvocationReturn();
}

/**
 @Status Interoperable
*/
- (double)timeIntervalSinceNow {
    return ([self timeIntervalSinceReferenceDate] - [NSDate timeIntervalSinceReferenceDate]);
}

/**
 @Status Interoperable
*/
- (double)timeIntervalSince1970 {
    return [self timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970;
}

/**
 @Status Interoperable
*/
- (double)timeIntervalSinceDate:(id)ref {
    return [self timeIntervalSinceReferenceDate] - [ref timeIntervalSinceReferenceDate];
}

/**
 @Status Interoperable
*/
+ (NSDate*)date {
    return [[[self allocWithZone:nil] initWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate]] autorelease];
}

/**
 @Status Interoperable
*/
+ (NSDate*)distantPast {
    static StrongId<NSDate> staticInstance =
        [[self allocWithZone:nil] initWithTimeIntervalSinceReferenceDate:-(2010.0L * 365 * 24 * 60 * 60)];
    return staticInstance;
}

/**
 @Status Interoperable
*/
+ (NSDate*)distantFuture {
    static StrongId<NSDate> staticInstance = [[self allocWithZone:nil] initWithTimeIntervalSinceReferenceDate:2010.0L * 365 * 24 * 60 * 60];
    return staticInstance;
}

/**
 @Status Interoperable
*/
+ (NSDate*)dateWithTimeIntervalSinceNow:(double)secondsSinceNow {
    return [[[self allocWithZone:nil] initWithTimeIntervalSinceNow:secondsSinceNow] autorelease];
}

/**
 @Status Interoperable
*/
- (NSDate*)dateByAddingTimeInterval:(double)interval {
    return
        [[[NSDate allocWithZone:nil] initWithTimeIntervalSinceReferenceDate:[self timeIntervalSinceReferenceDate] + interval] autorelease];
}

/**
 @Status Interoperable
*/
+ (NSDate*)dateWithTimeIntervalSince1970:(double)secondsSince1970 {
    return
        [[[self allocWithZone:nil] initWithTimeIntervalSinceReferenceDate:-NSTimeIntervalSince1970 + (double)secondsSince1970] autorelease];
}

/**
 @Status Interoperable
*/
+ (NSDate*)dateWithTimeInterval:(double)interval sinceDate:(NSDate*)date {
    return [date dateByAddingTimeInterval:interval];
}

/**
 @Status Interoperable
*/
+ (NSDate*)dateWithTimeIntervalSinceReferenceDate:(double)secondsSinceRef {
    return [[[self allocWithZone:nil] initWithTimeIntervalSinceReferenceDate:secondsSinceRef] autorelease];
}

/**
 @Status Stub
*/
- (NSDate*)initWithCoder:(NSCoder*)coder {
    UNIMPLEMENTED();
    return StubReturn();
}

/**
 @Status Interoperable
*/
+ (NSDate*)dateWithString:(NSString*)string {
    return [[[self alloc] initWithString:string] autorelease];
}

/**
 @Status Interoperable
*/
- (NSDate*)initWithString:(NSString*)string {
    return NSInvalidAbstractInvocationReturn();
}

/**
 @Status Interoperable
*/
- (NSDate*)initWithTimeIntervalSince1970:(double)secondsSince1970 {
    return [self initWithTimeIntervalSinceReferenceDate:-NSTimeIntervalSince1970 + (double)secondsSince1970];
}

/**
 @Status Interoperable
*/
- (NSDate*)initWithTimeIntervalSinceNow:(double)secondsSinceNow {
    return [self initWithTimeIntervalSinceReferenceDate:[NSDate timeIntervalSinceReferenceDate] + secondsSinceNow];
}

/**
 @Status Interoperable
*/
- (NSDate*)initWithTimeIntervalSinceReferenceDate:(double)ref {
    return NSInvalidAbstractInvocationReturn();
}

/**
 @Status Interoperable
*/
- (NSDate*)initWithTimeInterval:(double)seconds sinceDate:(NSDate*)date {
    return [self initWithTimeIntervalSinceReferenceDate:[date timeIntervalSinceReferenceDate] + seconds];
}

/**
 @Status Interoperable
*/
- (NSInteger)compare:(NSDate*)toDate {
    if (toDate == nil) {
        return -1;
    }

    if ([self timeIntervalSinceReferenceDate] == [toDate timeIntervalSinceReferenceDate]) {
        return 0;
    } else if ([self timeIntervalSinceReferenceDate] > [toDate timeIntervalSinceReferenceDate]) {
        return 1;
    } else {
        return -1;
    }
}

/**
 @Status Interoperable
*/
- (NSInteger)isEqualToDate:(NSDate*)toDate {
    if (![toDate isKindOfClass:[NSDate class]]) {
        return FALSE;
    }

    if ([self timeIntervalSinceReferenceDate] == [toDate timeIntervalSinceReferenceDate]) {
        return TRUE;
    } else {
        return FALSE;
    }
}

/**
 @Status Interoperable
*/
- (BOOL)isEqual:(NSDate*)toDate {
    if (self == toDate) {
        return TRUE;
    }

    if (![toDate isKindOfClass:[NSDate class]]) {
        return FALSE;
    }
    return [self isEqualToDate:(id)toDate];
}

/**
 @Status Interoperable
*/
- (NSUInteger)hash {
    NSUInteger hashRet[2];
    double interval = [self timeIntervalSinceReferenceDate];
    memcpy(hashRet, &interval, sizeof(double));
    hashRet[0] ^= hashRet[1];

    return hashRet[0];
}

/**
 @Status Interoperable
*/
- (NSDate*)earlierDate:(NSDate*)toDate {
    if ([self timeIntervalSinceReferenceDate] == [toDate timeIntervalSinceReferenceDate]) {
        return self;
    } else if ([self timeIntervalSinceReferenceDate] > [toDate timeIntervalSinceReferenceDate]) {
        return toDate;
    } else {
        return self;
    }
}

/**
 @Status Interoperable
*/
- (NSDate*)laterDate:(NSDate*)toDate {
    if ([self timeIntervalSinceReferenceDate] == [toDate timeIntervalSinceReferenceDate]) {
        return self;
    } else if ([self timeIntervalSinceReferenceDate] < [toDate timeIntervalSinceReferenceDate]) {
        return toDate;
    } else {
        return self;
    }
}

/**
 @Status Interoperable
*/
- (NSObject*)copyWithZone:(NSZone*)zone {
    return [self retain];
}

/**
 @Status Interoperable
*/
- (NSDate*)addTimeInterval:(double)seconds {
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self timeIntervalSinceReferenceDate] + seconds];
}

/**
 @Status Stub
*/
- (void)encodeWithCoder:(NSCoder*)coder {
    UNIMPLEMENTED();
}

/**
 @Status Interoperable
*/
- (NSString*)description {
    static StrongId<NSDateFormatter> formatter = _getDescriptionFormatter();
    return [formatter stringFromDate:self];
}

/**
 @Status Interoperable
 @Notes
*/
- (NSString*)descriptionWithLocale:(id)locale {
    if (locale) {
        static StrongId<NSDateFormatter> formatter = _getLocaleDescriptionFormatter(locale);
        return [formatter stringFromDate:self];
    } else {
        return [self description];
    }
}

/**
 @Status Stub
 @Notes
*/
+ (BOOL)supportsSecureCoding {
    UNIMPLEMENTED();
    return StubReturn();
}

@end
