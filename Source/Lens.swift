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

public class Lens<T: NSManagedObject> {    
    let request: LensRequest<T>

    public var find: (String) -> Lens<T> {
        return { field in
            self.request.appendField(field)
            return self
        }
    }

    public var and: (String) -> Lens<T> {
        return { field in
            self.request.appendField(field, compoundOperator: "AND")
            return self
        }
    }

    public var or: (String) -> Lens<T> {
        return { field in
            self.request.appendField(field, compoundOperator: "OR")
            return self
        }
    }

    public var equals: (AnyObject?) -> Lens<T> {
        return { value in
            self.request.appendComparison("=", value: value)
            return self
        }
    }

    public var notEquals: (AnyObject?) -> Lens<T> {
        return { value in
            self.request.appendComparison("!=", value: value)
            return self
        }
    }

    public var contains: (AnyObject?) -> Lens<T> {
        return { value in
            self.request.appendComparison("CONTAINS[cd]", value: value)
            return self
        }
    }

    public var inside: ([AnyObject]) -> Lens {
        return { values in
            self.request.appendComparison("IN", value: values)
            return self
        }
    }

    public var sort: (String, ascending: Bool) -> Lens<T> {
        return { key, ascending in
            self.request.createSortDescriptorWithKey(key, ascending: ascending)
            return self
        }
    }

    public var look: () -> [T]? {
        return { self.request.generate() }
    }
    
    public var predicate: () -> NSPredicate {
        return { self.request.createPredicate() }
    }

    public init(entity: T.Type, inContext context: NSManagedObjectContext?) {
        request = LensRequest(entity: entity, context: context)
    }
    
    public convenience init(entity: T.Type) {
        self.init(entity: entity, inContext: nil)
    }
}

func lens<T: NSManagedObject>(forEntity entity: T.Type, inContext context: NSManagedObjectContext) -> Lens<T> {

    return Lens(entity: entity, inContext: context)

}

func lens<T: NSManagedObject>(forEntity entity: T.Type) -> Lens<T> {
    
    return Lens(entity: entity)
    
}
