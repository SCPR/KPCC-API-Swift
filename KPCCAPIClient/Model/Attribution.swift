//
//  KPCC API Client
//
//	Attribution
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Attribution: Codable {
	/// The attribution's name.
	public var name:String?

	/// The attribution's role text.
	public var roleText:String?

	/// The attribution's role ID.
	public var role:Int?

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case name						= "name"
		case roleText					= "role_text"
		case role						= "role"
	}
}

