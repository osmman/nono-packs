# nono-packs

Community [nono](https://nono.sh/) sandbox profiles. Each directory
is an independently versioned registry pack.

| Pack | Purpose |
| --- | --- |
| [`osmman/atlassian-mcp`](atlassian-mcp/) | Connect an MCP client to Atlassian Rovo without giving it reusable OAuth tokens. |

## Releasing `atlassian-mcp`

1. In the [registry](https://registry.nono.sh/publish), create `osmman/atlassian-mcp`
   with source `osmman/nono-packs` and subpath `atlassian-mcp`. With registry
   2FA enabled, register the trusted publisher for that repository, workflow
   `.github/workflows/publish-atlassian-mcp.yml`, and ref `refs/tags/atlassian-mcp-v*`.
2. Run `bash tests/atlassian-mcp.sh` from the repository root and complete the
   [manual OAuth check](#manual-oauth-check).
3. Set the release version in `atlassian-mcp/package.json` and `policy.json`.
   Commit the tested files and push the matching tag (e.g. `atlassian-mcp-v0.1.0`).
   The workflow signs and publishes that pack using GitHub OIDC.
4. On a clean install, run `nono pull osmman/atlassian-mcp` and repeat the
   client check using the published profile.

### Manual OAuth check

Use a fresh test account. Follow the [pack quick start](atlassian-mcp/README.md#quick-start)
against the candidate pack. Before its first publication, use the local
`atlassian-mcp/policy.json` as `--profile` and the installed client pack as
`--extends`, keeping the same client flags.

1. With no saved Atlassian login, authenticate inside the sandbox and read a
   known Jira issue or Confluence page.
2. Confirm both stored tokens are placeholders without printing their values.
3. Restart the client. After access-token expiry, repeat the read and confirm
   that `/oauth/token` refreshes the session without another login.
4. Against a controlled test origin outside `auth.atlassian.com` and
   `mcp.atlassian.com`, confirm the proxy denies the request or sends no
   Atlassian credential. Record the outcome, not header or token values.

See nono's [OAuth capture QA guide](https://nono.sh/docs/cli/development/oauth-capture-manual-qa)
for the expected events.
