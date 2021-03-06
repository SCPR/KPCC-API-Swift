//
//  KPCC API Client
//
//	ArticleCategory
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct ArticleCategory: Codable {
	/// The category's ID.
	public var id:Int?

	/// The category's slug (a short, unique text descriptor that can be used as a key).
	public var slug:String?

	/// The category's title.
	public var title:String?

	/// The category's public URL.
	public var publicURL:URL?

	enum CodingKeys: String, CodingKey {
		case id						= "id"
		case slug					= "slug"
		case title					= "title"
		case publicURL				= "public_url"
	}
}

extension ArticleCategory: Equatable {
	public static func == (lhs: ArticleCategory, rhs: ArticleCategory) -> Bool {
		return lhs.slug == rhs.slug
	}
}
