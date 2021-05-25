//
//  File.swift
//  
//
//  Created by BJ Beecher on 5/3/21.
//

import Foundation
import Cache

public final class NormalizedCache<Store: StoreInterface> {
    
    let store : Store
    let composer : ComposerInterface
    
    init(store: Store, composer: ComposerInterface) {
        self.store = store
        self.composer = composer
    }
    
    public convenience init<Key: Hashable>() where Store == Cache<Key, Data> {
        self.init(store: Cache<Key, Data>(), composer: Composer())
    }
}

// json API

public extension NormalizedCache {
    func insert(_ json: JSONObject, for key: Store.Key) throws {
        let decomposedValue = try composer.decompose(json)
        let data = try JSONSerialization.data(withJSONObject: decomposedValue, options: [])
        store[key] = data
    }
    
    func json(for key: Store.Key) throws -> JSONObject? {
        guard let decomposedValue = store[key] else { return nil }
        let json = try JSONSerialization.jsonObject(with: decomposedValue, options: []) as! JSONObject
        let value = try composer.recompose(json)
        return value
    }
    
    func update(with json: JSONObject) throws {
        try composer.decompose(json)
    }
}

// data API

public extension NormalizedCache {
    func insert(_ data: Data, for key: Store.Key) throws {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONObject
        try insert(json, for: key)
    }
    
    func data(for key: Store.Key) throws -> Data? {
        guard let json = try json(for: key) else { return nil }
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        return data
    }
    
    func update(with data: Data) throws {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONObject
        try update(with: json)
    }
}

// codable API

public extension NormalizedCache {
    func insert<Object: Codable>(_ object: Object, forKey key: Store.Key) throws {
        let data = try JSONEncoder().encode(object)
        try insert(data, for: key)
    }
    
    func object<Object: Codable>(forKey key: Store.Key) throws -> Object? {
        guard let data = try data(for: key) else { return nil }
        let object = try JSONDecoder().decode(Object.self, from: data)
        return object
    }
}
