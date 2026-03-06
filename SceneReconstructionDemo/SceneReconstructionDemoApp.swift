//
//  SceneReconstructionDemoApp.swift
//  SceneReconstructionDemo
//
//  Created by Igor Tarantino on 06/03/26.
//

import SwiftUI

@main
struct SceneReconstructionDemoApp: App {
    
    @State private var appModel = AppModel()

    var body: some Scene {

        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: AppModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
