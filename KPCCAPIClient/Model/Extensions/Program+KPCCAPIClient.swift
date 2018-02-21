//
//  KPCC API Client
//
//	Program+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct ProgramsResponse: Codable {
	var programs:[Program]	= []
}

struct ProgramResponse: Codable {
	var program:Program?
}

public extension Program {
	/// Retrieve all active (On Air and Online-Only) programs.
	///
	/// # Example:
	/// Retrieving all On Air and Online-Only programs:
	/// ```
	/// Program.get() { (programs, error) in
	///     print(programs)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Programs](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/programs.md)
	///
	/// - Parameter completion: A completion handler containing an array of programs and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(completion: @escaping ([Program]?, KPCCAPIError?) -> Void) {
		self.get(programsWithStatuses: nil, completion: completion)
	}

	/// Retrieve programs with specified statuses.
	///
	/// # Example:
	/// Retrieving active Online-Only programs:
	/// ```
	/// Program.get(programsWithStatuses: [.onlineOnly]) { (programs, error) in
	///     print(programs)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Programs](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/programs.md)
	///
	/// - Parameter completion: A completion handler containing an array of programs and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(programsWithStatuses statuses:[ProgramStatus]?, completion: @escaping ([Program]?, KPCCAPIError?) -> Void) {
		guard var components = URLComponents(string: "programs") else {
			completion(nil, .buildComponentsError)
			return
		}

		var queryItems:[URLQueryItem] = []

		if let statuses = statuses {
			var statusesString = ""
			for status in statuses {
				if statusesString.count > 0 {
					statusesString = statusesString + ","
				}
				statusesString = statusesString + status.rawValue
			}

			queryItems.append(URLQueryItem(name: "air_status", value: statusesString))
		}

		components.queryItems = queryItems

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let programsResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ProgramsResponse.self, from: data)
					let programs			= programsResponse.programs

					DispatchQueue.main.async {
						completion(programs, nil)
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

	/// Retrieve the program associated with a given program slug (ie. "airtalk").
	///
	/// # Example:
	/// Retrieving a program with the slug "airtalk":
	/// ```
	/// Program.get(withProgramSlug: "airtalk") { (program, error) in
	///    print(program)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Programs](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/programs.md)
	///
	/// - Parameters:
	///   - programSlug: The slug associated with the program being retrieved.
	///   - completion: A completion handler with an program and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withProgramSlug programSlug:String, completion: @escaping (Program?, KPCCAPIError?) -> Void) {
		guard let components = URLComponents(string: String(format: "programs/%@", programSlug)) else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let programResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ProgramResponse.self, from: data)
					let program			= programResponse.program

					DispatchQueue.main.async {
						completion(program, nil)
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
