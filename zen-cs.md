This chapter discusses scaling and tuning options of Zen and Common Services components used with Workflow.

# Modifying Zen and Common Service deployment size

It is recommended that you set the IBM Cloud Platform UI (Zen) service to the same size as Cloud Pak for Business Automation (specified with sc_deployment_profile_size). The possible values are small, medium, and large.

### For scaling Zen apply:
`oc edit ZenService`

Modify `spec.scaleConfig` parameter to `small` or `medium` or `large`

### For scaling CommonServices apply:
`oc edit CommonServices`

Modify `spec.size` parameter to `small` or `medium` or `large`

# Tuning the frontend layer

### Scale ngnix horizontally

Ngnix `worker_connections` are limited to 1024. This can slow down response times or cause timeouts on client side.
`worker_connections` cannot be modified, but ngnix can be scaled to increase the total number of worker_connections:

`oc scale deployment ibm-nginx --replicas=[number of replicas]`
