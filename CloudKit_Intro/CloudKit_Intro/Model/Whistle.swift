//
//  Whistle.swift
//  CloudKit_Intro
//
//  Created by Tee Becker on 11/25/20.
//

import UIKit
import CloudKit

class Whistle: NSObject{
    var recordID: CKRecord.ID!
    var genre: String!
    var comments: String!
    var audio: URL!
}
