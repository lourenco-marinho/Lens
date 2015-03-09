![Lens](Lens.png)

Lens is a very simple yet elegant query builder made in Swift to work with CoreData.

Features
--
- [x] Chainable method calls
- [x] Similar syntax in both Objective-C and Swift

Requirements
--
- iOS 7.0+ / Mac OS X 10.9+
- Xcode 6.1

Usage
--

### Query all objects from a single entity
##### Objective-C & Swift
```objc
lens(@"Person", self.managedObjectContext).look();
```

### Query entities based on their properties.
##### Objective-C & Swift
```objc
lens(@"Person", self.managedObjectContext).find(@"name").equals(@"John").look();
```

### Compound your queries.
##### Objective-C & Swift
```objc
lens(@"Person", self.managedObjectContext).find(@"name").equals(@"John").and(@"age").equals(26).look();
```

### Sort your results
##### Objective-C
```objc
lens(@"Person", self.managedObjectContext).sort(@"name", YES).look();
```
##### Swift
```swift
lens(forEntity: "Person", inContext: self.managedObjectContext).sort("name", ascending: true).look();
```

Who to blame
--
- [Lourenço Marinho](http://github.com/lourenco-marinho) ([@lopima](https://twitter.com/lopima))

More
--
Lens is a working in progress so feel free to fork this project and improve it!

License
--
Lens is released under the MIT license. See LICENSE for details.
