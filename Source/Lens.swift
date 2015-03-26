// Lens.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Lens
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import CoreData

public typealias CompoundMethod = (String) -> Lens
public typealias ComparisonMethod = (AnyObject?) -> Lens
public typealias InMethod = ([AnyObject]) -> Lens
public typealias SortMethod = (String, ascending: Bool) -> Lens
public typealias LookMethod = () -> [AnyObject]?

class PredicateComponent {

    let field: String
    var compoundOperator: String?
    var predicateOperator: String?
    var value: AnyObject?

    var description: String {

        var comparison: String = ""
        var queryOperator: String = ""
        var queryValue: String = ""

        if let optionalComparison = self.predicateOperator {

            comparison = optionalComparison

        }

        if let optionalOperator = self.compoundOperator {

            queryOperator = optionalOperator

        }

        queryValue = self.value != nil ? "%@" : "nil"

        return "\(queryOperator) \(self.field) \(comparison) \(queryValue)"

    }

    convenience init(field: String) {

        self.init(field: field, compoundOperator: nil)

    }

    init(field: String, compoundOperator: String?) {

        self.field = field
        self.compoundOperator = compoundOperator
    }

}

@objc public class LensRequest {

    var request: NSFetchRequest!
    var context: NSManagedObjectContext!
    var entity: NSEntityDescription!

    var sort: NSSortDescriptor!
    var predicateComponents: [PredicateComponent]

    init(entityName: String, context: NSManagedObjectContext) {

        self.context = context
        self.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
        self.request = NSFetchRequest(entityName: entityName)
        self.predicateComponents = [];

    }

    func append(block: () -> String) {

        let stringToAppend = block()

    }

    func appendComparison(comparison: String, value: AnyObject?) {

        let optionalComponent = self.predicateComponents.last

        if let component = optionalComponent {

            component.predicateOperator = comparison
            component.value = value

        }

    }

    func appendComponent(#field: String) {

        self.appendComponent(field: field, compoundOperator: nil)

    }

    func appendComponent(#field: String, compoundOperator: String?) {

        let component = PredicateComponent(field: field, compoundOperator: compoundOperator)
        self.predicateComponents.append(component)

    }

    func generate() -> [AnyObject]? {

        self.setSort(self.sort, toFetchRequest: self.request)

        if self.predicateComponents.isEmpty == false {

            let predicate: NSPredicate = self.createPredicate()
            self.setPredicate(predicate, toFetchRequest: self.request)

        }

        var error: NSError?
        var fetchResult = self.context.executeFetchRequest(self.request, error: &error)

        if let optionalError = error {

            fetchResult = []

        }

        return fetchResult

    }

    func setSort(sort: NSSortDescriptor?, toFetchRequest request: NSFetchRequest) {

        if let optionalSort = sort {

            request.sortDescriptors = [optionalSort]

        }

    }

    func setPredicate(predicate: NSPredicate, toFetchRequest request: NSFetchRequest) {

        request.predicate = predicate

    }

    func createPredicate() -> NSPredicate {

        let query: String = self.createPredicateQuery()
        let arguments: [AnyObject] = self.createPredicateArguments()

        return NSPredicate(format: query, argumentArray: arguments)

    }

    func createPredicateQuery() -> String {

        var query: String = self.predicateComponents.reduce("") { $0 + "\($1.description) " }
        return query.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

    }

    func createPredicateArguments() -> [AnyObject] {

        var arguments: [AnyObject] = [];

        for component in self.predicateComponents {

            if let value: AnyObject = component.value {

                arguments.append(value)

            }

        }

        return arguments

    }

    func createSortDescriptorWithKey(key: String, ascending: Bool) {

        self.sort = NSSortDescriptor(key: key, ascending: ascending)

    }

}

@objc public class Lens: NSObject {

    let request: LensRequest

    public var find: CompoundMethod {

        return { field in

            self.request.appendComponent(field: field)
            return self

        }

    }

    public var and: CompoundMethod {

        return { field in

            self.request.appendComponent(field: field, compoundOperator: "AND")
            return self

        }

    }

    public var or: CompoundMethod {

        return { field in

            self.request.appendComponent(field: field, compoundOperator: "OR")
            return self

        }

    }

    public var equals: ComparisonMethod {

        return { value in

            self.request.appendComparison("=", value: value)
            return self

        }

    }

    public var notEquals: ComparisonMethod {

        return { value in

            self.request.appendComparison("!=", value: value)
            return self

        }

    }

    public var contains: ComparisonMethod {

        return { value in

            self.request.appendComparison("CONTAINS[cd]", value: value)
            return self
        }

    }

    public var inside: InMethod {

        return { values in

            self.request.appendComparison("IN", value: values)
            return self
        }

    }

    public var sort: SortMethod {

        return { key, ascending in

            self.request.createSortDescriptorWithKey(key, ascending: ascending)
            return self

        }

    }

    public var look: LookMethod {

        return { self.request.generate() }

    }

    public init(entityName: String, inContext context: NSManagedObjectContext) {

        self.request = LensRequest(entityName: entityName, context: context)

    }

}

func lens(forEntity entity: String, inContext context: NSManagedObjectContext) -> Lens {

    return Lens(entityName: entity, inContext: context)

}
