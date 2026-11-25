#!/usr/bin/env bash
set -euo pipefail

# Exercise the public pack name and inheritance without touching installed packs.
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
export XDG_CONFIG_HOME="$scratch"
store="$scratch/nono/packages/osmman/atlassian-mcp"
mkdir -p "$store/profiles"
cp atlassian-mcp/package.json "$store/"
artifact=$(jq -er '.artifacts[] | select(.type == "profile" and .install_as == "atlassian-mcp") | .path' "$store/package.json")
policy="atlassian-mcp/$artifact"
nono profile validate --strict "$policy"
jq -e --slurpfile manifest "$store/package.json" '.meta.version == $manifest[0].version' "$policy" >/dev/null
cp "$policy" "$store/profiles/atlassian-mcp.json"

cat > "$scratch/client.json" <<'JSON'
{
  "extends": ["default", "osmman/atlassian-mcp"],
  "network": { "open_port": [3118] }
}
JSON
nono profile show "$scratch/client.json" --json | jq -e '
  .open_urls.allow_origins == ["https://auth.atlassian.com"] and
  .open_urls.allow_localhost and .network.open_port == [3118]
' >/dev/null
