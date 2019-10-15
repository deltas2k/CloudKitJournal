//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by Matthew O'Connor on 10/14/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    static let shared = EntryController()
    let privateDB = CKContainer(identifier: "iCloud.deltas2k.cloudKitJournal").privateCloudDatabase
    
    
    var entry: [Entry] = []
    
    func addEntryWith(titleText: String, bodyText: String, completion: @escaping (_ success: Bool) -> Void) {
        let newEntry = Entry(titleText: titleText, bodyText: bodyText)
        saveEntry(entry: newEntry) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func saveEntry(entry: Entry, completion: @escaping (_ success: Bool) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = record,
            let savedEntry = Entry(ckRecord: record)
                else { completion(false); return }
            
            self.entry.append(savedEntry)
            print("entry saved successfully")
            completion(true)
        }
    }
    
    func fetchEntries(completion: @escaping (_ success: Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: predicate)
        privateDB.perform(query, inZoneWith: nil) { (foundRecord, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            guard let record = foundRecord
                else { completion(false); return }
            
            let entries = record.compactMap( { Entry(ckRecord: $0) } )
            
            self.entry = entries
            print ("fetch successful")
            completion(true)
        
        }
    }
}
