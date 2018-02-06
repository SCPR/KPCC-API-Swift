//
//  KPCC API Client
//
//	Developer(s): Jeff A. Campbell, Christopher Fuller
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import UIKit

internal class BackgroundTask {
	internal lazy var application = UIApplication.shared

	fileprivate var identifier = UIBackgroundTaskInvalid

	internal init?(_ name: String, expirationHandler handler:(() -> Void)? = nil) {
		identifier = application.beginBackgroundTask(withName: name) {
			handler?()
			self.end()
		}

		if identifier == UIBackgroundTaskInvalid {
			return nil
		}
	}
}

extension BackgroundTask {
	func end() {
		if identifier != UIBackgroundTaskInvalid {
			application.endBackgroundTask(identifier)
			identifier = UIBackgroundTaskInvalid
		}
	}
}

