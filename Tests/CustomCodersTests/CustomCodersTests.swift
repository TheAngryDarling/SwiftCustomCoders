import XCTest
@testable import CustomCoders

class CustomCodersTests: XCTestCase {
    
    struct Name {
        let firstName: String
        let lastName: String
    }
    enum Gender: String, Codable {
        case male = "m"
        case female = "f"
        case other = "o"
    }
    struct SubPersonObject: Codable {
        private enum CodingKeys: CodingKey {
            case valA
            case valB
            case valC
        }
        let valA: Bool
        let valB: String?
        let valC: Int
        
        public init(valA: Bool, valB: String?, valC: Int) {
            self.valA = valA
            self.valB = valB
            self.valC = valC
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.valA = try container.decode(Bool.self, forKey: .valA)
            self.valB = try container.decodeIfPresent(String.self, forKey: .valB)
            //self.valB = try container.decode(String.self, forKey: .valB)
            self.valC = try container.decode(Int.self, forKey: .valC)
            //print("SubPersonObject.init(from:) - \(container.codingPath.stringPath)")
            let _ = true
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.valA, forKey: .valA)
            try container.encodeIfPresent(self.valB, forKey: .valB)
            try container.encode(self.valC, forKey: .valC)
            //print("SubPersonObject.encode(to:) - \(container.codingPath.stringPath)")
            let _ = true
        }
        
    }
    struct Person: Codable {
        let name: Name
        let age: Int
        let gender: Gender
        let subItems: SubPersonObject
    }
    
    
    func testPList() {
        do {
            let xmlEncodedData = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
\t<key>age</key>
\t<integer>36</integer>
\t<key>gender</key>
\t<string>m</string>
\t<key>name</key>
\t<string>Person A</string>
\t<key>subItems</key>
\t<dict>
\t\t<key>valA</key>
\t\t<true/>
\t\t<key>valB</key>
\t\t<string>Test 1</string>
\t\t<key>valC</key>
\t\t<integer>1</integer>
\t</dict>
</dict>
</plist>

"""
            let p1 = Person(name: "Person A",
                            age: 36,
                            gender: .male,
                            subItems: SubPersonObject(valA: true, valB: "Test 1", valC: 1))
            
            let plistEncoder = PListEncoder()
            plistEncoder.outputFormat = .xml
            let plistData = try plistEncoder.encode(p1)
            
            let plistString = String(data: plistData, encoding: .utf8)!
            
            XCTAssertEqual(xmlEncodedData, plistString)
            
            let plistDecoder = PListDecoder()
            let decodedP1 = try plistDecoder.decode(Person.self, from: plistData)
            
            XCTAssertEqual(p1, decodedP1)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            let base64EncodedString = "YnBsaXN0MDDUAQIDBAUGBwhTYWdlVmdlbmRlclRuYW1lWHN1Ykl0ZW1zECRRbVhQZXJzb24gQdMJCgsMDQ5UdmFsQlR2YWxBVHZhbENWVGVzdCAxCRABCBEVHCEqLC43PkNITVRVAAAAAAAAAQEAAAAAAAAADwAAAAAAAAAAAAAAAAAAAFc="
            let p1 = Person(name: "Person A",
                            age: 36,
                            gender: .male,
                            subItems: SubPersonObject(valA: true, valB: "Test 1", valC: 1))
            
            let plistEncoder = PListEncoder()
            plistEncoder.outputFormat = .binary
            let plistData = try plistEncoder.encode(p1)
            
            //let plistBase64String = plistData.base64EncodedString()
            
            //XCTAssertEqual(base64EncodedString, plistBase64String)
            
            let plistDecoder = PListDecoder()
            let decodedP1 = try plistDecoder.decode(Person.self, from: plistData)
            
            XCTAssertEqual(p1, decodedP1)
            
            let base64Data = Data(base64Encoded: base64EncodedString)!
            let decodedP2 = try plistDecoder.decode(Person.self, from: base64Data)
            
            XCTAssertEqual(p1, decodedP2)
            
        } catch {
            XCTFail("\(error)")
        }
    }
    
    /*
     // Used to generate Property List Data for comparison when on a non Apple device
     func testPList2() {
        do {
            let p1 = Person(name: "Person A",
                            age: 36,
                            gender: .male,
                            subItems: SubPersonObject(valA: true, valB: "Test 1", valC: 1))
            let propertyListEncoder = PropertyListEncoder()
            
            propertyListEncoder.outputFormat = .binary
            
            let propertyListData = try propertyListEncoder.encode(p1)
            
            let base64String = propertyListData.base64EncodedString()
            print(base64String)
            
            
        } catch {
            XCTFail("\(error)")
        }
        
    }*/


    static var allTests = [
        ("testPList", testPList),
    ]
}

extension CustomCodersTests.Name: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let n = value.split(separator: " ")
        let f = String(n[0])
        var l = ""
        if n.count > 1 { l = String(n[1]) }
        self.init(firstName: f, lastName: l)
    }
}

extension CustomCodersTests.Name: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let s = try container.decode(String.self)
        self.init(stringLiteral: s)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.firstName + " " + self.lastName)
    }
}

extension CustomCodersTests.Name: Comparable {
    public static func == (lhs: CustomCodersTests.Name, rhs: CustomCodersTests.Name) -> Bool {
        return ((lhs.firstName == rhs.firstName) && (lhs.lastName == rhs.lastName))
    }
    public static func < (lhs: CustomCodersTests.Name, rhs: CustomCodersTests.Name) -> Bool {
        return (lhs.firstName + " " + lhs.lastName) < (rhs.firstName + " " + rhs.lastName)
    }
}

extension CustomCodersTests.SubPersonObject: Equatable {
    public static func == (lhs: CustomCodersTests.SubPersonObject, rhs: CustomCodersTests.SubPersonObject) -> Bool {
        return ((lhs.valA == rhs.valA) && (lhs.valB == rhs.valB) && (lhs.valC == rhs.valC))
    }
}

extension CustomCodersTests.Person: Comparable {
    public static func == (lhs: CustomCodersTests.Person, rhs: CustomCodersTests.Person) -> Bool {
        return ((lhs.age == rhs.age) && (lhs.gender == rhs.gender) && (lhs.name == rhs.name) && (lhs.subItems == rhs.subItems))
    }
    public static func < (lhs: CustomCodersTests.Person, rhs: CustomCodersTests.Person) -> Bool {
        return (lhs.name < rhs.name)
    }
}
