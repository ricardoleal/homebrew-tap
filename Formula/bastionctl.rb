class Bastionctl < Formula
  desc "Find, test, and remember the best EC2 instance to use as an sshuttle pivot into an AWS VPC"
  homepage "https://github.com/ricardoleal/bastionctl"
  version "0.1.0"
  license "MIT"

  depends_on "sshuttle"

  on_macos do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.1.0/bastionctl-darwin-arm64"
      sha256 "83c76d40e43db80649380b7bd27a5fc39386f73e0dbe85f4b8cd7685c8a5d141"

      def install
        bin.install "bastionctl-darwin-arm64" => "bastionctl"
      end
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.1.0/bastionctl-darwin-amd64"
      sha256 "29e668fe6b386a511cbc781698b72771212f9325379645fe2f1746ff00facb4a"

      def install
        bin.install "bastionctl-darwin-amd64" => "bastionctl"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.1.0/bastionctl-linux-arm64"
      sha256 "75ef224b264787714f27d8382cfd0d32c0447e7876f64a71d9e66c591297faa3"

      def install
        bin.install "bastionctl-linux-arm64" => "bastionctl"
      end
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.1.0/bastionctl-linux-amd64"
      sha256 "4d070ed6cffb21592db26100ad3074288a090f5f5ef5ad50e951267cd6a8eb57"

      def install
        bin.install "bastionctl-linux-amd64" => "bastionctl"
      end
    end
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
    assert_predicate bin/"bastionctl", :exist?
    assert_predicate bin/"bastionctl", :executable?
  end
end
