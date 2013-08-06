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

@interface MRBrewWatcher ()
{
    @private
    NSFileManager *_fileManager;
    FSEventStreamRef _eventStream;
    NSArray *_pathsToWatch;
}

@end

@implementation MRBrewWatcher

- (id)init {
    return [self initWithPaths:nil delegate:nil];
}

- (id)initWithPaths:(NSArray *)paths delegate:(id<MRBrewWatcherDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        _pathsToWatch = [paths copy];
        _delegate = delegate;
    }
    
    return self;
}

+ (id)watcherWithPaths:(NSArray *)paths delegate:(id<MRBrewWatcherDelegate>)delegate
{
    return [[self alloc] initWithPaths:paths delegate:delegate];
}

- (void)startWatching
{
    _fileManager = [NSFileManager defaultManager];
    
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

static void fileSystemEventsCallback(ConstFSEventStreamRef streamRef,
                       void *userData,
                       size_t numEvents,
                       void *eventPaths,
                       const FSEventStreamEventFlags eventFlags[],
                       const FSEventStreamEventId eventIds[])
{
    MRBrewWatcher *informer = (__bridge MRBrewWatcher *)userData;
    
    if ([[informer delegate] respondsToSelector:@selector(brewChangeDidOccur)]) {
        [[informer delegate] performSelector:@selector(brewChangeDidOccur)];
    }
}

@end
