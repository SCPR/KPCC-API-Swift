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

struct ProgramResponse: Codable {
	var program:Program?
}

struct ProgramsResponse: Codable {
	var programs:[Program]	= []
}

public extension Program {
	public static func get(completion: @escaping ([Program]?, KPCCAPIError?) -> Void) {
		guard let components = URLComponents(string: "programs") else {
			DispatchQueue.main.async {
				completion(nil, .buildComponentsError)
			}
			return
		}

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
