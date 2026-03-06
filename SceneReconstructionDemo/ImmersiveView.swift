//
//  ImmersiveView.swift
//  SceneReconstructionDemo
//
//  Created by Igor Tarantino on 06/03/26.
//

import SwiftUI
import RealityKit
import ARKit

struct ImmersiveView: View {

    @Environment(AppModel.self) private var appModel

    private let arSession = ARKitSession()

    private let sceneReconstruction = SceneReconstructionProvider(modes: [.classification])

    var body: some View {
        RealityView { content in
            let root = Entity()
            root.name = "SceneRoot"
            content.add(root)

            appModel.rootEntity = root

            root.components.set(PhysicsSimulationComponent())

            Task {
                await startARSession()
                await processReconstructionAnchors(root: root)
            }

        } update: { content in }
    }

    private func startARSession() async {
        
        let authResult = await arSession.requestAuthorization(
            for: [.worldSensing]
        )

        guard authResult[.worldSensing] == .allowed else {
            print("❌ World sensing not authorised – scene reconstruction disabled")
            return
        }

        do {
            guard SceneReconstructionProvider.isSupported else {
                print("⚠️  SceneReconstructionProvider not supported on this device")
                return
            }

            try await arSession.run([sceneReconstruction])
            print("✅ ARKit session running with scene reconstruction")
        } catch {
            print("❌ ARKit session error: \(error)")
        }
    }

    private func processReconstructionAnchors(root: Entity) async {
        for await event in sceneReconstruction.anchorUpdates {
            switch event.event {
            case .added, .updated:
                await updateMeshAnchor(event.anchor, root: root)
            case .removed:
                await removeMeshAnchor(event.anchor, root: root)
            }
        }
    }

    @MainActor
    private func updateMeshAnchor(_ anchor: MeshAnchor, root: Entity) async {
        let id = anchor.id.uuidString

        guard let shape = try? await ShapeResource.generateStaticMesh(from: anchor) else {
            return
        }

        if let existing = root.findEntity(named: id) {
            existing.transform = Transform(matrix: anchor.originFromAnchorTransform)
            existing.components[CollisionComponent.self]?.shapes = [shape]

        } else {
            let meshEntity = Entity()
            meshEntity.name = id

            meshEntity.transform = Transform(matrix: anchor.originFromAnchorTransform)

            meshEntity.components.set(CollisionComponent(shapes: [shape], isStatic: true))

            meshEntity.components.set(
                PhysicsBodyComponent(shapes: [shape], mass: 0, mode: .static)
            )

            if let meshResource = try? await MeshResource(from: anchor) {
                let occlusionMaterial = OcclusionMaterial()
                meshEntity.components.set(
                    ModelComponent(mesh: meshResource, materials: [occlusionMaterial])
                )
            }

            root.addChild(meshEntity)
        }
    }

    @MainActor
    private func removeMeshAnchor(_ anchor: MeshAnchor, root: Entity) {
        let id = anchor.id.uuidString
        root.findEntity(named: id)?.removeFromParent()
    }
}
