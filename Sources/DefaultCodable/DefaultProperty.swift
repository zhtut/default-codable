//
//  Default.swift
//  default-codable
//
//  Created by tutuzhou on 2025/6/13.
//

import Foundation


/// 属性包装器
@propertyWrapper
public struct Default<T: DefaultValue>: Codable {
    
    public var wrappedValue: T
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<T: DefaultValue>(_ value: Default<T>, forKey key: KeyedEncodingContainer<K>.Key) throws where T : CustomStringConvertible{
        try encodeIfPresent(value.wrappedValue, forKey: key)
    }
}

extension KeyedDecodingContainer {
    /// 实现解析Default属性包装器的方法，decode Default类型的属性时，会优先进这个方法
    func decode<T: DefaultValue>(_ type: Default<T>.Type, forKey key: K) throws -> Default<T> {
        // 尝试使用T的类型去解，如果成功，则类型是对的
        if let value = try? decode(T.self, forKey: key) {
            return Default(wrappedValue: value)
        } else {
            // 类型不匹配，解析失败，尝试进行类型修复
            if T.self == Bool.self, let bool = decodeBool(for: key, type: T.self) as? T {
                return Default(wrappedValue: bool)
            } else if T.self == String.self, let string = decodeString(for: key, type: T.self) as? T {
                return Default(wrappedValue: string)
            } else if T.self == Double.self, let double = decodeDouble(for: key, type: T.self) as? T {
                return Default(wrappedValue: double)
            } else if T.self == Int.self, let int = decodeInt(for: key, type: T.self) as? T {
                return Default(wrappedValue: int)
            } else {
                return Default(wrappedValue: T.defaultValue)
            }
        }
    }
    
    /// 对bool类型的属性进行修复
    func decodeBool<T: DefaultValue>(for key: K, type: T.Type = T.self) -> Bool {
        if let double = try? decode(Double.self, forKey: key) {
            return double != 0.0
        } else if let str = try? decode(String.self, forKey: key) {
            return !str.isEmpty
        } else if let int = try? decode(Int.self, forKey: key) {
            return int != 0
        } else {
            return Bool.defaultValue
        }
    }
    
    /// 对String类型的属性进行修复
    func decodeString<T: DefaultValue>(for key: K, type: T.Type = T.self) -> String {
        if let bool = try? decode(Bool.self, forKey: key) {
            return "\(bool)"
        } else if let int = try? decode(Int.self, forKey: key) {
            return String(int)
        } else if let double = try? decode(Double.self, forKey: key) {
            return String(double)
        } else {
            return String.defaultValue
        }
    }
    
    /// 对Int类型的属性进行修复
    func decodeInt<T: DefaultValue>(for key: K, type: T.Type = T.self) -> Int {
        if let bool = try? decode(Bool.self, forKey: key) {
            return bool ? 1 : 0
        } else if let str = try? decode(String.self, forKey: key) {
            return Int(str) ?? Int.defaultValue
        } else if let double = try? decode(Double.self, forKey: key) {
            return Int(double)
        } else {
            return Int.defaultValue
        }
    }
    
    /// 对Double类型的属性进行修复
    func decodeDouble<T: DefaultValue>(for key: K, type: T.Type = T.self) -> Double {
        if let bool = try? decode(Bool.self, forKey: key) {
            return bool ? 1.0 : 0.0
        } else if let str = try? decode(String.self, forKey: key) {
            return Double(str) ?? Double.defaultValue
        } else if let int = try? decode(Int.self, forKey: key) {
            return Double(int)
        } else {
            return Double.defaultValue
        }
    }
}


// nil, Bool, String Double Float Int Int8 Int16 Int32 Int64 Int128 UInt UInt8 UInt16 UInt32 UInt64 UInt128

//@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
//public func decode(_ type: UInt128.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt128
