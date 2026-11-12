class Bastionctl < Formula
  desc "Find the best EC2 instance to use as an sshuttle pivot into an AWS VPC"
  homepage "https://github.com/ricardoleal/bastionctl"
  license "MIT"

  depends_on "sshuttle"

  on_macos do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.2/bastionctl-darwin-arm64"
      sha256 "e089acc52dd1e6479afa1ca3af7ce456cc8a85ab7512d3eeec88c5d19d57d478"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.2/bastionctl-darwin-amd64"
      sha256 "00a15f785d8768190e459d18a85330c2835fac664f2bf42254ddc4f13bc3447f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.2/bastionctl-linux-arm64"
      sha256 "0ef720416fedad0dca116b96e457f789aaf18c78d1b7c0405402b02f4d8a31e5"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.2/bastionctl-linux-amd64"
      sha256 "79ead19f4d5139a086dfce07d7b6de1474c2dfe327ee045318d845bd7e347ef0"
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
