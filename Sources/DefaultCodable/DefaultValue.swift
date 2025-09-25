//
//  DefaultValue.swift
//  default-codable
//
//  Created by tutuzhou on 2025/6/13.
//

import Foundation

/// 默认属性的协议
public protocol DefaultValue: Codable {
    /// 提供一个默认静态实例
    static var defaultValue: Self { get }
}

/// Optional的默认值是nil
extension Optional: DefaultValue where Wrapped: DefaultValue {
    public static var defaultValue: Wrapped? { nil }
}

/// Bool的默认值是false
extension Bool: DefaultValue {
    public static var defaultValue: Bool { false }
}

/// String的默认值是空字符串
extension String: DefaultValue {
    public static var defaultValue: String { "" }
}

/// Double的默认值是0.0
extension Double: DefaultValue {
    public static var defaultValue: Double { 0.0 }
}

/// Int的默认值是0
extension Int: DefaultValue {
    public static var defaultValue: Int { 0 }
}

/// 数组的默认值是空数组
extension Array: DefaultValue where Element: Codable {
    public static var defaultValue: Array { [] }
}

/// 字典的默认值是空字典
extension Dictionary: DefaultValue where Key: Codable, Value: Codable {
    public static var defaultValue: Dictionary { [:] }
}
