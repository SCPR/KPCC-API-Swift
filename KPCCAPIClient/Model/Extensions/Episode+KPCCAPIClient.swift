//
//  KPCC API Client
//
//	Episode+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct EpisodesResponse: Codable {
	var episodes:[Episode]	= []
}

extension Episode {
	/// Retrieve most recent episodes associated with a given program.
	///
	/// # Example:
	/// Retrieving episodes for a program with the slug `airtalk`:
	/// ```
	/// Episode.get(withProgramSlug: "airtalk") { (episodes, error) in
	///     print(episodes)
	/// }
	/// ```
	///
	/// - Parameters:
	///   - programSlug: The slug associated with the program you wish to retrieve episodes for.
	///   - completion: A completion handler containing an array of episodes and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withProgramSlug programSlug:String, completion: @escaping ([Episode]?, KPCCAPIError?) -> Void) {
		self.get(withProgramSlug: programSlug, limit: nil, page: nil, completion: completion)
	}

	/// Retrieve most recent episodes associated with a given program, with the option to specify a limit count and page number.
	///
	/// # Example:
	/// Retrieving episodes for a program with the slug `airtalk`, limited to 8 episodes:
	/// ```
	/// Episode.get(withProgramSlug: "airtalk", limit:8, page:nil) { (episodes, error) in
	///     print(episodes)
	/// }
	/// ```
	///
	/// - Parameters:
	///   - programSlug: The slug associated with the program you wish to retrieve episodes for.
	///   - limit: The maximum number of episodes to retrieve. A nil value will return the API default (currently 4).
	///   - page: The page of episodes. A nil value will return the the first page.
	///   - completion: A completion handler containing an array of episodes and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withProgramSlug programSlug:String, limit:Int?, page:Int?, completion: @escaping ([Episode]?, KPCCAPIError?) -> Void) {
		// ...


		guard var components = URLComponents(string: "episodes") else {
			completion(nil, .buildComponentsError)
			return
		}

		components.queryItems = [
			URLQueryItem(
				name: "program",
				value: programSlug
			)
		]

		if let limit = limit {
			components.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
		}

		if let page = page {
			components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let episodesResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(EpisodesResponse.self, from: data)
					let episodes			= episodesResponse.episodes

					DispatchQueue.main.async {
						completion(episodes, nil)
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

	/// Retrieve an episode by ID.
	///
	/// # Example:
	/// Retrieving an episode with the ID of 123456:
	/// ```
	/// Episode.get(withID: 123456) { (episodes, error) in
	///     print(episodes)
	/// }
	/// ```
	///
	/// - Parameters:
	///   - episodeID: The ID associated with the episode being retrieved.
	///   - completion: A completion handler with an episode and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withID episodeID:Int, completion: @escaping (Episode?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%d", "episodes", episodeID)
		guard let components = URLComponents(string: urlComponentString) else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let episode	= try KPCCAPIClient.shared.jsonDecoder.decode(Episode.self, from: data)

					DispatchQueue.main.async {
						completion(episode, nil)
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
