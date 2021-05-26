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

	@objc func scheduleLocal() {

		registerCategories()

		let center = UNUserNotificationCenter.current()
		center.removeAllPendingNotificationRequests()

		let content = UNMutableNotificationContent()
		content.title = "Time for a Break"
		content.body = "Stand up and be counted!"
		content.categoryIdentifier = "useful"
		content.userInfo = ["customData": "hoopla"]
		content.sound = .default

		var dateComponents = DateComponents()
		dateComponents.hour = 10
		dateComponents.minute = 30
//		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		center.add(request)

	}

	func registerCategories() {
		let center = UNUserNotificationCenter.current()
		center.delegate = self

		let action = UNNotificationAction(identifier: "show", title: "Show me more ...", options: [.foreground])
		let category = UNNotificationCategory(identifier: "useful", actions: [action], intentIdentifiers: [], options: [])

		center.setNotificationCategories([category])

	}

}

