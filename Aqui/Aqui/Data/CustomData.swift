//
//  Data.swift
//  Aqui
//
//  Created by Dara on 2022-10-24.
//

import Foundation

// GeoCoding Data
// MARK: - GeoDatum
class CustomData {
    
    var unsplashAccessKey:String = ""
    var openWeatherAccesKey:String = ""
    var apiEndpoint:String = ""
    var geoCodeEndpoint:String = ""
    var shared:CustomData?
    var endPoints:[(String,String, String)] = []
    var cities = CityNames().cities
    
    init() {
        self.cities.sort()
        unsplashAccessKey = "awkrECBV-8LDjNdntp1hkVNjPBIqlHyU0P3UfV77Qow"
        openWeatherAccesKey = "33e1f41bba4a75c81313adfc371840c5"
        apiEndpoint = "http://api.openweathermap.org/data/2.5/air_pollution?lat={lat}&lon={lon}&appid=\(openWeatherAccesKey)"
        for city in self.cities {
            if(city.contains(" ")){
                let cityName = city.replacingOccurrences(of: " ", with: "%20")
                endPoints.append((
                    "https://api.unsplash.com/search/photos/?client_id=\(unsplashAccessKey)&page=1&query=\(cityName)",
                    "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&appid=\(openWeatherAccesKey)",
                    cityName
                ))
            }else{
                endPoints.append((
                    "https://api.unsplash.com/search/photos/?client_id=\(unsplashAccessKey)&page=1&query=\(city)",
                    "http://api.openweathermap.org/geo/1.0/direct?q=\(city)&appid=\(openWeatherAccesKey)",
                    city
                ))
                
            }
        }
    }

    func makeEndpoint(city name:String) -> (String,String){
        if(name.contains(" ")){
            let cityName = name.replacingOccurrences(of: " ", with: "%20")
            return(
                "https://api.unsplash.com/search/photos/?client_id=\(unsplashAccessKey)&page=1&query=\(cityName)",
                "http://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&appid=\(openWeatherAccesKey)"
            )
        }else{
            return(
                "https://api.unsplash.com/search/photos/?client_id=\(unsplashAccessKey)&page=1&query=\(name)",
                "http://api.openweathermap.org/geo/1.0/direct?q=\(name)&appid=\(openWeatherAccesKey)"
            )
            
        }
        return ("", "")
    }
    // MARK: - GeoDatumElement
    struct GeoDatum : Codable {
        let name: String?
        let localNames: LocalNames?
        let lat, lon: Double?
        let country, state: String?
    }
    
    // MARK: - LocalNames
    struct LocalNames :Codable {
        let af, ar, ascii, az: String?
        let bg, ca, da, de: String?
        let el, en, eu, fa: String?
        let featureName, fi, fr, gl: String?
        let he, hi, hr, hu: String?
        let id, it, ja, la: String?
        let lt, mk, nl, no: String?
        let pl, pt, ro, ru: String?
        let sk, sl, sr, th: String?
        let tr, vi, zu: String?
    }
    
    
    
    // Air quality index data
    // MARK: - AirData
    struct AirData: Codable {
        var coord: Coord?
        var list: [List]?
    }
    
    // MARK: - Coord
    struct Coord: Codable {
        var lon, lat: Double?
    }
    
    // MARK: - List
    struct List: Codable {
        var main: Main?
        var components: [String: Double]?
        var dt: Int?
    }
    
    // MARK: - Main
    struct Main: Codable {
        var aqi: Int?
    }
    
    
    
    //Image data
    
    // MARK: - ImageData
    struct ImageData: Codable {
        var total, totalPages: Int?
        var results: [Result]?
        
        enum CodingKeys: String, CodingKey {
            case total
            case totalPages
            case results
        }
    }
    
    // MARK: - Result
    struct Result: Codable {
        var id: String?
        var createdAt, updatedAt: Date?
        var promotedAt: JSONNull?
        var width, height: Int?
        var color, blurHash, resultDescription: String?
        var altDescription: String?
        var urls: Urls?
        var links: ResultLinks?
        var likes: Int?
        var likedByUser: Bool?
        var currentUserCollections: [JSONAny]?
        var sponsorship: JSONNull?
        var topicSubmissions: TopicSubmissions?
        var user: User?
        var tags: [Tag]?
        
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt
            case updatedAt
            case promotedAt
            case width, height, color
            case blurHash
            case resultDescription
            case altDescription
            case urls, links, likes
            case likedByUser
            case currentUserCollections
            case sponsorship
            case topicSubmissions
            case user, tags
        }
    }
    
    // MARK: - ResultLinks
    struct ResultLinks: Codable {
        var linksSelf, html, download, downloadLocation: String?
        
        enum CodingKeys: String, CodingKey {
            case linksSelf
            case html, download
            case downloadLocation
        }
    }
    
    // MARK: - Tag
    struct Tag: Codable {
        var type, title: String?
    }
    
    // MARK: - TopicSubmissions
    struct TopicSubmissions: Codable {
        var interiors: Interiors?
        var fashion: Fashion?
    }
    
    // MARK: - Fashion
    struct Fashion: Codable {
        var status: String?
    }
    
    // MARK: - Interiors
    struct Interiors: Codable {
        var status: String?
        var approvedOn: Date?
        
        enum CodingKeys: String, CodingKey {
            case status
            case approvedOn
        }
    }
    
    // MARK: - Urls
    struct Urls: Codable {
        var raw, full, regular, small: String?
        var thumb, smallS3: String?
        
        enum CodingKeys: String, CodingKey {
            case raw, full, regular, small, thumb
            case smallS3
        }
    }
    
    // MARK: - User
    struct User: Codable {
        var id: String?
        var updatedAt: Date?
        var username, name, firstName, lastName: String?
        var twitterUsername: String?
        var portfolioURL: String?
        var bio, location: String?
        var links: UserLinks?
        var profileImage: ProfileImage?
        var instagramUsername: String?
        var totalCollections, totalLikes, totalPhotos: Int?
        var acceptedTos, forHire: Bool?
        var social: Social?
        
        enum CodingKeys: String, CodingKey {
            case id
            case updatedAt
            case username, name
            case firstName
            case lastName
            case twitterUsername
            case portfolioURL
            case bio, location, links
            case profileImage
            case instagramUsername
            case totalCollections
            case totalLikes
            case totalPhotos
            case acceptedTos
            case forHire
            case social
        }
    }
    
    // MARK: - UserLinks
    struct UserLinks: Codable {
        var linksSelf, html, photos, likes: String?
        var portfolio, following, followers: String?
        
        enum CodingKeys: String, CodingKey {
            case linksSelf
            case html, photos, likes, portfolio, following, followers
        }
    }
    
    // MARK: - ProfileImage
    struct ProfileImage: Codable {
        var small, medium, large: String?
    }
    
    // MARK: - Social
    struct Social: Codable {
        var instagramUsername: String?
        var portfolioURL: String?
        var twitterUsername: String?
        var paypalEmail: JSONNull?
        
        enum CodingKeys: String, CodingKey {
            case instagramUsername
            case portfolioURL
            case twitterUsername
            case paypalEmail
        }
    }
    
    // MARK: - Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        public var hashValue: Int {
            return 0
        }
        
        public func hash(into hasher: inout Hasher) {
            // No-op
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required init?(intValue: Int) {
            return nil
        }
        
        required init?(stringValue: String) {
            key = stringValue
        }
        
        var intValue: Int? {
            return nil
        }
        
        var stringValue: String {
            return key
        }
    }
    
    class JSONAny: Codable {
        
        let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }
    
}



