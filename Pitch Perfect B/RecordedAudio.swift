//
//  RecordedAudio.swift
//  Pitch Perfect B
//
//  Created by Ilja Ketris on 31/7/2015.
//  Copyright (c) 2015 Ilja Ketris. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
     init(title: String! = nil, path: NSURL! = nil) {
        self.title = title
        self.filePathUrl = path
    }
}