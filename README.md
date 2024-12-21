# 🍺 MRBrew

MRBrew is a simple Objective-C wrapper library for the [Homebrew](http://brew.sh) package manager.  It makes performing Homebrew operations from your apps a breeze:

```objc
MRBrewFormula *formula = [MRBrewFormula formulaWithName:@"vim"];
MRBrewOperation *operation = [MRBrewOperation installOperation:formula];
[[MRBrew sharedBrew] performOperation:operation delegate:nil];
```

Now you have a [powerful text editor](http://www.vim.org) installed. :beer:

`MRBrew` uses Automatic Reference Counting and has been tested with OS X versions 10.7—10.10.

## Project integration
MRBrew can be integrated into an existing project using [CocoaPods](http://cocoapods.org). Simply add the necessary dependency to your `Podfile` as follows:

```ruby
platform :osx, '10.7'
pod 'MRBrew'
...
```

Then install the dependency into your project:

`$ pod install`

## Prerequisites
`MRBrew` depends on Homebrew for the heavy lifting, and assumes the default installation path of `/usr/local/bin/brew` (though this can be specified if the `brew` executable has been moved).  If you don't have Homebrew installed, follow the [official instructions](http://brew.sh) to get brewing.

## General Usage

#### Performing operations
To perform an operation, pass an `MRBrewOperation` object to the shared `MRBrew` instance using the `performOperation:delegate:` method.

The `MRBrewOperation` class provides a number of convenience methods for creating objects that represent common Homebrew operations:

```objc
+ (instancetype)updateOperation;
+ (instancetype)listOperation;
+ (instancetype)searchOperation:(MRBrewFormula *)formula;
+ (instancetype)installOperation:(MRBrewFormula *)formula;
+ (instancetype)infoOperation:(MRBrewFormula *)formula;
+ (instancetype)removeOperation:(MRBrewFormula *)formula;
+ (instancetype)optionsOperation:(MRBrewFormula *)formula;
```

For example, the following code would perform a Homebrew `update` operation:

```objc
[[MRBrew sharedBrew] performOperation:[MRBrewOperation updateOperation] delegate:nil];
```

Operations that require a formula to be specified should be passed an `MRBrewFormula` object, which is just as easy to create. For example:

```objc
MRBrewOperation *operation = [MRBrewOperation installOperation:[MRBrewFormula formulaWithName:@"appledoc"]];
[[MRBrew sharedBrew] performOperation:operation delegate:nil];
```

Each call to `performOperation:delegate:` spawns a subprocess in a separate thread that won't interrupt processing in the rest of your app.  Multiple operations can be performed by making repeated calls to `performOperation:delegate:`.  Operations are placed into a queue and executed concurrently. If you would prefer operations to execute in series, just call `[MRBrew setConcurrentOperations:NO]`.

**Note:** All operations performed by the `MRBrew` class inherit the environment from which those operation were launched. Use `setEnvironment:` to define your own environment variables.

#### Custom operations
The convenience methods provided by `MRBrewOperation` cover only a small subset of the actual operations supported by Homebrew.  To perform an operation that does not already have an associated convenience method defined, use the following `MRBrewOperation` class method when creating your operation object:

```objc
+ (instancetype)operationWithName:(NSString *)name
                          formula:(MRBrewFormula *)formula
                       parameters:(NSArray *)parameters;
```

Specify the operation name exactly as defined by Homebrew (e.g. `@"upgrade"`). Both `formula` and `parameters` may be optional depending upon the operation being performed (see *man brew* for more details).

#### Handling operation output
You'll probably want to be notified when an operation has finished, failed, or generated output.  This can be achieved using the delegate pattern by implementing the `MRBrewDelegate` protocol in your controller and specifying the following optional methods:

```objc
- (void)brewOperationDidFinish:(MRBrewOperation *)operation;
- (void)brewOperation:(MRBrewOperation *)operation didFailWithError:(NSError *)error;
- (void)brewOperation:(MRBrewOperation *)operation didGenerateOutput:(NSString *)output;
```

Now, whenever you perform an operation with `performOperation:delegate:`, specify your controller object as the delegate in order to receive callbacks when an operation has finished, failed, or generated output:

```objc
[[MRBrew sharedBrew] performOperation:[MRBrewOperation updateOperation] delegate:controller];
```

If you expect your controller to manage (and therefore receive callbacks for) multiple types of operation, you should inspect the `MRBrewOperation` object in your delegate methods to determine how to respond to particular types of operation:

```objc
- (void)brewOperation:(MRBrewOperation *)operation didGenerateOutput:(NSString *)output
{
    if ([[operation name] isEqualToString:MRBrewOperationUpdateIdentifier]) {
        // an update operation produced output
    }
    else if ([[operation name] isEqualToString:MRBrewOperationInstallIdentifier]) {
        // an install operation produced output
    }
    ...
}
```
The constants referenced above can be found in the `MRBrewConstants.h` header and are used to determine the type of operation received by your delegate methods.  Import this header in your delegate implementation if you plan to use these constants.

If you are responding to a custom operation that does not already have a constant defined, simply provide your own, or use a string literal:

```objc
if ([[operation name] isEqualToString:@"audit"]) {
    // an audit operation produced output
}
```

Alternatively, if you need to respond in your delegate methods to a specific operation, use the `isEqualToOperation:` method of the `MRBrewOperation` class to confirm the operation that generated the callback and respond accordingly.

#### Cancelling operations
Operations can be cancelled using one of the following `MRBrew` instance methods (remember to obtain a a reference to the shared `MRBrew` instance using the `+sharedBrew` class method first):

```objc
- (void)cancelAllOperations;
- (void)cancelOperation:(MRBrewOperation *)operation;
- (void)cancelAllOperationsOfType:(MRBrewOperationType)type;
```

#### Miscellaneous
If the `brew` executable has been moved outside of the default `/usr/local/bin/` directory (generally not advisable), specify its location before performing any operations:

```objc
[[MRBrew sharedBrew] setBrewPath:@"/usr/bin/brew"];
```

This call only needs to be made once per project.

## Unit Tests
Unit tests have been provided as part of the `MRBrewTests` target, and additional tests should be added where required. [OCMock](http://ocmock.org) is required for running these unit tests and can be installed using the [CocoaPods](http://cocoapods.org) dependency manager.

With CocoaPods installed, run the following command from the root directory of your cloned repository to install the dependency:

    $ pod install

## Contributions
If you plan to contribute to the MRBrew project, [fork the repository](https://help.github.com/articles/fork-a-repo), make your code changes, then submit a pull request with a brief description of your feature or bug fix.  Test suites and unit tests are provided for the `MRBrewTests` target, and additional test methods should be added where necessary.

## License
`MRBrew` is provided under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).

## Acknowledgements
The following libraries and resources were used in the making of `MRBrew`:

* [OCMock](http://ocmock.org) by Mulle Kybernetik
* [Beer](http://thenounproject.com/term/beer/24239/) icon by [Helen Tseng](http://thenounproject.com/chirp/) from The Noun Project

## Contact
Email me at [marc.ransome@fidgetbox.co.uk](mailto:marc.ransome@fidgetbox.co.uk) or [create an issue](https://github.com/marcransome/MRBrew/issues).
