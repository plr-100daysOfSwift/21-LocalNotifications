//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Paul Richardson on 27/05/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
	}

	@objc func registerLocal() {
		let center = UNUserNotificationCenter.current()

		center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
			if granted {
				print("Yes")
			} else {
				print("Oops!")
			}
		}

	}

	@objc func scheduleLocal(remind: Bool = false) {

		registerCategories()

		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()

		let content = UNMutableNotificationContent()
		content.title = "Time for a Break"
		content.body = "Stand up and be counted!"
		content.categoryIdentifier = "alarm"
		content.userInfo = ["customData": "hoopla"]
		content.sound = .default

		let trigger: UNTimeIntervalNotificationTrigger
		switch remind {
		case false:
			trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
		case true:
			trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
		}

		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)

	}

	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self

		let show = UNNotificationAction(identifier: "show", title: "Show me more ...", options: [.foreground])
		let remind = UNNotificationAction(identifier: "remind", title: "Remind me later", options: [])
		let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [], options: [])

		center.setNotificationCategories([category])

	}

	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

		var title = ""
		var message = ""
		var data = ""

		let userInfo = response.notification.request.content.userInfo
		if let customData = userInfo["customData"] as? String {
			data = customData
		}

		switch response.actionIdentifier {
		case UNNotificationDefaultActionIdentifier:
			title = "Default Notification"
			message = "There is no message."
			showAlert(title, message)
		case "show":
			title = "Alarm Notification"
			message = "The custom data is '\(data)'"
			showAlert(title, message)
		case "remind":
			scheduleLocal(remind: true)
		default:
			break
		}

		completionHandler()
	}

	fileprivate func showAlert(_ title: String, _ message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}

}

