//
//  ContentView.swift
//  SceneReconstructionDemo
//
//  Created by Igor Tarantino on 06/03/26.
//

import SwiftUI

struct ContentView: View {

    @Environment(AppModel.self) private var appModel

    @Environment(\.openImmersiveSpace)    var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack(spacing: 20) {

            Text("Scene Reconstruction Demo")
                .font(.title)
                .padding(.bottom, 8)

            Text("Move around your room to scan your surroundings and spawn some spheres!")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            switch appModel.immersiveSpaceState {

            case .closed:
                Button("Enter Immersive Space") {
                    Task {
                        appModel.immersiveSpaceState = .inTransition
                        await openImmersiveSpace(id: AppModel.immersiveSpaceID)
                        appModel.immersiveSpaceState = .open
                    }
                }
                .buttonStyle(.borderedProminent)

            case .inTransition:
                ProgressView()
                    .padding()

            case .open:
                Button {
                    appModel.spawnSphere()
                } label: {
                    Label("Spawn Sphere", systemImage: "circle.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .disabled(appModel.rootEntity == nil)

                Button {
                    appModel.clearAll()
                } label: {
                    Label("Clear Scene", systemImage: "trash")
                        .font(.headline)
                }
                .buttonStyle(.bordered)

                Button("Exit Immersive Space") {
                    Task {
                        appModel.immersiveSpaceState = .inTransition
                        await dismissImmersiveSpace()
                        appModel.immersiveSpaceState = .closed
                    }
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.secondary)
            }
        }
        .padding(32)
        .frame(minWidth: 320)
    }
}
