# Default Codable

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20visionOS-lightgrey)](https://developer.apple.com/swift/)

`Default Codable` 是一个 Swift 库，通过 `@Default` 属性包装器为 `Codable` 类型提供更健壮的解析能力。当 JSON 数据中的类型不匹配时，它会自动提供默认值而不是导致整个解析失败。

## 功能特性

- 为常见类型提供默认值（Bool, String, Int, Double 等）
- 支持类型修复（如将 "true" 字符串解析为布尔值 true）
- 简单易用的 `@Default` 属性包装器
- 完全兼容 Swift 的 Codable 协议

## 安装

### Swift Package Manager

在 `Package.swift` 文件中添加以下依赖：

```swift
dependencies: [
    .package(url: "https://github.com/zhtut/default-codable.git", from: "1.0.0")
]
```

# 使用方法
基本用法
```swift
import DefaultCodable

struct User: Codable {
    @Default var isActive: Bool
    @Default var name: String
    @Default var age: Int
    @Default var score: Double
}

let json = """
{
    "isActive": "true",
    "name": 123,
    "age": "25",
    "score": "9.5"
}
""".data(using: .utf8)!

let user = try JSONDecoder().decode(User.self, from: json)
print(user) 
// User(isActive: true, name: "123", age: 25, score: 9.5)
```

## 自定义类型支持
你可以为任何自定义类型添加默认值支持：

```swift
enum Status: String, DefaultValue, Codable {
    case active
    case inactive
    case pending
    
    static var defaultValue: Status { .pending }
}

struct Account: Codable {
    @Default var status: Status
}

let json = """
{
    "status": "invalid_status"
}
""".data(using: .utf8)!

let account = try JSONDecoder().decode(Account.self, from: json)
print(account.status) // .pending
```
## 可选值支持
```swift
struct Post: Codable {
    @Default var title: String?
    @Default var views: Int
}

let json1 = """
{
    "title": null,
    "views": "1000"
}
""".data(using: .utf8)!

let post1 = try JSONDecoder().decode(Post.self, from: json1)
print(post1.title) // nil
print(post1.views) // 1000

let json2 = """
{
    "views": "invalid"
}
""".data(using: .utf8)!

let post2 = try JSONDecoder().decode(Post.self, from: json2)
print(post2.title) // nil
print(post2.views) // 0
```
## 嵌套结构
```swift
struct Address: Codable {
    @Default var street: String
    @Default var city: String
    @Default var zipCode: String
}

struct Company: Codable {
    @Default var name: String
    var address: Address
}

let json = """
{
    "name": 12345,
    "address": {
        "street": 123,
        "city": true
    }
}
""".data(using: .utf8)!

let company = try JSONDecoder().decode(Company.self, from: json)
print(company.name) // "12345"
print(company.address.street) // "123"
print(company.address.city) // "true"
print(company.address.zipCode) // ""
```
# 实现原理
DefaultValue 协议
```swift
public protocol DefaultValue: Codable {
    static var defaultValue: Self { get }
}
```
任何遵循 DefaultValue 协议的类型都需要提供一个默认值。库已为常见类型提供了默认实现：

* `Bool`: `false`
* `String`: `""`
* `Int`: `0`
* `Double`: `0.0`
* `Optional`: `nil`

@Default 属性包装器
```swift
@propertyWrapper
public struct Default<T: DefaultValue>: Codable {
    public var wrappedValue: T
    // ...
}
```
属性包装器负责处理解码逻辑，当类型不匹配时会尝试类型转换。

## 解码过程
尝试标准解码：首先尝试用声明的类型解码

类型修复：如果失败，尝试从其他类型转换：

* `Bool` ← String/Int/Double
* `String` ← Bool/Int/Double
* `Int/Double` ← Bool/String

回退默认值：如果所有尝试都失败，则返回 defaultValue

类型转换规则
| 目标类型 | 源类型       | 转换示例                     |
|----------|-------------|----------------------------|
| Bool     | String      | "true" → true              |
| Bool     | Int/Double  | 1 → true, 0 → false        |
| String   | Bool        | true → "true"              |
| String   | Int/Double  | 123 → "123"                |
| Int      | String      | "123" → 123                |
| Int      | Double      | 3.14 → 3                   |
| Double   | String      | "3.14" → 3.14              |
| Double   | Int         | 3 → 3.0                    |

## 支持的平台
* iOS
* macOS
* watchOS
* tvOS
* visionOS

# 贡献
欢迎提交问题和拉取请求！

# 许可证
Apache 2.0
