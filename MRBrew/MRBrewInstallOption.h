//
//  MRBrewInstallOption.h
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

/** An `MRBrewInstallOption` object represents a single install option for a
 * homebrew formula.
 */
@interface MRBrewInstallOption : NSObject

/** The install option string, as passed to homebrew (e.g. `--use-clang`). */
@property (copy) NSString *option;

/** The install option description. */
@property (copy) NSString *description;

/** A boolean value representing whether the install option is selected. */
@property (assign) BOOL selected;

/**-----------------------------------------------------------------------------
 * @name Initialising an Install Option
 * -----------------------------------------------------------------------------
 */

/** Returns an initialized `MRBrewInstallOption` object with the specified name,
 * description, and selected properties.
 *
 * @param name The name of the install option.
 * @param description The install option description.
 * @param selected A boolean value representing whether the install option is
 * selected.
 * @return An install option with the specified properties.
 */
- (id)initWithName:(NSString *)name description:(NSString *)description selected:(BOOL)selected;

/**-----------------------------------------------------------------------------
 * @name Creating an Install Option
 * -----------------------------------------------------------------------------
 */

/** Returns an install option with the specified name, description, and selected
 * properties.
 *
 * @param name The name of the install option.
 * @param description The install option description.
 * @param selected A boolean value representing whether the install option is
 * selected.
 * @return An install option with the specified properties.
 */
+ (id)installOptionWithName:(NSString *)name description:(NSString *)description selected:(BOOL)selected;

@end
