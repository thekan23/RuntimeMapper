//
//  JsonHelper.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 30/07/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation

public class JsonHelper {
    public static func convertToDictionary(from jsonString: String, with keys: [String]) -> [String: Any] {
        guard
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let jsonDict = json as? [String: Any] else {
                return [:]
        }
        var dict: [String: Any] = [:]
        for key in jsonDict.keys {
            dict[key] = jsonDict[key]
        }
        return dict
    }
    
    public static func convertToDictionaries(from jsonString: String, with keys: [String]) -> [[String: Any]] {
        guard
            let jsonData = jsonString.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let jsonDicts = json as? [[String: Any]] else {
                return [[:]]
        }
        var dicts: [[String: Any]] = []
        for jsonDict in jsonDicts {
            var dict: [String: Any] = [:]
            for key in jsonDict.keys {
                dict[key] = jsonDict[key]
            }
            dicts.append(dict)
        }
        return dicts
    }
}
