cask "time-machine-trimmer" do
  version "1.0.3"
  sha256 "44b1459f1c5ac03ddd1e966209560aa566681cfc75dfabecf1a5544010403e10"

  url "https://github.com/ricardoleal/TimeMachineTrimmer/releases/download/v#{version}/TimeMachineTrimmer.dmg"
  name "TimeMachineTrimmer"
  desc "Trim old Time Machine backups, reclaim disk space"
  homepage "https://github.com/ricardoleal/TimeMachineTrimmer"

  app "TimeMachineTrimmer.app"

  caveats <<~EOS
    This app requires Full Disk Access.
    To grant it: System Settings → Privacy & Security → Full Disk Access → add TimeMachineTrimmer.

    The app is not signed with a Developer ID certificate.
    If macOS blocks it, open it via: System Settings → Privacy & Security → scroll to "Allow apps from…"
    Or right-click the app and select Open.
  EOS

  zap trash: [
    "~/Library/Application Scripts/com.ricardoleal.TimeMachineTrimmer",
    "~/Library/Containers/com.ricardoleal.TimeMachineTrimmer",
  ]
end
