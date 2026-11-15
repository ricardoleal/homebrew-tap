class Bastionctl < Formula
  desc "Find the best EC2 instance to use as an sshuttle pivot into an AWS VPC"
  homepage "https://github.com/ricardoleal/bastionctl"
  license "MIT"

  depends_on "sshuttle"

  on_macos do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.3.0/bastionctl-darwin-arm64"
      sha256 "d05c99bd7e51d549c8128ad360f481fe3e34072d50ba0ee6400784d65426172b"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.3.0/bastionctl-darwin-amd64"
      sha256 "560475047f93de137e8755875d1fc6b041ddffe232a35b85f80beff62491dce9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.3.0/bastionctl-linux-arm64"
      sha256 "d823cccaf77a75db3872bfc565bf6f6c989edb35edf23a250f4059bc971b743d"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.3.0/bastionctl-linux-amd64"
      sha256 "ec9e6f0d2e76f3715b5646cc86cd03057814424499782cd7e72439c514fee56f"
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
