//
//  KPCC API Client
//
//	Event
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Event: Codable {
	public enum EventType:String, Codable {
		/// A Forum: Community Engagement event.
		case communityEnagement		= "comm"

		/// A Forum: Cultural event.
		case cultural				= "cult"

		/// A Forum: Town Hall event.
		case townHall				= "hall"

		/// A sponsored event.
		case sponsored				= "spon"

		/// A staff pick event.
		case staffPick				= "pick"
	}

	/// The event's ID.
	public var id:Int?

	/// The event's title.
	public var title:String?

	/// A URL that leads to the event.
	public var publicURL:URL?

	/// The event's last-updated date.
	public var updatedAt:Date?

	/// The event's starting date.
	public var startsAt:Date?

	/// The event's ending date.
	public var endsAt:Date?

	/// The event's all-day status.
	public var isAllDay:Bool?

	/// The event's teaser.
	public var teaser:String?

	/// The event's body.
	public var body:String?

	/// The event's past-tense body.
	public var pastTenseBody:String?

	/// The event's hashtag (used for social media, omitting the leading '#').
	public var hashtag:String?

	/// The event's type.
	public var eventType:EventType?

	/// The event's status as being officially held by KPCC or not.
	public var isHouse:Bool?

	/// The event's location.
	public var location:Location?

	/// The event's sponsor.
	public var sponsor:Sponsor?

	/// A URL that leads to a page for RSVPing to the event.
	public var rsvpURL:URL?

	/// The event's associated Program.
	public var program:Program?

	/// Any Asset objects associated with the event.
	public var assets:[Asset]				= []

	/// Any Audio objects associated with the event.
	public var audios:[Audio]				= []

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case id					= "id"
		case title				= "title"
		case publicURL			= "public_url"
		case updatedAt			= "updated_at"
		case startsAt			= "starts_at"
		case endsAt				= "ends_at"
		case isAllDay			= "is_all_day"
		case teaser				= "teaser"
		case body				= "body"
		case pastTenseBody		= "past_tense_body"
		case hashtag			= "hashtag"
		case eventType			= "event_type"
		case isHouse			= "is_kpcc"
		case location			= "location"
		case sponsor			= "sponsor"
		case rsvpURL			= "rsvp_url"
		case program			= "program"
		case assets				= "assets"
		case audios				= "audio"
	}
}
