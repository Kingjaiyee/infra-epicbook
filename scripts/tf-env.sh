# shellcheck shell=bash
# Sourced inside AzureCLI@2 steps that set addSpnToEnvironment: true.
# Turns the service connection's federated token into Terraform's ARM_ variables.
# No client secret exists anywhere: this is workload identity federation.
set -euo pipefail

ARM_SUBSCRIPTION_ID="$(az account show --query id -o tsv)"

# Register the IDs as secrets so the agent masks them in every later log line
echo "##vso[task.setvariable variable=maskSubscriptionId;issecret=true]${ARM_SUBSCRIPTION_ID}"
echo "##vso[task.setvariable variable=maskTenantId;issecret=true]${tenantId}"

export ARM_SUBSCRIPTION_ID
export ARM_CLIENT_ID="${servicePrincipalId}"
export ARM_TENANT_ID="${tenantId}"
export ARM_OIDC_TOKEN="${idToken}"
export ARM_USE_OIDC=true
export TF_IN_AUTOMATION=true
