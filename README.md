![Lens](Lens.png)

Lens is a very simple yet elegant query builder made in Swift to work with CoreData.

Features
--
- [x] Chainable method calls
- [x] Generics Support

Requirements
--
- iOS 7.0+ / Mac OS X 10.9+
- Xcode 6.1

Installation
--
You can use [CocoaPods](https://cocoapods.org/) to integrate Lens in your project.
You can install it with the following command

```
$ gem install cocoapods
```

Update your ```Podfile``` to use Lens

```
pod 'Lens'
```
Then, run the following command

```
$ pod install
```

Usage
--

### Query all objects from a single entity
```swift
lens(forEntity: Person.self, managedObjectContext).look();
```

### Query entities based on their properties.
```swift
lens(forEntity: Person.self, managedObjectContext).find(@"name").equals(@"John").look();
```

### Compound your queries.
```swift
lens(forEntity: Person.self, managedObjectContext).find(@"name").equals(@"John").and(@"age").equals(26).look();
```

### Sort your results
```swift
lens(forEntity: Person.self, inContext: managedObjectContext).sort("name", ascending: true).look();
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
