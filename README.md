# Atlas for iOS

Atlas is a native iPhone sideloading and app-management application for iOS 26.

Atlas is **not** a web app, web dashboard, API server, browser-based sideloader, or desktop companion product.

## Native transport

Atlas is built around the on-device transport used for SideStore-style workflows:

`LocalDevVPN → minimuxer → lockdown / MobileInstallation`

The native app is responsible for pairing-record handling, IPA installation and refresh operations, JIT requests, AltSource browsing, provisioning diagnostics, secure persistence, and job orchestration.

## GitHub-built unsigned IPA

GitHub Actions builds Atlas for a physical arm64 iPhone using the `macos-26` runner, Xcode 26, and the iOS 26 device SDK. Code signing is disabled, and the workflow packages `Payload/Atlas.app` into an unsigned IPA with a SHA-256 checksum.

An unsigned IPA must be signed with a legitimate certificate and matching provisioning profile before installation.

## Source layout

- `apps/ios/AtlasApp` — native SwiftUI iPhone application.
- `packages/AtlasCore` — Swift models, diagnostics, persistence, refresh planning, and tests.
- `docs` — native architecture, LocalDevVPN integration, and device verification.
- `scripts` — native dependency bootstrap and release checks.
- `.github/workflows` — macOS 26 unsigned device build.

No web application or API server is part of the Atlas product described by this repository.