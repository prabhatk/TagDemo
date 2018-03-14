//
//  AppDelegate.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import Foundation

public class TagDataLogger {
    
     class func log(message: String, _ args: [CVarArg] = [], file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            let fileUrl = file.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            let filename = URL(string: fileUrl!)?.lastPathComponent.components(separatedBy: ".").first
            print("[TagData:] \(String(describing: filename)).\(function) line \(line) $ \(message)")
        #endif
    }
}
