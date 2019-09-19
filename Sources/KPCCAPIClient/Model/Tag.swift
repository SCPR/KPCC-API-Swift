//
//  KPCC API Client
//
//	Tag
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Tag: Codable {
	/// The tag's title.
	public var title:String?

	/// The tag's slug (a short, unique text descriptor that can be used as a key).
	public var slug:String?

	public init() {
	}
}

