# Atlassian Rovo MCP for nono

Connect a sandboxed MCP client to [Atlassian Rovo MCP](https://developer.atlassian.com/cloud/rovo-mcp/guides/configuring-oauth-2-1/).
nono keeps the OAuth access and refresh tokens on the host; the client receives
placeholders that work only through nono's Atlassian routes.

## Quick start

Requires nono 0.82.0 or later and an MCP client that supports remote
HTTP servers and interactive OAuth.

```sh
nono pull osmman/atlassian-mcp
```

Use `--extends osmman/atlassian-mcp` when launching your client with nono.

### Claude Code example

From your project directory:

```sh
nono pull nolabs-ai/claude
claude mcp add --transport http atlassian https://mcp.atlassian.com/v2/mcp
nono run --profile nolabs-ai/claude --extends osmman/atlassian-mcp \
  --open-port 3118 --allow-cwd -- claude
```

Open `/mcp` and sign in to `atlassian`. Claude Code uses port `3118` for the OAuth callback.

### OpenCode example

For OpenCode 2.1+, register the server from your project directory and start a
private OpenCode server inside the sandbox:

```sh
nono pull nolabs-ai/opencode
opencode mcp add atlassian --url https://mcp.atlassian.com/v2/mcp
nono run --profile nolabs-ai/opencode --extends osmman/atlassian-mcp \
  --allow-cwd -- opencode --standalone
```

Open `/mcps`, select `atlassian`, and sign in. If you already use a nono profile
that grants OpenCode its ephemeral loopback ports, pass that profile to
`--profile` and keep the same `--extends`.

## What access it adds

- `auth.atlassian.com` for OAuth discovery, token exchange, and refresh.
- `mcp.atlassian.com` for MCP calls. Jira and Confluence actions use the permissions
  you consent to in Atlassian; the pack does not enforce read-only access.
- Browser opens to the Atlassian auth origin and localhost for sign-in. Filesystem
  access and callback listeners remain the responsibility of the client profile.
