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

struct ListsResponse: Codable {
	var lists:[List]	= []
}

struct ListResponse: Codable {
	var list:List
}

extension List {
	/// Retrieve all lists associated with the (optional) content.
	///
	/// # Example:
	/// Retrieving all lists that have no associated context:
	/// ```
	/// List.get(withContext: nil) { (lists, error) in
	///     print(lists)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Lists](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/lists.md)
	///
	/// - Parameters:
	///   - context: An optional context that the list is associated with. A nil value returns only lists with no associated context.
	///   - completion: A completion handler containing an array of lists and/or an error.
	///
	/// - Author: Jeff Campbell
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
					let listsResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ListsResponse.self, from: data)
					let lists			= listsResponse.lists

					completion(lists, nil)
				} catch _ as DecodingError {
					completion(nil, .decodingError)
				} catch {
					completion(nil, .other)
				}
			} else {
				completion(nil, .dataUnavailable)
			}
		}
	}

	/// Retrieve a list by ID.
	///
	/// # Example:
	/// Retrieving a list with the ID of 123456:
	/// ```
	/// List.get(withID: 123456) { (lists, error) in
	///     print(lists)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Lists](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/lists.md)
	///
	/// - Parameters:
	///   - listID: An ID associated with the list being retrieved.
	///   - completion: A completion handler with a list and/or an error.
	public static func get(withID listID:Int, completion: @escaping (List?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%d", "lists", listID)
		guard let components = URLComponents(string: urlComponentString) else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let listResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ListResponse.self, from: data)
					let list			= listResponse.list

					completion(list, nil)
				} catch _ as DecodingError {
					completion(nil, .decodingError)
				} catch {
					completion(nil, .other)
				}
			} else {
				completion(nil, .dataUnavailable)
			}
		}
	}
}
