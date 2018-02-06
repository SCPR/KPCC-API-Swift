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
	public static func get(withProgramSlug programSlug:String?, completion: @escaping ([Episode]?, KPCCAPIError?) -> Void) {
		guard var components = URLComponents(string: "episodes") else {
			completion(nil, .buildComponentsError)
			return
		}

		components.queryItems = [
			URLQueryItem(
				name: "program",
				value: programSlug
			),
			URLQueryItem(
				name: "limit",
				value: "8"
			)
		]

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
