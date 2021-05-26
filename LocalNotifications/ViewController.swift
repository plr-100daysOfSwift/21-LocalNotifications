//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Paul Richardson on 27/05/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

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

	}

}

