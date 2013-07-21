//
//  MRBrew.h
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

#import <Cocoa/Cocoa.h>
#import "MRBrewDelegate.h"

enum {
    MRBrewErrorUnknown = 1,
    MRBrewErrorCancelled = 130
};

@class MRBrewOperation;
@protocol MRBrewDelegate;

/** The MRBrew class provides an interface to the Homebrew package manager.
 *
 * MRBrew's delegate methods—defined by the MRBrewDelegate protocol—allow
 * an object to receive callbacks regarding the success or failure of an operation and output
 * from the _brew_ program as it occurs.
 */
@interface MRBrew : NSObject

/**---------------------------------------------------------------------------------------
 * @name Accessing and setting the Homebrew executable path
 * ---------------------------------------------------------------------------------------
 */

/** Returns the absolute path to the Homebrew executable. */
+ (NSString *)brewPath;

/** Sets the absolute path to the Homebrew executable.
 *
 * @param path The absolute path to the Homebrew executable, or /usr/local/bin/brew
 * if nil.
 */
+ (void)setBrewPath:(NSString *)path;

/**---------------------------------------------------------------------------------------
 * @name Performing an Operation
 * ---------------------------------------------------------------------------------------
 */

/** Performs an operation.
 *
 * @param operation The operation to perform.
 * @param delegate The delegate object for the operation. The delegate will receive delegate
 * messages during the operation if output for the operation is generated and at the end of
 * a completed operation.
 */
+ (void)performOperation:(MRBrewOperation *)operation delegate:(id<MRBrewDelegate>)delegate;

/**---------------------------------------------------------------------------------------
 * @name Stopping an Operation
 * ---------------------------------------------------------------------------------------
 */

/** Cancels all active operations.  This method has no effect if there are currently no
 * active operations.  The delegate object for each operation that is cancelled will
 * receive a message indicating operation failure along with an NSError object whose
 * code matches the MRBrewErrorCancelled constant.
 */
+ (void)cancelAllOperations;

/** Cancels a specific operation.  After cancellation, the delegate object for the
 * operation will receive a message indicating operation failure along with an NSError
 * object whose code matches the MRBrewErrorCancelled constant.
 *
 * @param operation The operation to cancel.
 */
+ (void)cancelOperation:(MRBrewOperation *)operation;

/** Cancels all operations of a given type.  This method has no effect if there are
 * currently no active operations of the specified type.  The delegate object for each
 * operation that is cancelled will receive a message indicating operation failure along
 * with an NSError object whose code matches the MRBrewErrorCancelled constant.
 *
 * @param operationType The type of operations to cancel.
 */
+ (void)cancelAllOperationsOfType:(MRBrewOperationType)operationType;

@end
