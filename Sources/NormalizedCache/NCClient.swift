//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/3/21.
//

import Foundation
import Combine

public final class NCClient<Key: Hashable> {
    var entries : [Key : CachedEntry]
    let composer : Composer
    
    init(entries: [Key : CachedEntry], composer: Composer){
        self.entries = entries
        self.composer = composer
    }
    
    public convenience init(){
        self.init(entries: .init(), composer: .shared)
    }
}

// codable API

public extension NCClient {
    
    /// Inserts object into cache by transforming it from object -> data ->  composed native json (i.e. Any) -> decomposed json
    /// - Parameters:
    ///   - object: Codable object
    ///   - key: Hashable key
    /// - Throws: If error occurs in transformation process
    func insert<Object: Codable>(_ object: Object, forKey key: Key) throws -> CachedEntry {
        let decomposed = try composer.tearDown(object: object)
        let value = CachedEntry(value: decomposed)
        entries[key] = value
        return value
    }
    
    /// Fetches object by transforming it from decomposed json -> composed json -> data -> object
    /// - Parameter key: Hashable key
    /// - Throws: during error in recomposition process
    /// - Returns: Codable object
    func value(forKey key: Key) -> CachedEntry? {
        entries[key]
    }
    
    func object(forId id: UUID) -> CachedObject? {
        let key = ObjectKey(id: id)
        return composer.objects[key]
    }
}
