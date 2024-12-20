This chapter describes how the containers in the workflow namespaces can be configured and tuned.


### Set the deployment profile size

#### CP4BA pods
You can select a deployment profile (sc_deployment_profile_size) and enable it during or after the installation. IBM Cloud Pak® for Business Automation provides small, medium, and large deployment profiles. For more information about deployment profiles refer to https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/24.0.1?topic=pcmppd-system-requirements. This affects the cpu, memory resources and/or the amount of replicas of Workflow pods:

Edit the ICP4ACluster object:
`oc edit ICP4ACluster -o yaml`

Locate the `shared_configuration.sc_deployment_profile_size` property and set it to `small`, `medium` or `large`

In addition you might want to set the deployment size of Common Services and Zen.

#### Common Services pods
For Common Services edit the CommonServices object:
`oc edit CommonServices -o yaml`

Locate the `spec.size` property and set it to `small`, `medium` or `large`

#### Zen pods
For Zen edit the CommonServices object:
`oc edit ZenService -o yaml`

Locate the `spec.scaleConfig` property and set it to `small`, `medium` or `large`


### Adapt number of replicas for containers 
Besides adjusting the deployment profile size, you can override the number of replicas for Workflow pods manually by editing the ICP4ACluster object:
`oc edit ICP4ACluster -o yaml`

Locate the `baw_configuration.replicas` property and set it to the number of replicas you want to scale to.

#### WfPS pods
Since there is no concept of deployment profile size (S/M/L) for WfPS, pod replicas need to be scaled manually. This can be achieved by setting a positive integer as value for `spec.node.replicas` in the WfPS custom resource (Type: WfPSRuntime).

### Adapt resources for containers 
You can increase or decrease the cpu and memory resource requests and limits.
In general, we do not recommend to set the CPU limit too low, since kubernetes CPU throttling can start early.

Edit the ICP4ACluster object:
`oc edit ICP4ACluster -o yaml`

Locate the `baw_configuration.resources` property and set its limit and request properties according your needs. 

### Modify the JVM configuration
The jvm heap size should not modified using JVM properties, instead use the memory request and limit settings to increase the jvm heap size, since the jvm is using the container aware setting.

For other JVM properties edit the ICP4ACluster object:
`oc edit ICP4ACluster icp4adeploy`

Find the baw_configuration.jvm_customize_options section. If it doesn't exist, create it. Add your options like the following example:
`jvm_customize_options: |-
-Xhealthcenter`

Wait for the change to propagate to the config map


### Tune database connection pool

Increase the number of connections in the connection pool to greater than or equal to the sum of the maximum amount of threads used. Read the chapter [Monitoring](monitoring.md) how to monitor pod resource usage. The default size is 200 connections.

Edit the ICP4ACluster object:
`oc edit ICP4ACluster -o yaml`

Find the baw_configuration.database.cm_max_pool_size option. If it doesn't exist, create it. Add your connection pool value:
`baw_configuration.database.cm_max_pool_size: <number_of_connections>`

For WfPS, edit the WfPSRuntime resource and add the connection pool size value here:
`spec.database.client.maxConnectionPoolSize`

### Modify Workflow Caches
Several cache settings that might benefit from larger values. An overview about caches can be found at https://www.ibm.com/docs/en/baw/24.x?topic=data-cache-cache-related-settings. Refer also to the Cache monitoring section at https://www.ibm.com/docs/en/baw/24.x?topic=data-using-process-instrumentation-cache-tuning.

Most of the caches can be modified by editing the custom_xml file:
https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/24.0.1?topic=customizing-business-automation-workflow-properties

### Reduce or disable User-Group-Syncs

Set the user-group-membership-sync-cache-expiration to -1 to disable User Group Sync. This will reduce lock wait times on LSW_LOCK


```
<properties>
   <common merge="mergeChildren">
     <security merge="mergeChildren">
       <user-group-membership-sync-cache-expiration merge="replace">-1</user-group-membership-sync-cache-expiration>
     </security>
   </common>
</properties>
```
Edit the cluster object `oc edit ICP4ACluster`

Modify the bastudio_configuration.bastudio_custom_xml object:
```
bastudio_configuration:
  bastudio_custom_xml: |
      <properties>
       <common merge="mergeChildren">
         <security merge="mergeChildren">
          <user-group-membership-sync-cache-expiration merge="replace">-1</user-group-membership-sync-cache-expiration>
         </security>
       </common>
      </properties>
```

### Tune for High Workloads above Large pattern size

For very large workloads exceeding "Large" tuning is required. This tuning depends on indiviual workloads. For 7000 concurrent users (20s thinktime) and a throughput of 30+ human processes per second / 120 human tasks per second we applied the following tuning steps for Workflow Process Service. This is a sample:

#### WFPS resource

* spec.database.managed.managementState=Unmanaged
* spec.node.replicas=8
* spec.node.resources.limits.cpu=6
* spec.node.resources.limits.memory=4Gi
* database.client.maxConnectionPoolSize=400
 
#### Cluster resource (Postgres DB)

* spec.postgresql.parameters.max_connections=1000
* spec.postgresql.parameters.max_prepared_transactions=1000
* spec.resources.limits.cpu=32
* spec.resources.limits.memory=32Gi

#### Postgres DB filesystem
Make sure the postgres filesystem resides on fast disks.

#### Zen usermanagement pods
Increate number of zen usermanagement pods.

`oc scale deployment usermgmt --replicas=12`


#### Disabling Notifications (optional)

Reduces JMS load and CPU usage on wfps-pod-0.

Edit ConfigMap wfpsruntime-sample-liberty-dynamic-config:

lombardi-empty.xml:
```
<properties>

  <server merge="mergeChildren">

     <web-messaging-push merge="replace" match="elementName" enabled="false">

        <web-messaging type="NOTIFY_TASK_RESOURCE_ASSIGNED" enabled="false"/>

        <web-messaging type="NOTIFY_TASK_COLLABORATION_INVITE" enabled="false"/>

        <web-messaging type="NOTIFY_PROCESS_COMMENT_TAGGED" enabled="false"/>

        <web-messaging type="TASKLIST_TASK_RESOURCE_ASSIGNED" enabled="false"/>

        <web-messaging type="TASKLIST_TASK_FIELD_CHANGED" enabled="false"/>

    </web-messaging-push>

  </server>

</properties>
```

#### Modifying GroupSync interval or diabling GroupSync

Reduce number of SCIM calls that might respond slow under very high load and causing long end user response times.

Edit ConfigMap wfpsruntime-sample-liberty-dynamic-config to disable GroupSync:

lombardi-empty.xml:
```
<properties>

        <common>

            <security>

               <user-group-membership-sync-cache-expiration merge="replace">-1</user-group-membership-sync-cache-expiration>

            </security>

        </common>

</properties>
```

#### Tune IAM

Eliminate SCIM response time peaks

Increase all caches and TTLs by factor 10:

Edit ConfigMap ibm-iam-bindinfo-platform-auth-idp
Edit ConfigMap platform-auth-idp

#### Tune Zen

Reduce response time peaks:

Scale Zen-audit to 8 replicas

#### Increase coreThreads (depends on CP4BA version)

Edit configmap wfpsruntime-sample-liberty-dynamic-config:
```
<server>
  <executor coreThreads="100" />
</server>
```
