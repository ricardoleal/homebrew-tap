class Bastionctl < Formula
  desc "Find the best EC2 instance to use as an sshuttle pivot into an AWS VPC"
  homepage "https://github.com/ricardoleal/bastionctl"
  license "MIT"

  depends_on "sshuttle"

  on_macos do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.0/bastionctl-darwin-arm64"
      sha256 "e69cd45678c3b0dbb0d712155fa837354c1e41ec3cbb80e5c976d4f242a8d2ad"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.0/bastionctl-darwin-amd64"
      sha256 "f94a29ef4e61e719ccfc1b11bd6f6ffe687b41141302a41ad86a0b7a79599167"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.0/bastionctl-linux-arm64"
      sha256 "5ce37999363b2185514f211db4e62432334791d41531e5beb490b591e94ab555"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.0/bastionctl-linux-amd64"
      sha256 "21ea63fbe3b2144eb24f9214c4b0030f4083a485a52aca3017adcd920dd25894"
    end
  end

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "amd64" : "arm64"
    bin.install "bastionctl-#{os}-#{arch}" => "bastionctl"
  end

  def caveats
    <<~EOS
      bastionctl hands off tunneling to sshuttle (installed as a dependency).
      For SSM-brokered targets (no public IP) you also need:
        brew install --cask session-manager-plugin
      and a ~/.ssh/config entry:
        Host i-* mi-*
          ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
      See: https://github.com/ricardoleal/bastionctl#prerequisites-for-ssm-brokered-targets
    EOS
  end

  test do
    assert_path_exists bin/"bastionctl"
    assert_predicate bin/"bastionctl", :executable?
  end
end
