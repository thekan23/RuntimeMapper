//
//  RuntimeMapper.swift
//  RuntimeMapper
//
//  Created by 안덕환 on 26/07/2018.
//  Copyright © 2018 thekan. All rights reserved.
//

import Foundation
import Runtime


public class RuntimeMapper {
    
    let intType = String(describing: Int.self)
    let optionalIntType = String(describing: Int?.self)
    
    let floatType = String(describing: Float.self)
    let optionalFloatType = String(describing: Float?.self)
    
    let doubleType = String(describing: Double.self)
    let optionalDoubleType = String(describing: Double?.self)
    
    let boolType = String(describing: Bool.self)
    let optionalBoolType = String(describing: Bool?.self)
    
    let stringType = String(describing: String.self)
    let optionalStringType = String(describing: String?.self)
    
    
    public func readSingle<T>(from jsonString: String, initializer: (() -> T)) throws -> T {
        guard let info = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        let propertyNames = info.properties.map { $0.name }
        let mappedDict = JsonHelper.convertToDictionary(from: jsonString, with: propertyNames)
        
        var instance = initializer()
        for p in info.properties {
            if let propertyInfo = try? info.property(named: p.name), let value = mappedDict[p.name] {
                do {
                    try setValue(value, to: propertyInfo, in: &instance)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return instance
    }
    
    public func readArray<T>(from jsonString: String, initializer: (() -> T)) throws -> [T] {
        guard let info = try? typeInfo(of: T.self) else {
            throw RuntimeMapperErrors.UnsupportedType
        }
        let propertyNames = info.properties.map { $0.name }
        let mappedDicts = JsonHelper.convertToDictionaries(from: jsonString, with: propertyNames)
        
        var instanceList: [T] = []
        for mappedDict in mappedDicts {
            var instance = initializer()
            for p in info.properties {
                if let propertyInfo = try? info.property(named: p.name), let value = mappedDict[p.name] {
                    do {
                        try setValue(value, to: propertyInfo, in: &instance)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            instanceList.append(instance)
        }
        return instanceList
    }
    
    public init() { }
}

extension RuntimeMapper {
    private func setValue<T>(_ value: Any, to propertyInfo: PropertyInfo, in instance: inout T) throws {
        do {
            switch String(describing: propertyInfo.type) {
            case intType, optionalIntType:
                if let intValue = value as? Int {
                    try propertyInfo.set(value: intValue, on: &instance)
                }
            case floatType, optionalFloatType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.floatValue, on: &instance)
                }
            case doubleType, optionalDoubleType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.doubleValue, on: &instance)
                }
            case boolType, optionalBoolType:
                if let numberValue = value as? NSNumber {
                    try propertyInfo.set(value: numberValue.boolValue, on: &instance)
                }
            case stringType, optionalStringType:
                if let stringValue = value as? String {
                    try propertyInfo.set(value: stringValue, on: &instance)
                }
            default:
                break
            }
        } catch {
            throw error
        }
    }
}
