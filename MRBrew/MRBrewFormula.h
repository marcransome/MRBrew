//
//  MRFormula.h
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

/** An MRBrewFormula object represents a formula in the Homebrew package manager. */
@interface MRBrewFormula : NSObject <NSCopying>

/** The name of the formula. */
@property (strong) NSString *name;

/** A boolean value representing whether the formula has been updated. */
@property (assign) BOOL isUpdated;

/** A boolean value representing whether the formula is new.*/
@property (assign) BOOL isNew;

/** A boolean value representing whether the formula is installed. */
@property (assign) BOOL isInstalled;

/**---------------------------------------------------------------------------------------
 * @name Initialising a Formula
 * ---------------------------------------------------------------------------------------
 */

/** Initialises a newly allocated formula with the specified name.
 *
 * @param name The name of the formula.
 * @return A formula with the specified name.
 */
- (id)initWithName:(NSString *)name;

/** Initialises a newly allocated formula with the specified name and status.
 *
 * @param name The name of the formula.
 * @param isNew A boolean value representing whether the formula is new.
 * @param isUpdated A boolean value representing whether the formula is updated.
 * @param isInstalled A boolean value representing whether the formula is installed.
 * @return A formula with the specified properties.
 */
- (id)initWithName:(NSString *)name isNew:(BOOL)isNew isUpdated:(BOOL)isUpdated isInstalled:(BOOL)isInstalled;

/**---------------------------------------------------------------------------------------
 * @name Creating a Formula
 * ---------------------------------------------------------------------------------------
 */

/** Returns a formula with the specified name.
 *
 * @param name The name of the formula.
 * @return A formula with the specified name.
 */
+ (id)formulaWithName:(NSString *)name;

/** Returns a formula with the specified name and status.
 *
 * @param name The name of the formula.
 * @param isNew A boolean value representing whether the formula is new.
 * @param isUpdated A boolean value representing whether the formula is updated.
 * @param isInstalled A boolean value representing whether the formula is installed.
 * @return A formula with the specified properties.
 */
+ (id)formulaWithName:(NSString *)name isNew:(BOOL)isNew isUpdated:(BOOL)isUpdated  isInstalled:(BOOL)isInstalled;

/** Compares the receiver to another formula.
 *
 * @param formula The formula with which to compare the receiver.
 * @return YES if the receiver is equal to _formula_, otherwise NO.
 */
- (BOOL)isEqualToFormula:(MRBrewFormula *)formula;

@end
