# homebrew-tap

Personal Homebrew tap for [ricardoleal](https://github.com/ricardoleal)'s macOS apps and CLI tools.

## What's available

| Package | Type | Description |
|---|---|---|
| `bastionctl` | Formula (CLI) | Finds, tests, and remembers the best EC2 instance to use as an [`sshuttle`](https://github.com/sshuttle/sshuttle) pivot into an AWS VPC. Source: [ricardoleal/bastionctl](https://github.com/ricardoleal/bastionctl) |
| `time-machine-trimmer` | Cask (GUI app) | Trims old Time Machine backups to reclaim disk space. Source: [ricardoleal/TimeMachineTrimmer](https://github.com/ricardoleal/TimeMachineTrimmer) |
| `time-machine-trimmer-dev` | Cask (GUI app, dev build) | Prerelease builds of Time Machine Trimmer. Conflicts with `time-machine-trimmer` (install only one). |

## Usage

Add the tap once, then install anything from it:

```sh
brew tap ricardoleal/tap
brew install bastionctl
brew install --cask time-machine-trimmer
```

Or skip the tap step and install directly (Homebrew taps on demand for fully-qualified names):

```sh
brew install ricardoleal/tap/bastionctl
brew install --cask ricardoleal/tap/time-machine-trimmer
```

For the dev build of Time Machine Trimmer (mutually exclusive with the stable build):

```sh
brew install --cask ricardoleal/tap/time-machine-trimmer-dev
```

### bastionctl notes

`bastionctl` shells out to your system's `sshuttle`, which is installed automatically as a Homebrew dependency. For SSM-brokered targets (private instances with no public IP) you additionally need the AWS Session Manager plugin and an SSH config entry:

```sh
brew install --cask session-manager-plugin
```

```ssh-config
Host i-* mi-*
  ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
```

Then run:

```sh
bastionctl                          # first run: interactive discovery
bastionctl --connection corp        # use/create a named connection
bastionctl --start corp             # start sshuttle in the background
```

See the [bastionctl README](https://github.com/ricardoleal/bastionctl#usage) for full usage, IAM permissions, and options.

Updating everything later:

```sh
brew update
brew upgrade bastionctl
brew upgrade --cask time-machine-trimmer
```

## Should you trust this tap?

Installing software from a third-party tap means running binaries built by someone else. Here's how to evaluate that risk for this tap, and what this tap does to earn trust:

**What Homebrew already verifies for you**

- Every Cask and Formula in this tap pins a **SHA-256 checksum** of the download. If a release artifact is tampered with in transit or replaced upstream, installation fails instead of installing the wrong bits.
- Homebrew downloads over **HTTPS from `github.com` release URLs**, so the download source is authenticated to the upstream repo.

**What you can verify yourself**

1. **Read the definitions before installing.** They are short, plain Ruby — this whole tap is a handful of files:
   - [`Formula/bastionctl.rb`](Formula/bastionctl.rb) — URLs + checksums + install steps for `bastionctl`
   - [`Casks/time-machine-trimmer.rb`](Casks/time-machine-trimmer.rb) — same for the stable app
   - [`Casks/time-machine-trimmer-dev.rb`](Casks/time-machine-trimmer-dev.rb) — same for the dev app
2. **Cross-check the checksums.** Each upstream repo publishes release artifacts; compare the `sha256` values here against the upstream `checksums.txt` or recompute them:
   ```sh
   gh release download v0.1.0 --repo ricardoleal/bastionctl -p checksums.txt -O -
   ```
3. **Check the automation.** Version bumps are done by GitHub Actions workflows in [`.github/workflows/`](.github/workflows/), which fetch the checksum from the upstream release at update time. Workflow runs are public, so any update can be traced back to the upstream release it came from.
4. **Build from source instead.** If you'd rather not trust prebuilt binaries at all, both upstreams are open source with documented builds:
   - `bastionctl`: `go build -o bastionctl .` ([source](https://github.com/ricardoleal/bastionctl#build))
   - TimeMachineTrimmer: Xcode/SwiftPM build ([source](https://github.com/ricardoleal/TimeMachineTrimmer))

**Known limitations**

- The TimeMachineTrimmer app is **not signed with an Apple Developer ID certificate**, so macOS Gatekeeper will block the first launch. Open it via right-click → Open, or allow it under System Settings → Privacy & Security. This is expected and documented in the Cask caveats.
- This tap has no formal security audit or reproducible-build setup. For high-assurance environments, build from source.
