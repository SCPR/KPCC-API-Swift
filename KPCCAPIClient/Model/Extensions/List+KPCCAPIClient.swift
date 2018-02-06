//
//  KPCC API Client
//
//	List+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct ListResponse: Codable {
	var lists:[List]	= []
}

extension List {
	public static func get(withContext context:String?, completion: @escaping ([List]?, KPCCAPIError?) -> Void) {
		guard var components = URLComponents(string: "lists") else {
			completion(nil, .buildComponentsError)
			return
		}

		var queryItems:[URLQueryItem] = []

		if let context = context {
			queryItems.append(URLQueryItem(name: "context", value: String(context)))
		}

		components.queryItems = queryItems

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let listResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ListResponse.self, from: data)
					let lists			= listResponse.lists
					DispatchQueue.main.async {
						completion(lists, nil)
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

	public static func get(withID listID:Int, completion: @escaping (List?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%d", "lists", listID)
		guard let components = URLComponents(string: urlComponentString) else {
			DispatchQueue.main.async {
				completion(nil, .buildComponentsError)
			}
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let list	= try KPCCAPIClient.shared.jsonDecoder.decode(List.self, from: data)

					DispatchQueue.main.async {
						completion(list, nil)
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
