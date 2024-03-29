//
//  Entry.swift
//  CloudKitJournal
//
//  Created by Matthew O'Connor on 10/14/19.
//  Copyright © 2019 Matthew O'Connor. All rights reserved.
//

import Foundation
import CloudKit

struct EntryConstants {
    static let titleKey = "titleText"
    static let bodyKey = "bodyText"
    static let timestampKey = "timeStamp"
    static let recordTypeKey = "Entry"
}

class Entry {
    var titleText: String
    var bodyText: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(titleText: String, bodyText:String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.titleText = titleText
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
    
}

extension Entry {
    convenience init?(ckRecord: CKRecord) {
        guard let titleText = ckRecord[EntryConstants.titleKey] as? String,
            let bodyText = ckRecord[EntryConstants.bodyKey] as? String,
            let timestamp = ckRecord[EntryConstants.timestampKey] as? Date
            else {return nil}
        self.init(titleText: titleText, bodyText: bodyText, timestamp: timestamp)
    }
}

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordTypeKey, recordID: entry.ckRecordID)
        self.setValue(entry.titleText, forKey: EntryConstants.titleKey)
        self.setValue(entry.bodyText, forKey: EntryConstants.bodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timestampKey)
    }
}

