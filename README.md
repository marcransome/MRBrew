##MRBrew
MRBrew is a simple Objective-C wrapper library for the [Homebrew](http://mxcl.github.io/homebrew/) package manager.  It makes performing Homebrew operations from your apps a breeze:

```objc
[MRBrew performOperation:[MRBrewOperation installOperation:[MRBrewFormula formulaWithName:@"emacs"]] delegate:self];
```

Now you have a powerful text editor installed. ;)

##Project integration
MRBrew can be integrated into an existing project using [CocoaPods](http://cocoapods.org). Simply add the necessary dependency to your `Podfile` as follows:

```ruby
platform :osx, '10.7'
pod 'MRBrew'
...
```

Then install the dependency into your project:

`$ pod install`

##Prerequisites
`MRBrew` depends on Homebrew for the heavy lifting, and assumes the default installation path of `/usr/local/bin/brew`.  If you don't already have Homebrew installed, follow the [official instructions](http://mxcl.github.io/homebrew/) to get setup.

##General Usage
To perform a Homebrew operation, pass an instance of `MRBrewOperation` to the `MRBrew` class method `performOperation:delegate:`.  The `MRBrewOperation` class provides a number of convenience methods for creating instances that represent common Homebrew operations:

```objc
+ (id)updateOperation;
+ (id)listOperation;
+ (id)searchOperation;
+ (id)installOperation:(MRBrewFormula *)formula;
+ (id)infoOperation:(MRBrewFormula *)formula;
+ (id)removeOperation:(MRBrewFormula *)formula;
+ (id)optionsOperation:(MRBrewFormula *)formula;
```

For example, the following code would perform a Homebrew update operation:

```objc
[MRBrew performOperation:[MRBrewOperation updateOperation] delegate:nil];
```

Homebrew operations that involve a specific formula require an instance of `MRBrewFormula`, which is just as easy to create:

```objc
[MRBrewFormula formulaWithName:@"appledoc"]
```

Each call to `performOperation:delegate:` spawns a subprocess that won't interrupt processing in the rest of your app.  You'll probably want to be notified when an operation has finished or errored however, which can be achieved using the delegate pattern by implementing the `MRBrewDelegate` protocol in your controller and specifying the following methods:

```objc
- (void)brewOperationDidFinish:(MRBrewOperation *)operation;
- (void)brewOperation:(MRBrewOperation *)operation didFailWithError:(NSError *)error;
- (void)brewOperation:(MRBrewOperation *)operation didGenerateOutput:(NSString *)output;
```

Now, whenever you perform an operation by calling `performOperation:delegate:`, specify your controller object as the delegate in order to receive callbacks when an operation has finished, errored, or produced output:

```objc
[MRBrew performOperation:[MRBrewOperation updateOperation] delegate:controllerObject];
```

If you expect your controller to manage (and therefore receive callbacks for) multiple types of operation, you should inspect the `MRBrewOperation` object in your delegate methods to determine how to react:

```objc
- (void)brewOperation:(MRBrewOperation *)operation didGenerateOutput:(NSString *)output
{
    if ([[operation operation] isEqualToString:MRBrewOperationUpdateIdentifier]) {
        // an update operation produced output
    }
    else if ([[operation operation] isEqualToString:MRBrewOperationInstallIdentifier]) {
        // an install operation produced output
    }
    ...
}
```
The constants referenced in the above snippet are part of the `MRBrewOperationType` enumerated type (see `MRBrewOperation.h`) and can be used to determine the type of operation received by your delegate methods.

##Advanced
Visit [CocoaDocs](http://cocoadocs.org/docsets/MRBrew/1.0.0/) for additional documentation, or alternatively inspect the header files directly.

##Caveats
Please note that the source code uses ARC (Automatic Reference Counting) and has only been tested against 10.7 and 10.8 deployment targets.

##License
`MRBrew` is provided under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).

##Comments or suggestions?
Email me at [marc.ransome@fidgetbox.co.uk](mailto://marc.ransome@fidgetbox.co.uk) with bugs, feature requests or general comments and follow [@marcransome](http://www.twitter.com/marcransome) for updates.
