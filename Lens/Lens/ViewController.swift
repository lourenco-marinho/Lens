// ViewController.swift
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

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var peopleArray: [Person]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.peopleArray = findAll()

    }
    
    // MARK: - TableView DataSource and Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let array = self.peopleArray {
            
            return array.count
            
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) 
        let person = self.peopleArray![indexPath.row]
        
        cell.textLabel!.text = person.name
        
        return cell
    }
    
    // MARK: - Helper Methods
    func findAll() -> [Person]? {
        
        return lens(forEntity: Person.self, inContext: appDelegate.managedObjectContext!).look()
        
    }
    
    func findByAge(age: Int) -> [Person]? {
        
        return lens(forEntity: Person.self, inContext: appDelegate.managedObjectContext!).find("age").equals(age).look()
        
    }
    
    func findByName(name: String) -> [Person]? {
        
        return lens(forEntity: Person.self, inContext: appDelegate.managedObjectContext!).find("name").equals(name).look()
        
    }
    
    func findInside(names: [String]) -> [Person]? {
        
        return lens(forEntity: Person.self, inContext: self.appDelegate.managedObjectContext!).find("name").inside(names).look()
        
    }

    
    // MARK: - Action Method
    @IBAction func segmentedControlDidChange(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            
            self.peopleArray = self.findAll()
            
        } else if sender.selectedSegmentIndex == 1 {
            
            self.peopleArray = self.findByAge(32)
            
        } else if sender.selectedSegmentIndex == 2 {
            
            self.peopleArray = self.findByName("Maria")
            
        } else {
            
            self.peopleArray = self.findInside(["John", "Marcus"])
            
        }
        
        self.tableView.reloadData()
        
    }
}

