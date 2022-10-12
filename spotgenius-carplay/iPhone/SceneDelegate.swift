//
//  SceneDelegate.swift
//  spotgenius-carplay
//
//
//  Created by Jacob Curtis on 09/08/2022.
//

import UIKit
import SwiftUI
import Flutter

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // Make a button to call the showFlutter function when pressed.
    let button = UIButton(type:UIButton.ButtonType.custom)
    button.addTarget(self, action: #selector(showFlutter), for: .touchUpInside)
    button.setTitle("Show Flutter!", for: UIControl.State.normal)
    button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
    button.backgroundColor = UIColor.blue
    self.view.addSubview(button)
  }

  @objc func showFlutter() {
    let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
    let flutterViewController =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    present(flutterViewController, animated: true, completion: nil)
  }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        let contentView = ContentView()
        let contentView = ViewController()

        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = UIHostingController(rootView: contentView)
            window.rootViewController = contentView
//            window.rootViewController = ViewController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
//            let button = UIButton(type:UIButton.ButtonType.custom)
//            button.addTarget(self,
//                             action: #selector(showFlutter),
//                             for: .touchUpInside)
//            button.setTitle("Show Flutter!", for: UIControl.State.normal)
//            button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
//            button.backgroundColor = UIColor.blue
//            self.window.addSubview(button)
    }
    

}


