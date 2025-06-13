import Testing
import Foundation
@testable import DefaultCodable

enum Like: String, Codable, DefaultValue {
    
    static var defaultValue: Like {
        .unknown
    }

    case ball
    case swim
    
    case unknown
}

struct Dog: Codable {
    @Default
    var name: String
}

struct Student: Codable {
    
    @Default
    var name: String
    
    @Default
    var optionalName: String?
    
    @Default
    var age: Int
    
    @Default
    var optionalAge: Int?
    
    @Default
    var male: Bool
    
    @Default
    var optionalMale: Bool?
    
    @Default
    var money: Double
    
    @Default
    var optionalMoney: Double?
    
    @Default
    var like: Like
    
    @Default
    var optionalLike: Like?
    
    var dog: Dog?
}

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let boolValue: Double? = 15.65664654
    let dict = ["name": boolValue, "dog": ["name": "旺财"]] as [String : Any?] // Intentionally wrong type for name
    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
    let model = try JSONDecoder().decode(Student.self, from: data)
    print("model.name=\(model.name)， model.age=\(model.age), model.dog.name=\(model.dog?.name ?? "")")
}

func decode(_ dict: [String: Any?]) throws -> Student {
    let data = try JSONSerialization.data(withJSONObject: dict, options: [])
    let model = try JSONDecoder().decode(Student.self, from: data)
    return model
}

@Test func testBool() async throws {
    #expect(try decode([:]).male == false)
    #expect(try decode(["male": "1"]).male == true)
    #expect(try decode(["male": ""]).male == false)
    #expect(try decode(["male": nil]).male == false)
    #expect(try decode(["male": 1]).male == true)
    #expect(try decode(["male": 1.1]).male == true)
    #expect(try decode(["male": 0]).male == false)
    #expect(try decode(["male": true]).male == true)
    #expect(try decode(["male": false]).male == false)
    
    #expect(try decode([:]).optionalMale == nil)
    #expect(try decode(["optionalMale": "1"]).optionalMale == nil)
    #expect(try decode(["optionalMale": ""]).optionalMale == nil)
    #expect(try decode(["optionalMale": nil]).optionalMale == nil)
    #expect(try decode(["optionalMale": 1]).optionalMale == nil)
    #expect(try decode(["optionalMale": 1.1]).optionalMale == nil)
    #expect(try decode(["optionalMale": 0]).optionalMale == nil)
    #expect(try decode(["optionalMale": true]).optionalMale == true)
    #expect(try decode(["optionalMale": false]).optionalMale == false)
}

@Test func testDouble() async throws {
    #expect(try decode([:]).money == 0)
    #expect(try decode(["money": "1"]).money == 1)
    #expect(try decode(["money": ""]).money == 0)
    #expect(try decode(["money": nil]).money == 0)
    #expect(try decode(["money": 1]).money == 1)
    #expect(try decode(["money": 1.1]).money == 1.1)
    #expect(try decode(["money": 0]).money == 0)
    #expect(try decode(["money": true]).money == 1)
    #expect(try decode(["money": false]).money == 0)
    
    #expect(try decode([:]).optionalMoney == nil)
    #expect(try decode(["optionalMoney": "1"]).optionalMoney == nil)
    #expect(try decode(["optionalMoney": ""]).optionalMoney == nil)
    #expect(try decode(["optionalMoney": nil]).optionalMoney == nil)
    #expect(try decode(["optionalMoney": 1]).optionalMoney == 1)
    #expect(try decode(["optionalMoney": 1.1]).optionalMoney == 1.1)
    #expect(try decode(["optionalMoney": 0]).optionalMoney == 0)
    #expect(try decode(["optionalMoney": true]).optionalMoney == nil)
    #expect(try decode(["optionalMoney": false]).optionalMoney == nil)
}

@Test func testString() async throws {
    #expect(try decode([:]).name == "")
    #expect(try decode(["name": "1"]).name == "1")
    #expect(try decode(["name": ""]).name == "")
    #expect(try decode(["name": nil]).name == "")
    #expect(try decode(["name": 1]).name == "1")
    #expect(try decode(["name": 1.1]).name == "1.1")
    #expect(try decode(["name": 0]).name == "0")
    #expect(try decode(["name": true]).name == "true")
    #expect(try decode(["name": false]).name == "false")
    
    #expect(try decode([:]).optionalName == nil)
    #expect(try decode(["optionalName": "1"]).optionalName == "1")
    #expect(try decode(["optionalName": ""]).optionalName == "")
    #expect(try decode(["optionalName": nil]).optionalName == nil)
    #expect(try decode(["optionalName": 1]).optionalName == nil)
    #expect(try decode(["optionalName": 1.1]).optionalName == nil)
    #expect(try decode(["optionalName": 0]).optionalName == nil)
    #expect(try decode(["optionalName": true]).optionalName == nil)
    #expect(try decode(["optionalName": false]).optionalName == nil)
}

@Test func testInt() async throws {
    #expect(try decode([:]).age == 0)
    #expect(try decode(["age": "1"]).age == 1)
    #expect(try decode(["age": "1.1"]).age == 0)
    #expect(try decode(["age": nil]).age == 0)
    #expect(try decode(["age": 1]).age == 1)
    #expect(try decode(["age": 1.1]).age == 1)
    #expect(try decode(["age": 0]).age == 0)
    #expect(try decode(["age": true]).age == 1)
    #expect(try decode(["age": false]).age == 0)
    
    #expect(try decode([:]).optionalAge == nil)
    #expect(try decode(["optionalAge": "1"]).optionalAge == nil)
    #expect(try decode(["optionalAge": ""]).optionalAge == nil)
    #expect(try decode(["optionalAge": nil]).optionalAge == nil)
    #expect(try decode(["optionalAge": 1]).optionalAge == 1)
    #expect(try decode(["optionalAge": 1.1]).optionalAge == nil)
    #expect(try decode(["optionalAge": 0]).optionalAge == 0)
    #expect(try decode(["optionalAge": true]).optionalAge == nil)
    #expect(try decode(["optionalAge": false]).optionalAge == nil)
}

@Test func testEnum() async throws {
    #expect(try decode([:]).like == .unknown)
    #expect(try decode(["like": "ball"]).like == .ball)
    #expect(try decode(["like": "swim"]).like == .swim)
    #expect(try decode(["like": "eat"]).like == .unknown)
    #expect(try decode(["like": nil]).like == .unknown)
    #expect(try decode(["like": 1]).like == .unknown)
    #expect(try decode(["like": 1.1]).like == .unknown)
    #expect(try decode(["like": 0]).like == .unknown)
    #expect(try decode(["like": true]).like == .unknown)
    #expect(try decode(["like": false]).like == .unknown)
    
    #expect(try decode([:]).optionalLike == nil)
    #expect(try decode(["optionalLike": "ball"]).optionalLike == .ball)
    #expect(try decode(["optionalLike": "swim"]).optionalLike == .swim)
    #expect(try decode(["optionalLike": "eat"]).optionalLike == nil)
    #expect(try decode(["optionalLike": nil]).optionalLike == nil)
    #expect(try decode(["optionalLike": 1]).optionalLike == nil)
    #expect(try decode(["optionalLike": 1.1]).optionalLike == nil)
    #expect(try decode(["optionalLike": 0]).optionalLike == nil)
    #expect(try decode(["optionalLike": true]).optionalLike == nil)
    #expect(try decode(["optionalLike": false]).optionalLike == nil)
}
