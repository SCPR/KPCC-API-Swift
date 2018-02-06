//
//  KPCC API Client
//
//	List
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public protocol Listable {
}

public struct List: Codable {
	public enum ListIdentity:String, Codable {
		case myPrograms
		case allPrograms
		case headlineArticles
		case curatedPrograms
		case curatedEpisodes
		case curatedArticles
		case curatedEvents
		case other
	}

	public enum ListType:String, Codable {
		case article
		case program
		case episode
	}

	/// The collections's title.
//	var id:String?							= UUID().uuidString
	public var id:Int?

	/// The collections's title.
	public var title:String?

	/// The collections's contexts.
	public var contexts:[String]					= []

	/// The collections's start date.
	public var startsAt:Date?

	/// The collections's end date.
	public var endsAt:Date?

	/// The collections's creation date.
	public var createdAt:Date?

	/// The collections's update date.
	public var updatedAt:Date?

	/// The collection's items.
	public var items:[Listable]						= []

	// INTERNAL...
	
	/// The collection's type.
	public var type:ListType			= .episode

	/// The collection's identity.
	public var identity:ListIdentity	= .other

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(self.id, forKey: .id)
		try container.encode(self.title, forKey: .title)
		try container.encode(self.contexts[0], forKey: .context)
		try container.encode(self.startsAt, forKey: .startsAt)
		try container.encode(self.endsAt, forKey: .endsAt)
		try container.encode(self.createdAt, forKey: .createdAt)
		try container.encode(self.updatedAt, forKey: .updatedAt)
//		try container.encode(self.items, forKey: .items)	// TODO
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		self.id				= try values.decode(Int.self, forKey: .id)
		self.title			= try values.decode(String.self, forKey: .title)

		let context			= try values.decode(String.self, forKey: .context)
		self.contexts		= [context]

		self.startsAt		= try values.decode(Date.self, forKey: .startsAt)
		self.endsAt			= try values.decode(Date.self, forKey: .endsAt)
		self.createdAt		= try values.decode(Date.self, forKey: .createdAt)
		self.updatedAt		= try values.decode(Date.self, forKey: .updatedAt)

		if let items = try? values.decode([Article].self, forKey: .items) {
			self.items		= items
			self.type		= .article
		} else if let items = try? values.decode([Program].self, forKey: .items) {
			self.items		= items
			self.type		= .program
		} else if let items = try? values.decode([Episode].self, forKey: .items) {
			self.items		= items
			self.type		= .episode
		}
	}

	enum CodingKeys: String, CodingKey {
		case id					= "id"
		case title				= "title"
		case context			= "context"
		case startsAt			= "starts_at"
		case endsAt				= "ends_at"
		case createdAt			= "created_at"
		case updatedAt			= "updated_at"
		case items				= "items"
		case type				= "type"
		case identity			= "identity"
	}

	public init(withItems items:[Listable], type:ListType, identity:ListIdentity, title:String) {
		self.items		= items
		self.type		= type
		self.identity	= identity
		self.title		= title
	}
}

extension List: Equatable {
	public static func ==(lhs: List, rhs: List) -> Bool {
		if lhs.id == rhs.id {
			return true
		}

		return false
	}
}
