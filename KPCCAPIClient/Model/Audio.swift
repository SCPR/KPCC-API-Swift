//
//  KPCC API Client
//
//	Audio
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Audio: Codable {
	/// The audio's ID.
	public var id:Int?

	/// The audio's description.
	public var description:String?

	/// The audio's auxiliary description. This is an extra property provided so that we can assign the Audio an alternate description (ie. obtained from a parent Article).
	public var auxiliaryDescription:String?

	/// The audio's URL.
	public var url:URL?

	/// The audio's byline.
	public var byline:String?

	/// The audio's uploaded-at date.
	public var uploadedAt:Date?

	/// The audio's position.
	public var position:Int?

	/// The audio's duration.
	public var duration:TimeInterval?

	/// The audio's file size.
	public var fileSize:Int?

	/// The audio's article object key.
	public var articleObjectKey:String?

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case id						= "id"
		case description			= "description"
		case auxiliaryDescription	= "auxiliary_description"
		case url					= "url"
		case byline					= "byline"
		case uploadedAt				= "uploaded_at"
		case position				= "position"
		case duration				= "duration"
		case fileSize				= "filesize"
		case articleObjectKey		= "article_obj_key"
	}
}

