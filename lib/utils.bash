#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/cargo-bins/cargo-binstall"
TOOL_NAME="cargo-binstall"
TOOL_TEST="cargo-binstall -V"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if cargo-binstall is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

# version 0.x.y are ignored, because 0.1.0 is wrongly released and generates trouble with asdf >= 0.16
list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o -E 'refs/tags/v[1-9][0-9]*\.[[:digit:]]+\.[[:digit:]]+' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	local platform

	case "$OSTYPE" in
	darwin*) platform="apple-darwin" ;;
	linux*) platform="unknown-linux-musl" ;;
	*) fail "Unsupported platform" ;;
	esac

	local architecture

	case "$(uname -m)" in
	x86_64*) architecture="x86_64" ;;
	# They are releasing aarch64 binary since 0.36.7: https://github.com/sagiegurari/cargo-make/commit/ab3cac2261c0ba67ab6d7a277aff8252faec0b1c
	aarch64 | arm64) architecture="aarch64" ;;
	*) fail "Unsupported architecture" ;;
	esac

	local archive_format
	case "$OSTYPE" in
	darwin*) archive_format="zip" ;;
	linux*) archive_format="tgz" ;;
	*) fail "Unsupported platform" ;;
	esac

	# url="$GH_REPO/archive/v${version}.tar.gz"
	local url="$GH_REPO/releases/download/v${version}/cargo-binstall-${architecture}-${platform}.${archive_format}"

	echo "* Downloading $TOOL_NAME release $version..."
	echo "  url: $url"
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp "$ASDF_DOWNLOAD_PATH"/cargo-binstall "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
