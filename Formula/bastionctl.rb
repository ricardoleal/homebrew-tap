class Bastionctl < Formula
  desc "Find, test, and remember the best EC2 instance to use as an sshuttle pivot into an AWS VPC"
  homepage "https://github.com/ricardoleal/bastionctl"
  version "0.1.1"
  license "MIT"

  depends_on "sshuttle"

  on_macos do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.1.0/bastionctl-darwin-arm64"
      sha256 "9197c3a1ea0d1740adbee13a137cca975592471ce7e8efe7820a30e4e293bdd7"

      def install
        bin.install "bastionctl-darwin-arm64" => "bastionctl"
      end
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.1.0/bastionctl-darwin-amd64"
      sha256 "6e4c9267b0de0e6131841f76d97782f5eb79832fa921f9a45405c3633f56893f"

      def install
        bin.install "bastionctl-darwin-amd64" => "bastionctl"
      end
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.1.0/bastionctl-linux-arm64"
      sha256 "f5b4ac9408dcab65c5893c49180d42faf5451ea216b040e76e56a9839ffee83c"

      def install
        bin.install "bastionctl-linux-arm64" => "bastionctl"
      end
    end
    on_intel do
      url "https://github.com/ricardoleal/bastionctl/releases/download/v0.1.0/bastionctl-linux-amd64"
      sha256 "94cafc86946c366d9e070bff48c3bab8fbb95347508bee306a29a7dbd55c9496"

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
