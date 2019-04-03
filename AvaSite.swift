//
//  AvaSite.swift
//  PUC Clone
//
//  Created by Tomas Martins on 17/03/19.
//  Copyright © 2019 Tomas Martins. All rights reserved.
//

import Foundation

class AvaSite: Codable {
    let entityPrefix: String?
    let siteCollection: [SiteCollection]?
    
    enum CodingKeys: String, CodingKey {
        case entityPrefix
        case siteCollection = "site_collection"
    }
    
    init(entityPrefix: String?, siteCollection: [SiteCollection]?) {
        self.entityPrefix = entityPrefix
        self.siteCollection = siteCollection
    }
}

class SiteCollection: Codable {
    let createdDate: Int?
    let createdTime: EdTime?
    let description: String?
    let iconURL, iconURLFull: JSONNull?
    let id: String?
    let infoURL, infoURLFull, joinerRole: JSONNull?
    let lastModified: Int?
    let maintainRole: String?
    let modifiedDate: Int?
    let modifiedTime: EdTime?
    let owner: String?
    let props: Props?
    let providerGroupID: JSONNull?
    let reference: String?
    let shortDescription, siteGroups: JSONNull?
    let siteOwner: SiteOwner?
    let skin, softlyDeletedDate: JSONNull?
    let title: String?
    let type: JSONNull?
    let userRoles: [String]?
    let activeEdit, customPageOrdered, empty, joinable: Bool?
    let pubView, published, softlyDeleted: Bool?
    let entityReference: String?
    let entityURL: String?
    let entityID, entityTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case createdDate, createdTime, description
        case iconURL = "iconUrl"
        case iconURLFull = "iconUrlFull"
        case id
        case infoURL = "infoUrl"
        case infoURLFull = "infoUrlFull"
        case joinerRole, lastModified, maintainRole, modifiedDate, modifiedTime, owner, props
        case providerGroupID = "providerGroupId"
        case reference, shortDescription, siteGroups, siteOwner, skin, softlyDeletedDate, title, type, userRoles, activeEdit, customPageOrdered, empty, joinable, pubView, published, softlyDeleted, entityReference, entityURL
        case entityID = "entityId"
        case entityTitle
    }
    
    init(createdDate: Int?, createdTime: EdTime?, description: String?, iconURL: JSONNull?, iconURLFull: JSONNull?, id: String?, infoURL: JSONNull?, infoURLFull: JSONNull?, joinerRole: JSONNull?, lastModified: Int?, maintainRole: String?, modifiedDate: Int?, modifiedTime: EdTime?, owner: String?, props: Props?, providerGroupID: JSONNull?, reference: String?, shortDescription: JSONNull?, siteGroups: JSONNull?, siteOwner: SiteOwner?, skin: JSONNull?, softlyDeletedDate: JSONNull?, title: String?, type: JSONNull?, userRoles: [String]?, activeEdit: Bool?, customPageOrdered: Bool?, empty: Bool?, joinable: Bool?, pubView: Bool?, published: Bool?, softlyDeleted: Bool?, entityReference: String?, entityURL: String?, entityID: String?, entityTitle: String?) {
        self.createdDate = createdDate
        self.createdTime = createdTime
        self.description = description
        self.iconURL = iconURL
        self.iconURLFull = iconURLFull
        self.id = id
        self.infoURL = infoURL
        self.infoURLFull = infoURLFull
        self.joinerRole = joinerRole
        self.lastModified = lastModified
        self.maintainRole = maintainRole
        self.modifiedDate = modifiedDate
        self.modifiedTime = modifiedTime
        self.owner = owner
        self.props = props
        self.providerGroupID = providerGroupID
        self.reference = reference
        self.shortDescription = shortDescription
        self.siteGroups = siteGroups
        self.siteOwner = siteOwner
        self.skin = skin
        self.softlyDeletedDate = softlyDeletedDate
        self.title = title
        self.type = type
        self.userRoles = userRoles
        self.activeEdit = activeEdit
        self.customPageOrdered = customPageOrdered
        self.empty = empty
        self.joinable = joinable
        self.pubView = pubView
        self.published = published
        self.softlyDeleted = softlyDeleted
        self.entityReference = entityReference
        self.entityURL = entityURL
        self.entityID = entityID
        self.entityTitle = entityTitle
    }
}

class EdTime: Codable {
    let display: String?
    let time: Int?
    
    init(display: String?, time: Int?) {
        self.display = display
        self.time = time
    }
}

class Props: Codable {
    let contactName, sectionsStudentRegistrationAllowed, sectionsStudentSwitchingAllowed, sectionsExternallyMaintained: String?
    let contactEmail: String?
    
    enum CodingKeys: String, CodingKey {
        case contactName = "contact-name"
        case sectionsStudentRegistrationAllowed = "sections_student_registration_allowed"
        case sectionsStudentSwitchingAllowed = "sections_student_switching_allowed"
        case sectionsExternallyMaintained = "sections_externally_maintained"
        case contactEmail = "contact-email"
    }
    
    init(contactName: String?, sectionsStudentRegistrationAllowed: String?, sectionsStudentSwitchingAllowed: String?, sectionsExternallyMaintained: String?, contactEmail: String?) {
        self.contactName = contactName
        self.sectionsStudentRegistrationAllowed = sectionsStudentRegistrationAllowed
        self.sectionsStudentSwitchingAllowed = sectionsStudentSwitchingAllowed
        self.sectionsExternallyMaintained = sectionsExternallyMaintained
        self.contactEmail = contactEmail
    }
}

class SiteOwner: Codable {
    let userDisplayName, userEntityURL, userID: String?
    
    enum CodingKeys: String, CodingKey {
        case userDisplayName, userEntityURL
        case userID = "userId"
    }
    
    init(userDisplayName: String?, userEntityURL: String?, userID: String?) {
        self.userDisplayName = userDisplayName
        self.userEntityURL = userEntityURL
        self.userID = userID
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
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

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func welcomeTask(with url: URL, completionHandler: @escaping (AvaSite?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
