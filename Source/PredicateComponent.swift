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

class PredicateComponent {
    let field: String
    var compoundOperator: String?
    var predicateOperator: String?
    var value: AnyObject?
    
    var description: String {
        var comparison: String = ""
        var queryOperator: String = ""
        var queryValue: String = ""
        
        if let optionalComparison = predicateOperator {
            comparison = optionalComparison
        }
        
        if let optionalOperator = compoundOperator {
            queryOperator = optionalOperator
        }
        
        queryValue = (value != nil ? "%@" : "nil")
        
        return "\(queryOperator) \(field) \(comparison) \(queryValue)"
    }
    
    convenience init(field: String) {
        self.init(field: field, compoundOperator: nil)
    }
    
    init(field: String, compoundOperator: String?) {
        self.field = field
        self.compoundOperator = compoundOperator
    }
}
