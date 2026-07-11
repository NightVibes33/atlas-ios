# Atlas iOS

Atlas is a native-first iOS app-management and sideloading project with a web dashboard and companion API.

## GitHub-built unsigned IPA

This repository builds a real-device `arm64` unsigned IPA on GitHub's `macos-26` runner using Xcode 26 and the iOS 26 SDK.

Open **Actions → Build unsigned iOS IPA → Run workflow**. The artifact is named `Atlas-unsigned-iOS26-arm64` and contains:

- `Atlas-unsigned.ipa`
- `Atlas-unsigned.ipa.sha256`

The IPA targets physical iPhone/iPad hardware, not the simulator. Because it is intentionally unsigned, it must be signed with a legitimate certificate and matching provisioning profile before installation.
