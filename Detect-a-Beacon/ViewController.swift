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
  var isFirstDetected = false
  var circleView: UIView!

  //MARK: - Outlets
  @IBOutlet var distanceReading: UILabel!
  @IBOutlet var beaconNameLabel: UILabel!

  //MARK: - UIView Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    locationManager = CLLocationManager()
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()

    view.backgroundColor = .gray

    circleView = UIView()
    circleView.frame.size = CGSize(width: 256, height: 256)
    circleView.layer.cornerRadius = 128
    circleView.backgroundColor = .cyan
    circleView.center = view.center
    view.addSubview(circleView)
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
    addBeacon(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, identifier: "First")
    addBeacon(uuidString: "E2C56DB5-DFFB-48D2B060D0F5A71096E0", major: 123, minor: 456, identifier: "Second")
    addBeacon(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935", major: 123, minor: 456, identifier: "Third")
  }

  func addBeacon(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String) {
    if let uuid = UUID(uuidString: uuidString) {
      let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
      locationManager?.startMonitoring(for: beaconRegion)
      locationManager?.startRangingBeacons(in: beaconRegion)
    }
  }

  func update(distance: CLProximity, with name: String) {

    UIView.animate(withDuration: 0.5) {
      self.beaconNameLabel.text = "\(name)"
      switch distance {
      case .immediate:
        self.view.backgroundColor = .red
        self.distanceReading.text = "IMMEDIATE"
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
          self.circleView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
      case .near:
        self.view.backgroundColor = .orange
        self.distanceReading.text = "NEAR"
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
          self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
      case .far:
        self.view.backgroundColor = .blue
        self.distanceReading.text = "FAR"
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
          self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        }
      default:
        self.view.backgroundColor = .gray
        self.distanceReading.text = "UNKNOWN"
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
          self.circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    if let beacon = beacons.first {
      firstBeaconDetection()
      update(distance: beacon.proximity, with: region.identifier)
    } else {
      update(distance: .unknown, with: "UNKNOWN")
    }
  }

  func firstBeaconDetection() {
    if !isFirstDetected {
      let alert = UIAlertController(title: "Beacon Detected firs time!", message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .cancel))
      isFirstDetected = true
      present(alert, animated: true)
    }
  }
}

