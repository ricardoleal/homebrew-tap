cask "time-machine-trimmer-dev" do
  version "1.0.4-dev"
  sha256 "bc0b5c8b872ca676ea8e139e78cb477598fd20bb4b3de875b5fbb16cf32eec21"

  url "https://github.com/ricardoleal/TimeMachineTrimmer/releases/download/v#{version}/TimeMachineTrimmer.dmg"
  name "TimeMachineTrimmer Dev"
  desc "Trim old Time Machine backups, reclaim disk space (dev build)"
  homepage "https://github.com/ricardoleal/TimeMachineTrimmer"

  conflicts_with cask: "time-machine-trimmer"

  app "TimeMachineTrimmer.app"

  caveats <<~EOS
    This is a development prerelease build.

    This app requires Full Disk Access.
    To grant it: System Settings → Privacy & Security → Full Disk Access → add TimeMachineTrimmer.

    The app is not signed with a Developer ID certificate.
    If macOS blocks it, open it via: System Settings → Privacy & Security → scroll to "Allow apps from…"
    Or right-click the app and select Open.

    macOS 27 is not yet supported. If you encounter issues, check for updates
    at https://github.com/ricardoleal/TimeMachineTrimmer.
  EOS

  zap trash: [
    "~/Library/Application Scripts/com.ricardoleal.TimeMachineTrimmer",
    "~/Library/Containers/com.ricardoleal.TimeMachineTrimmer",
  ]
end
