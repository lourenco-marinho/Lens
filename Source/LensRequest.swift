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

class LensRequest<T: NSManagedObject> {
    var request: NSFetchRequest?
    var context: NSManagedObjectContext?
    var entity: NSEntityDescription!
    var sort: NSSortDescriptor!
    var predicateComponents: [PredicateComponent]
    
    init(entity: T.Type, context: NSManagedObjectContext?) {
        
        self.context = context
        self.predicateComponents = []
        
        if let _ = context {
            let entityName = NSStringFromClass(entity)
            self.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context!)!
            self.request = NSFetchRequest(entityName: entityName)
        }
    }
    
    // Predicate Creation Methods
    func appendField(field: String) {
        appendField(field, compoundOperator: nil)
    }
    
    func appendField(field: String, compoundOperator: String?) {
        let component = PredicateComponent(field: field, compoundOperator: compoundOperator)
        predicateComponents.append(component)
    }
    
    func appendComparison(comparison: String, value: AnyObject?) {
        let optionalComponent = self.predicateComponents.last
        
        if let component = optionalComponent {
            component.predicateOperator = comparison
            component.value = value
        }
    }
    
    // Generation Methods
    func generate() -> [T]? {
        
        assert(self.context != nil, "When Looking for objects the NSManagedObjectContext cannot be nil")
        
        setSort(sort, toFetchRequest: request)
        
        if predicateComponents.isEmpty == false {
            let predicate = createPredicate()
            setPredicate(predicate, toFetchRequest: request)
        }
        
        var fetchResult: [T]?
        
        do {
            fetchResult = try context?.executeFetchRequest(self.request!) as? [T]
        } catch {
            fetchResult = []
        }
        
        return fetchResult
    }
    
    func setSort(sort: NSSortDescriptor?, toFetchRequest optionalRequest: NSFetchRequest?) {
        if let optionalSort = sort, request = optionalRequest {
            request.sortDescriptors = [optionalSort]
        }
    }
    
    func setPredicate(predicate: NSPredicate, toFetchRequest optionalRequest: NSFetchRequest?) {
        if let request = optionalRequest {
            request.predicate = predicate
        }
    }
    
    func createPredicate() -> NSPredicate {
        let query = createPredicateQuery()
        let arguments: [AnyObject] = createPredicateArguments()
        
        return NSPredicate(format: query, argumentArray: arguments)
    }
    
    func createPredicateQuery() -> String {
        let query = self.predicateComponents.reduce("") { $0 + "\($1.description) " }
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
       sort = NSSortDescriptor(key: key, ascending: ascending)
    }
}
