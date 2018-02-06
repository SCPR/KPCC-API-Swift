//
//  KPCC API Client
//
//	Member
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Member: Codable {
	/// The member's ID.
	public var id:Int?

	/// The member's pledge ID.
	public var pledgeID:Int?

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case id							= "id"
		case pledgeID					= "pledge_id"
	}
}
