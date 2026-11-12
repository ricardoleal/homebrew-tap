class Bastionctl < Formula
  desc "Find the best EC2 instance to use as an sshuttle pivot into an AWS VPC"
  homepage "https://github.com/ricardoleal/bastionctl"
  license "MIT"

  depends_on "sshuttle"

  on_macos do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.3/bastionctl-darwin-arm64"
      sha256 "f5e8703522c988d303b47e55f735eaafd1f8d20e34787f17a0b1e2cfe046b182"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.3/bastionctl-darwin-amd64"
      sha256 "340ed71a0299f61f445c32acbf78098352087b5ebe66ae5386a03b3ead469334"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.3/bastionctl-linux-arm64"
      sha256 "42fc69337fd2931d18fc22e6704c02577136ed91b266eeb3700bbb62d5e3288b"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.3/bastionctl-linux-amd64"
      sha256 "2a7ee11a587f5e176b8358f36a284aca6255ea91fd0e54789a1008675fa4712f"
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
