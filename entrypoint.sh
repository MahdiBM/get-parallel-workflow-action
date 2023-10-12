apt-get update -y
apt-get install jq curl -y
echo "run_id=$(
  curl -sL \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: BEARER ${{ inputs.token }}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://api.github.com/repos/${{ inputs.repository }}/actions/runs | \
  jq '.workflow_runs' | \
  jq 'map(select(.head_sha == "${{ github.event.head_commit.id }}" or .head_sha == "${{ github.event.pull_request.head.sha }}"))' | \
  jq 'map(select(.name == "${{ inputs.name }}"))' | \
  jq '.[0].id'
)" >> $GITHUB_OUTPUT
