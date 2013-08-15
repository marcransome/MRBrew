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

/** The `MRBrewWatcherDelegate` protocol defines the optional method
 * brewChangeDidOccur: that is implemented by delegates of the MRBrewWatcher
 * class.
 *
 * MRBrewWatcher objects call the delegate method brewChangeDidOccur: when a
 * file system event occurs at a watched loaction (e.g. file modification,
 * deletion or creation).  An array of strings representing the directory paths
 * where changes occured is passed to this method.
 */
@protocol MRBrewWatcherDelegate <NSObject>

@optional

/** This method is called when a file system event occurs at a watched location.
 *
 * @param paths An array of strings containing the paths where changes occured.
 * One or more changes may have occured at each path present in the array.
 */
- (void)brewChangeDidOccur:(NSArray *)paths;

@end
