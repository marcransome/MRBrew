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

##Caveats
Please note that the source code uses ARC (Automatic Reference Counting) and has only been tested against 10.7 and 10.8 deployment targets.

##License
`MRBrew` is provided under the terms of the [MIT License](http://opensource.org/licenses/mit-license.php).

##Comments or suggestions?
Email me at [marc.ransome@fidgetbox.co.uk](mailto://marc.ransome@fidgetbox.co.uk) with bugs, feature requests or general comments and follow [@marcransome](http://www.twitter.com/marcransome) for updates.
