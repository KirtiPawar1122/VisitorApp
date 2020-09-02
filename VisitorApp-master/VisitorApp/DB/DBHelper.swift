


import Foundation
import SQLite3

class DBHelper {
    
    var db : OpaquePointer?
    let dbPath: String = "visitorDB.sqlite"
    
    init(){
        db = openDatabase()
        createTable()
    }

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        print(fileURL)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
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

    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS visitor(Id INTEGER PRIMARY KEY,name TEXT,address TEXT,email TEXT, phoneNo INTEGER,companyName TEXT,visitPurpose TEXT, visitingName TEXT, profileImage BLOB,sign BLOB );"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("visitor table created.")
            } else {
                print("visitor table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
 func insert(){
     print("in insert")
     let insertString = "insert into visitor (Id, name, address,email,phoneNo,companyName,visitPurpose,visitingName,profileImage,sign) VALUES (?, ?, ?, ?, ?, ?, ?, ? );"
     var insertStatement: OpaquePointer?
     if sqlite3_prepare_v2(db, insertString, -1, &insertStatement, nil) ==
         SQLITE_OK {
        //data inset
        
       if sqlite3_step(insertStatement) == SQLITE_DONE {
         print("\nSuccessfully inserted row.")
       } else {
         print("\nCould not insert row.")
       }
      } else {
       print("\nINSERT statement is not prepared.")
     }
     sqlite3_finalize(insertStatement)
    }
}
