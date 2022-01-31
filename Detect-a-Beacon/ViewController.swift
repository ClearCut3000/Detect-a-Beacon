//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Николай Никитин on 29.01.2022.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

  //MARK: - Properties
  var locationManager: CLLocationManager?

  //MARK: - Outlets
  @IBOutlet var distanceReading: UILabel!

  //MARK: - UIView Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()

    view.backgroundColor = .gray
  }


  //MARK: - Methods
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        if CLLocationManager.isRangingAvailable() {
          startScanning()
        }
      }
    }
  }

  func startScanning() {
    let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
    locationManager?.startMonitoring(for: beaconRegion)
    locationManager?.startRangingBeacons(in: beaconRegion)
  }

  func update(distance: CLProximity) {
    UIView.animate(withDuration: 1) {
      switch distance {
      case .immediate:
        self.view.backgroundColor = .red
        self.distanceReading.text = "IMMEDIATE"
      case .near:
        self.view.backgroundColor = .orange
        self.distanceReading.text = "NEAR"
      case .far:
        self.view.backgroundColor = .blue
        self.distanceReading.text = "FAR"
      default:
        self.view.backgroundColor = .gray
        self.distanceReading.text = "UNKNOWN"
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if let beacon = beacons.first {
      update(distance: beacon.proximity)
    } else {
      update(distance: .unknown)
    }
  }
}

