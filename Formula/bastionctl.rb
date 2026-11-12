class Bastionctl < Formula
  desc "Find the best EC2 instance to use as an sshuttle pivot into an AWS VPC"
  homepage "https://github.com/ricardoleal/bastionctl"
  license "MIT"

  depends_on "sshuttle"

  on_macos do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.4/bastionctl-darwin-arm64"
      sha256 "7aedb780e07690b1e246a81e2a90f972fa128e901073b39618e90119867c7d3d"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.4/bastionctl-darwin-amd64"
      sha256 "2c7a84efca053661fd53e472ec8298e68f7c979031088085aa3f22ba109fce43"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.4/bastionctl-linux-arm64"
      sha256 "a03dec1942604863afdff565b0691f6bb898b2de2b10dc72b9e300d6f830d410"
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.2.4/bastionctl-linux-amd64"
      sha256 "003a8911b3040ad7206dba63f154df8a2b921fc42ed1518733cef010a6656dd1"
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
