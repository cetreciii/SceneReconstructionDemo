# 🔴 SceneReconstructionDemo

A beginner-friendly **visionOS app** that spawns red spheres into your real environment using ARKit and RealityKit. The spheres fall with gravity, roll on your floor, and bounce off your walls in mixed reality.

> Built as a learning project to explore scene reconstruction and physics on Apple Vision Pro.

---

## 📱 What It Does

- Tap **"Spawn Sphere"** to drop a red ball into your room
- The ball reacts to gravity and rolls on your actual floor
- It collides with your real walls and furniture
- Tap **"Clear Scene"** to remove all balls at once

---

## 🛠️ Requirements

| Requirement | Details |
|---|---|
| Device | Apple Vision Pro |
| Xcode | 15.2 or later |
| Deployment Target | visionOS 1.0+ |
| Apple Developer Account | Required for device builds |

> ⚠️ The Simulator does **not** support LiDAR or scene reconstruction. You need a real device.

---

## 🚀 Getting Started

**1. Clone the repository**
```bash
git clone https://github.com/your-username/SceneReconstructionDemo.git
```

**2. Open in Xcode**

**3. Add your development team**

Go to the project settings → **Signing & Capabilities** → select your Apple Developer team.

**4. Enable the ARKit capability**

Still in Signing & Capabilities, click **+ Capability**, add **ARKit**, and turn on **World Sensing**.

**5. Build & run on your Vision Pro**

Select your device from the run destination menu and run.

---

## 📁 Project Structure

```
SceneReconstructionDemo/
├── SceneReconstructionDemoApp.swift    # App entry point - declares the Window and AR scene
├── AppModel.swift                      # Shared logic - spawning spheres, clearing the scene
├── ContentView.swift                   # The 2D control panel (buttons)
├── ImmersiveView.swift                 # The AR scene - LiDAR scanning, physics, collision
└── Info.plist                          # Privacy descriptions required by Apple
```

---

## 🧠 Key Concepts 

**Entity–Component System (ECS)**

In RealityKit, a sphere is just an empty `Entity`. You give it behaviour by attaching *components* — a mesh to look like a sphere, a collision shape to bump into things, and a physics body to fall and roll.

**Scene Reconstruction**

The `SceneReconstructionProvider` in `ImmersiveView.swift` reads the LiDAR sensor and turns your real room into invisible collision geometry. That's what makes the spheres land on your floor instead of falling forever.

**Shared State with @Observable**

`AppModel` is the bridge between the UI and the 3D scene. Both the button panel and the AR view read from the same model. This is a common and clean pattern in SwiftUI apps.

---

## 📄 License

MIT — free to use, learn from, and modify.
