//
//  KPCC API Client
//
//	Episode
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Episode: Listable, Codable {
	/// The episode's ID.
	public var id:String?

	/// The episode's title.
	public var title:String?

	/// The episode's summary.
	public var summary:String?

	/// The episode's air date.
	public var airDate:Date?

	/// The episode's associated Audio objects.
	public var audios:[Audio]?		= []

	/// The episode's public URL.
	public var publicURL:URL?

	/// The episode's Program.
	public var program:Program?

	/// The episode's associated Article objects.
	public var segments:[Article]?	= []

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case id					= "id"
		case title				= "title"
		case summary			= "summary"
		case airDate			= "air_date"
		case audios				= "audio"
		case publicURL			= "public_url"
		case program			= "program"
		case segments			= "segments"
	}
}

