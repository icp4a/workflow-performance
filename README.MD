**_Disclaimer: This publication reflects and summarizes best practises and performance tuning and monitoring methods and is not an official IBM documentation_**

This publication provides performance tuning tips and best practices for IBM CloudPak for Automation / Business Automation Workflow and Workflow Process Service. 
These products are deployed on Kubernetes and OCP and are build on the core capabilities of IBM liberty, Java and database technologies. As a result, IBM Workflow solutions benefit from tuning, configuration, and best practices information for Kubernetes, OCP, Liberty and JVMs.

This publication talks about many issues that can influence performance of each product and can serve as a guide for making rational first choices in terms of configuration and performance settings. Similarly, customers who already implemented a solution with these products can use the information presented here to gain insight into how their overall integrated solution performance can be improved.

This current chapter presents the scope of the content of this page:

## [Top design and deployment guidelines](architecture.md)
This chapter provides guidance for architecture, topology and design decisions that produce well-performing and scalable Workflow solutions.
## [Workflow container tuning and configuration](container.md)
This chapter explains how to vertically and horizontally scale workflow containers and how to modify the configuration of a workflow container.
## [Zen and Common Services tuning and configuration](zen-cs.md)
This chapter discusses scaling and tuning options of Zen and Common Services components used with Workflow.
## [Openshift tuning and configuration](openshift.md)
This chapter explains the tuning and configuration parameters and settings to optimize OpenShift.
## [Database configuration, tuning, and best practices](database.md)
This chapter explains the tuning methodology and configuration considerations to optimize the databases that Workflow uses.
## [IT monitoring using Instana, Healthcenter and Prometheus](monitoring.md)
This chapter discusses the methodology used for IT monitoring to obtain the relevant metrics to tune a production environment, and to conduct a performance or load test. For the latter topic, IT monitoring, tuning, and performance/load testing are all intrinsically linked, so the topics are interwoven accordingly.
## [Performance Testing](testing.md)
This chapter explains performance testing approaches and samples.
## [Related publications](references.md)
This chapter links relevant references.
