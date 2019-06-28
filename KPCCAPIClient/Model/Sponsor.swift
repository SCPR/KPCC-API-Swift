//
//  KPCC API Client
//
//	Sponsor
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Sponsor: Codable {
	/// The sponsor's title.
	public var title:String?

	/// The sponsor's URL.
	public var url:URL?

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case title					= "title"
		case url					= "url"
	}
}
