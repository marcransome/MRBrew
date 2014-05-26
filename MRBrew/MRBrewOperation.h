//
//  MRBrewOperation.h
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

@class MRBrewFormula;

/** The type of operation to use when creating `MRBrewOperation` objects.
 */
typedef NS_ENUM(NSInteger, MRBrewOperationType) {
    /** An `update` operation. */
    MRBrewOperationUpdate,
    /** A `list` operation. */
    MRBrewOperationList,
    /** A `search` operation. */
    MRBrewOperationSearch,
    /** An `install` operation. */
    MRBrewOperationInstall,
    /** An `info` operation. */
    MRBrewOperationInfo,
    /** A `remove` operation. */
    MRBrewOperationRemove,
    /** An `options` operation. */
    MRBrewOperationOptions,
    /** An `outdated` operation. */
    MRBrewOperationOutdated
};

/** The `MRBrewOperation` class encapsulates the arguments associated with a
 single Homebrew operation.
 
 For convenience, an `MRBrewOperation` object can be created with either an
 NSString representation of the Homebrew command name (e.g. @"search"), or
 alternatively an MRBrewOperationType constant for one of the following common
 operations:
 
    typedef enum {
        MRBrewOperationUpdate,
        MRBrewOperationList,
        MRBrewOperationSearch,
        MRBrewOperationInstall,
        MRBrewOperationInfo,
        MRBrewOperationRemove,
        MRBrewOperationOptions,
        MRBrewOperationOutdated
    } MRBrewOperationType;
 
 Once an operation object has been created its name property returns an
 NSString representing the operation, regardless of how it was created (i.e. the
 MRBrewOperationType constants are used for convenience when creating objects of
 this class and are not retained).
 
 For operations that do not require a command, specify `nil` as the operation
 name. For example:
 
     $ brew --cache
 
 Would be represented by:
 
     [MRBrewOperation operationWithName:nil formula:nil parameters:@"--cache"];
 */
@interface MRBrewOperation : NSObject <NSCopying>

/** The operation name (equivalent to the _command_ in Homebrew terminology).
 */
@property (copy) NSString *name;

/** A formula associated with the operation, where a formula is permitted
 * (see `man brew` for details).
 */
@property (copy) MRBrewFormula *formula;

/** An array of optional parameters for the operation (see _man brew_ for
 * details).
 */
@property (copy) NSArray *parameters;

/**-----------------------------------------------------------------------------
 * @name Initialising an Operation
 * -----------------------------------------------------------------------------
 */

/** Returns an initialized `MRBrewOperation` object with the specified type,
 * formula, and parameters.
 *
 * @param type The type of operation.
 * @param formula The formula (for operations that accept a formula parameter).
 * Specify `nil` if the operation does not require or accept a formula (see _man
 * brew_ for details).
 * @param parameters An optional array of NSStrings containing parameters to the
 * operation. Parameters should be specified exactly as expected by Homebrew
 * (e.g. @"--parameter_name"). Specify `nil` if no additional parameters are
 * required or accepted for the operation type (see _man brew_ for details).
 * @return An operation with the specified type, formula, and parameters.
 */
- (instancetype)initWithType:(MRBrewOperationType)type formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;

/** Returns an initialized `MRBrewOperation` object with the specified name,
 * formula, and and parameters.
 *
 * @param name The name of the operation, or `nil`.
 * @param formula The formula (for operations that accept a formula parameter).
 * Specify `nil` if the operation does not require or accept a formula (see _man
 * brew_ for details).
 * @param parameters An optional array of NSStrings containing parameters to the
 * operation. Parameters should be specified exactly as expected by Homebrew
 * (e.g. @"--parameter_name"). Specify `nil` if no additional parameters are
 * required or accepted for the operation type (see _man brew_ for details).
 * @return An operation with the specified type, formula, and parameters.
 */
- (instancetype)initWithName:(NSString *)name formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;

/**-----------------------------------------------------------------------------
 * @name Creating an Operation
 * -----------------------------------------------------------------------------
 */

/** Returns an operation with the specified type, formula, and parameters.
 *
 * @param type The type of operation.
 * @param formula The formula (for operations that accept a formula parameter).
 * Specify `nil` if the operation does not require or accept a formula (see _man
 * brew_ for details).
 * @param parameters An optional array of NSStrings containing parameters to the
 * operation. Parameters should be specified exactly as expected by Homebrew
 * (e.g. @"--parameter_name"). Specify `nil` if no additional parameters are
 * required or accepted for the operation type (see _man brew_ for details).
 * @return An operation with the specified type, formula, and parameters.
 */
+ (instancetype)operationWithType:(MRBrewOperationType)type formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;

/** Returns an operation with the specified type, formula, and parameters.
 *
 * @param name The name of the operation.
 * @param formula The formula (for operations that accept a formula parameter).
 * Specify `nil` if the operation does not require or accept a formula (see _man
 * brew_ for details).
 * @param parameters An optional array of NSStrings containing parameters to the
 * operation. Parameters should be specified exactly as expected by Homebrew
 * (e.g. @"--parameter_name"). Specify `nil` if no additional parameters are
 * required or accepted for the operation type (see _man brew_ for details).
 * @return An operation with the specified type, formula, and parameters.
 */
+ (instancetype)operationWithName:(NSString *)name formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;

/** Returns an update operation. */
+ (instancetype)updateOperation;

/** Returns a list operation. */
+ (instancetype)listOperation;

/** Returns a search operation. */
+ (instancetype)searchOperation;

/** Returns a search operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (instancetype)searchOperation:(MRBrewFormula *)formula;

/** Returns an install operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (instancetype)installOperation:(MRBrewFormula *)formula;

/** Returns an info operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (instancetype)infoOperation:(MRBrewFormula *)formula;

/** Returns a remove operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (instancetype)removeOperation:(MRBrewFormula *)formula;

/** Returns an options operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (instancetype)optionsOperation:(MRBrewFormula *)formula;

/** Returns an outdated operation. */
+ (instancetype)outdatedOperation;

/**-----------------------------------------------------------------------------
* @name Comparing Operations
* -----------------------------------------------------------------------------
*/

/** Compares the receiver to another operation.
 *
 * @param operation The operation with which to compare the receiver.
 * @return YES if the receiver is equal to _operation_, otherwise NO.
 */
- (BOOL)isEqualToOperation:(MRBrewOperation *)operation;

@end
