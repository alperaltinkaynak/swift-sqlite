

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        methodToCreateDatabase()
    }
    
    
    let dbPath: String = "person.db"
    var db:OpaquePointer?
   
    func methodToCreateDatabase() -> URL? {
        
        let fileManager = FileManager.default
        
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        if let documentDirectory:URL = urls.first { // No use of as? NSURL because let urls returns array of NSURL
            
            // exclude cloud backup
            do {
                try (documentDirectory as NSURL).setResourceValue(true, forKey: URLResourceKey.isExcludedFromBackupKey)
            } catch _{
                print("Failed to exclude backup")
            }
            
            // This is where the database should be in the documents directory
            let finalDatabaseURL = documentDirectory.appendingPathComponent("person.db")
            
            if (finalDatabaseURL as NSURL).checkResourceIsReachableAndReturnError(nil) {
                // The file already exists, so just return the URL
                return finalDatabaseURL
            } else {
                // Copy the initial file from the application bundle to the documents directory
                if let bundleURL = Bundle.main.url(forResource: "person", withExtension: "db") {
                    
                    do {
                        try fileManager.copyItem(at: bundleURL, to: finalDatabaseURL)
                    } catch _ {
                        print("Couldn't copy file to final location!")
                    }
                    
                } else {
                    print("Couldn't find initial database in the bundle!")
                }
            }
        } else {
            print("Couldn't get documents directory!")
        }
        
        return nil
    }
    
    func openDatabase() -> OpaquePointer?
    {
        
        let dbUrl = Bundle.main.url(forResource: "person", withExtension: "db")!
        
        var db: OpaquePointer? = nil
        if sqlite3_open(dbUrl.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func read() -> [Person] {
        let queryStatementString = "SELECT * FROM person;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Person] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let age = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
                
                psns.append(Person(id: Int(id), name: name, age: age))
                print("Query Result:")
                print("\(id) | \(name) | \(age)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
}
