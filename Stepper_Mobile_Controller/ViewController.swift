//
//  ViewController.swift
//  Stepper_Mobile_Controller
//
//  Created by Jatin on 23/05/18.
//  Copyright © 2018 Jatin. All rights reserved.
//

import UIKit
import SocketIO

extension SocketIOClient {
  
  func moveMotor(_ direction: motorDirection) {
    emit("motor", direction.rawValue)
  }
  
}

enum motorDirection: Int {
  case STOP = 0
  case FORWARD = 1
  case BACKWARD = 2
}

class ViewController: UIViewController {
  
  // ADD YOUR Raspberry Pi's ip address here
  let manager = SocketManager(socketURL: URL(string: "http://192.168.0.105:8080")!,
                              config: [.log(true), .compress])
  
  var socket: SocketIOClient!
  var isSocketConnected = false
  
  @IBOutlet weak var connectButton: UIButton!
  
  // MARK: - Connection setting
  
  @IBAction func connectButtonTapped(_ sender: Any) {
    if !isSocketConnected {
      socket = manager.defaultSocket
      socket.connect()
      connectButton.setTitleColor(UIColor.red, for: .normal)
      connectButton.setTitle("Disconnect", for: .normal)
    } else {
      socket.disconnect()
      connectButton.setTitleColor(UIColor.green, for: .normal)
      connectButton.setTitle("Connect", for: .normal)
    }
    isSocketConnected = !isSocketConnected
  }
  
  // MARK: - Down Button Actions
  
  @IBAction func downButtonTapped(_ sender: Any) {
    stop()
  }
  
  @IBAction func downTouchStarted(_ sender: Any) {
    goBackward()
  }
  // MARK: - Up Button Actions
  
  @IBAction func upButtonTapped(_ sender: UIButton) {
    stop()
  }
  
  @IBAction func touchUpStarted(_ sender: Any) {
    goForward()
  }
  
  // MARK: - Helper Methods
  
  func goForward() {
    socket.moveMotor(.FORWARD)
  }
  
  func goBackward() {
    socket.moveMotor(.BACKWARD)
  }
  
  func stop() {
    socket.moveMotor(.STOP)
  }

}

