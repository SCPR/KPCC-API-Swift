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

public struct Location: Codable {
	/// The location's title.
	public var title:String?

	/// The location's URL.
	public var url:URL?

	/// The location's address.
	public var address:Address?

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case title				= "title"
		case url				= "url"
		case address			= "address"
	}
}
