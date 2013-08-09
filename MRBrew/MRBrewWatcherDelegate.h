//
//  MRBrewWatcherDelegate.h
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

#import <Foundation/Foundation.h>

/** The `MRBrewWatcherDelegate` protocol defines the optional methods
 implemented by delegates of the MRBrewWatcher class.
 
 MRBrew operations that generate output call the delegate method
 brewOperation:didGenerateOutput: _after_ completing an operation and
 immediately before calling brewOperationDidFinish:. In the case of
 MRBrewOperationInstall operations brewOperation:didGenerateOutput: may be
 called several times during the lifetime of the operation as output is received
 from brew one line at a time.
*/
@protocol MRBrewWatcherDelegate <NSObject>

@optional

/** This method is called when an event occurs at a watched location. */
- (void)brewChangeDidOccur;

@end
