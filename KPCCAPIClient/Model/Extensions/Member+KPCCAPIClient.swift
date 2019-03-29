//
//  KPCC API Client
//
//	Member+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct MemberResponse: Codable {
	var member:Member?
}

extension Member {
	/// Retrieve a member by pledge token.
	///
	/// # Example:
	/// Retrieving a member with the pledge token `asdf1234`:
	/// ```
	/// Member.get(withPledgeToken: "asdf1234") { (member, error) in
	///    print(member)
	/// }
	/// ```
	///
	/// - Parameters:
	///   - pledgeToken: The member's pledge token.
	///   - completion: A completion handler with a member and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withPledgeToken pledgeToken:String, completion: @escaping (Member?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%@", "members", pledgeToken)
		guard let components = URLComponents(string: urlComponentString) else {
			DispatchQueue.main.async {
				completion(nil, .buildComponentsError)
			}
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let memberResponse					= try KPCCAPIClient.shared.jsonDecoder.decode(MemberResponse.self, from: data)
					var member							= memberResponse.member

					member?.authenticatedStreamCodes	= ["pledgefree"]

					DispatchQueue.main.async {
						completion(member, nil)
					}
				} catch _ as DecodingError {
					DispatchQueue.main.async {
						completion(nil, .decodingError)
					}
				} catch {
					DispatchQueue.main.async {
						completion(nil, .other)
					}
				}
			} else {
				DispatchQueue.main.async {
					completion(nil, .dataUnavailable)
				}
			}
		}
	}
}
