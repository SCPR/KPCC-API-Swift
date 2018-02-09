//
//  KPCC API Client
//
//	Article
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Article: Listable, Codable {
	public enum ArticleType:String {
		case news		= "news"
		case blogs		= "blogs"
		case segments	= "segments"
		case shells		= "shells"
	}

	/// The article's ID.
	public var id:String?					= UUID().uuidString

	/// The article's title.
	public var title:String?

	/// The article's shortened title.
	public var shortTitle:String?

	/// The article's byline.
	public var byline:String?

	/// The article's publish date.
	public var publishedAt:Date?

	/// The article's last-updated date.
	public var updatedAt:Date?

	/// The article's teaser.
	public var teaser:String?

	/// The article's body text.
	public var body:String?					= ""

	/// A URL that leads to the article.
	public var publicURL:URL?

	/// The article's Category.
	public var category:Category?

	/// Any Asset objects associated with the article.
	public var assets:[Asset]				= []

	/// Any Audio objects associated with the article.
	public var audios:[Audio]				= []

	/// Any Attribution objects associated with the article.
	public var attributions:[Attribution]	= []

	/// Any Tag objects associated with the article.
	public var tags:[Tag]					= []

	//// ...

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case id					= "id"
		case title				= "title"
		case shortTitle			= "short_title"
		case byline				= "byline"
		case publishedAt		= "published_at"
		case updatedAt			= "updated_at"
		case teaser				= "teaser"
		case body				= "body"
		case publicURL			= "public_url"
		case category			= "category"
		case assets				= "assets"
		case audios				= "audio"
		case attributions		= "attributions"
		case tags				= "tags"
	}
}

extension Article: Equatable {
	public static func ==(lhs: Article, rhs: Article) -> Bool {
		if lhs.id == rhs.id {
			return true
		}

		return false
	}
}
