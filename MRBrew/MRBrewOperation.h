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

/** The MRBrewOperation class encapsulates the arguments associated with a single homebrew
 task.
 
 Methods are provided for creating an MRBrewOperation object with an NSString representing
 the operation name as defined by homebrew (e.g. `@"search"`) or alternavitely an
 MRBrewOperationType constant:
 
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
 
 Once an operation object has been created its operation property returns an NSString
 representing the operation name, regardless of how it was created (i.e. the
 MRBrewOperationType enumerated type is used for convenience when creating objects
 of this class, and is not stored by MRBrewOperation objects).
*/
@interface MRBrewOperation : NSObject

/** The operation name.
 */
@property (strong) NSString *operation;

/** A formula associated with the operation, where a formula is permitted (see _man brew_ for
 * details).
 */
@property (strong) MRBrewFormula *formula;


/** An array of optional parameters for the operation (see _man brew_ for details).
 */
@property (strong) NSArray *parameters;

/**---------------------------------------------------------------------------------------
 * @name Initialising an Operation
 * ---------------------------------------------------------------------------------------
 */

/** Initialises a newly allocated operation with a specified type, formula, and parameters.
 *
 * @param operation The type of operation.
 * @param formula The formula (for operations that accept a formula parameter).  Specify
 * `nil` if the operation does not require or accept a formula (see _man brew_ for details).
 * @param parameters An optional array of NSStrings containing parameters to the operation.
 * Specify `nil` if no additional parameters are required or accepted for the operation type
 * (see _man brew_ for details).
 * @return An operation with the specified type, formula, and parameters.
 */
- (id)initWithOperation:(MRBrewOperationType)operation formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;

/** Initialises a newly allocated operation with a specified type, formula, and parameters.
 *
 * @param operation The type of operation.
 * @param formula The formula (for operations that accept a formula parameter).  Specify
 * `nil` if the operation does not require or accept a formula (see _man brew_ for details).
 * @param parameters An optional array of NSStrings containing parameters to the operation.
 * Specify `nil` if no additional parameters are required or accepted for the operation type
 * (see _man brew_ for details).
 * @return An operation with the specified type, formula, and parameters.
 */
- (id)initWithOperationString:(NSString *)operation formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;

/**---------------------------------------------------------------------------------------
 * @name Creating an Operation
 * ---------------------------------------------------------------------------------------
 */

/** Returns an operation with the specified type, formula, and parameters.
 *
 * @param operation The type of operation.
 * @param formula The formula (for operations that accept a formula parameter).  Specify
 * `nil` if the operation does not require or accept a formula (see _man brew_ for details).
 * @param parameters An optional array of NSStrings containing parameters to the operation.
 * Specify `nil` if no additional parameters are required or accepted for the operation type
 * (see _man brew_ for details).
 * @return An operation with the specified type, formula, and parameters.
 */
+ (id)operationWithOperation:(MRBrewOperationType)operation formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;

/** Returns an operation with the specified type, formula, and parameters.
 *
 * @param operation The type of operation.
 * @param formula The formula (for operations that accept a formula parameter).  Specify
 * `nil` if the operation does not require or accept a formula (see _man brew_ for details).
 * @param parameters An optional array of NSStrings containing parameters to the operation.
 * Specify `nil` if no additional parameters are required or accepted for the operation type
 * (see _man brew_ for details).
 * @return An operation with the specified type, formula, and parameters.
 */
+ (id)operationWithStringOperation:(NSString *)operation formula:(MRBrewFormula *)formula parameters:(NSArray *)parameters;

/** Returns an update operation. */
+ (id)updateOperation;

/** Returns a list operation. */
+ (id)listOperation;

/** Returns a search operation. */
+ (id)searchOperation;

/** Returns a search operation with the specified formula. */
+ (id)searchOperation:(MRBrewFormula *)formula;

/** Returns an install operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (id)installOperation:(MRBrewFormula *)formula;

/** Returns an info operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (id)infoOperation:(MRBrewFormula *)formula;

/** Returns a remove operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (id)removeOperation:(MRBrewFormula *)formula;

/** Returns an options operation with the specified formula.
 *
 * @param formula The formula.
 */
+ (id)optionsOperation:(MRBrewFormula *)formula;

/* Returns an outdated operation. */
+ (id)outdatedOperation;

@end
