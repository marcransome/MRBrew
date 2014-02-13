//
//  MRBrewWatcher.m
//  MRBrew
//
//  Copyright (c) 2013 Marc Ransome <marc.ransome@fidgetbox.co.uk>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "MRBrewWatcher.h"

NSString* const MRBrewLibraryLocationPath = @"/usr/local/Library";
NSString* const MRBrewFormulaLocationPath = @"/usr/local/Library/Formula";
NSString* const MRBrewTapsLocationPath = @"/usr/local/Library/Taps";
NSString* const MRBrewAliasesLocationPath = @"/usr/local/Library/Aliases";
NSString* const MRBrewLinkedKegsLocationPath = @"/usr/local/Library/LinkedKegs";
NSString* const MRBrewPinnedKegsLocationPath = @"/usr/local/Library/PinnedKegs";

@interface MRBrewWatcher ()
{
    @private
    FSEventStreamRef _eventStream;
    NSMutableArray *_pathsToWatch;
}

@end

@implementation MRBrewWatcher
{} // allows pragma parser to parse marks before first method

#pragma mark - Lifecycle

- (instancetype)init {
    return [self initWithLocation:(MRBrewWatcherLocation)0 delegate:nil];
}

- (instancetype)initWithLocation:(MRBrewWatcherLocation)location delegate:(id<MRBrewWatcherDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        // test bitmask for paths to use
        _pathsToWatch = [NSMutableArray array];
        if (location & MRBrewWatcherLibraryLocation) {
            [_pathsToWatch addObject:MRBrewLibraryLocationPath];
        }
        // since the library path contains all other paths we test
        // this exclusively and only test for other options in the
        // else clause if the library location bit has not been set
        else {
            if (location & MRBrewWatcherFormulaLocation) {
                [_pathsToWatch addObject:MRBrewFormulaLocationPath];
            }
            
            if (location & MRBrewWatcherTapsLocation) {
                [_pathsToWatch addObject:MRBrewTapsLocationPath];
            }
            
            if (location & MRBrewWatcherAliasesLocation) {
                [_pathsToWatch addObject:MRBrewAliasesLocationPath];
            }
            
            if (location & MRBrewWatcherLinkedKegsLocation) {
                [_pathsToWatch addObject:MRBrewLinkedKegsLocationPath];
            }
            
            if (location & MRBrewWatcherPinnedKegsLocation) {
                [_pathsToWatch addObject:MRBrewPinnedKegsLocationPath];
            }
        }
        
        _delegate = delegate;
    }
    
    return self;
}

- (instancetype)initWithPath:(NSString *)path delegate:(id<MRBrewWatcherDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        _pathsToWatch = [NSMutableArray array];
        [_pathsToWatch addObject:path];
        _delegate = delegate;
    }
    
    return self;
}

+ (instancetype)watcherWithLocation:(MRBrewWatcherLocation)location delegate:(id<MRBrewWatcherDelegate>)delegate
{
    return [[self alloc] initWithLocation:location delegate:delegate];
}

+ (instancetype)watcherWithPath:(NSString *)path delegate:(id<MRBrewWatcherDelegate>)delegate
{
    return [[self alloc] initWithPath:path delegate:delegate];
}

#pragma mark - FSEvents Callback

static void fileSystemEventsCallback(ConstFSEventStreamRef streamRef, void *userData, size_t numEvents, void *eventPaths, const FSEventStreamEventFlags eventFlags[], const FSEventStreamEventId eventIds[])
{
    MRBrewWatcher *informer = (__bridge MRBrewWatcher *)userData;
    
    NSMutableArray *modifiedPaths = [NSMutableArray array];
    
    size_t i;
    for(i = 0; i < numEvents; i++){
        if(![modifiedPaths containsObject:[(__bridge NSArray *)eventPaths objectAtIndex:i]]) {
            [modifiedPaths addObject:[(__bridge NSArray *)eventPaths objectAtIndex:i]];
        }
    }
    
    if ([[informer delegate] respondsToSelector:@selector(brewChangeDidOccur:)]) {
        [[informer delegate] brewChangeDidOccur:modifiedPaths];
    }
}

#pragma mark - Control

- (void)startWatching
{
    // stop existing event stream if one exists
    if (_eventStream) {
		[self stopWatching];
	}
    
    // create an event stream context with a reference to this
    // watcher object for use by our callback method
    FSEventStreamContext eventStreamContext;
    eventStreamContext.info = (__bridge void *)(self);
    eventStreamContext.version = 0;
    eventStreamContext.retain = NULL;
    eventStreamContext.release = NULL;
    eventStreamContext.copyDescription = NULL;
    
    // create an event stream and register a callback
    NSTimeInterval latency = 3.0;
    _eventStream = FSEventStreamCreate(NULL,
                                       &fileSystemEventsCallback,
                                       &eventStreamContext,
                                       (__bridge CFArrayRef) _pathsToWatch,
                                       kFSEventStreamEventIdSinceNow,
                                       (CFAbsoluteTime) latency,
                                       kFSEventStreamCreateFlagUseCFTypes);
    
    FSEventStreamScheduleWithRunLoop(_eventStream,
                                     CFRunLoopGetCurrent(),
                                     kCFRunLoopDefaultMode);
    FSEventStreamStart(_eventStream);
}

- (void)stopWatching
{
	if (!(_eventStream)) {
		return;
	}
    
	FSEventStreamStop(_eventStream);
	FSEventStreamInvalidate(_eventStream);
	FSEventStreamRelease(_eventStream);
	_eventStream = NULL;
}

- (BOOL)isWatching {
    return _eventStream != NULL;
}

@end
