    import XCTest
    @testable import NormalizedCache
    
    struct MockObject : Codable, Equatable {
        var id = UUID()
        let name : String
        let subObject : MockSubObject
        var createdDt = Date()
    }
    
    struct MockSubObject : Codable, Equatable {
        var id = UUID()
        var body : String
        var createdDt = Date()
    }

    final class UpdateCacheTests: XCTestCase {
        func testObjectInsert() throws {
            // given
            let cache = NormalizedCache<UUID>()
            let object = MockObject(name: "Tommy", subObject: .init(body: "IDK"))
            let key = UUID()
            
            // when
            try cache.insert(object, forKey: key)
            let returnedObject : MockObject? = try cache.object(forKey: key)
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
        
        func testArrayOfObjectsInsert() throws {
            // given
            let cache = NormalizedCache<UUID>()
            let object = [MockObject(name: "Tommy", subObject: .init(body: "Cool")), .init(name: "Matt", subObject: .init(body: "Truck"))]
            let key = UUID()
            
            // when
            try cache.insert(object, forKey: key)
            let returnedObject : [MockObject]? = try cache.object(forKey: key)
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
        
        func testPrimitiveInsert() throws {
            // given
            let cache = NormalizedCache<UUID>()
            let object = UUID()
            let key = UUID()
            
            // when
            try cache.insert(object, forKey: key)
            let returnedObject : UUID? = try cache.object(forKey: key)
            
            // then
            XCTAssertEqual(object, returnedObject)
        }
    }
