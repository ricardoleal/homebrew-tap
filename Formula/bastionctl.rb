class Bastionctl < Formula
  desc "Find the best EC2 instance to use as an sshuttle pivot into an AWS VPC"
  homepage "https://github.com/ricardoleal/bastionctl"
  license "MIT"

  depends_on "sshuttle"

  on_macos do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.1/bastionctl-darwin-arm64"
      sha256 "1161af2f599582ada47d694a8af505f7bb29d33f0901f05fd5ace76a55737b96"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.1/bastionctl-darwin-amd64"
      sha256 "3cd94d3db41044cdcdb524ac9a387f49d97870907e5392e95e1380f980e71b45"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.1/bastionctl-linux-arm64"
      sha256 "15d7537a8be8089d1d092f8e5145f92fcd5b3e8b58dac86466a15eba7302b149"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.1/bastionctl-linux-amd64"
      sha256 "97f187de37f342da1326285dd93f7fba0e3449d2e6901c9be950ef1a3a23e449"
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
