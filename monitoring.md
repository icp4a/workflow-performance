For monitoring the performance of a containerized Workflow system there a several tools and approaches available. 
Several sources of information are highly valuable, even necessary, when diagnosing and resolving performance problems. This information is often referred to as must-gather information. It includes the following items:
* Hardware ressource utilization
   * Client (the users workstation) processor utilization and memory use
   * CP4BA container processor utilization, memory use and network utilization
   * Database server processor, disk subsystem, memory use and network utilization
* Characterization of the network latency between key components of the system
    * From client to server
    * From server to database
* Workflow pod
   * The verbosegc logs (even if this problem is not a memory problem)
   * SystemOut and SystemErr logs
   * For a hang or unusually slow response time:
      * A series of javacore files (3 - 5 dumps, separated by 30 seconds or a few minutes).
   *  For memory failures (OutOfMemory):
      * heapdump data (phd) from the time of the memory failure
      * javacore from the time of the memory failure
    * For a suspected memory leak:
      * A series of heapdump files (PHD files) taken at different times before the out-of-memory exception.
* For database performance issues: Refer to the chapter [Database](database.md)

In general we recommend to have a professional monitoring solution installed, like IBM Instana. With that, you usually can quickly identify and drill down into bottlenecks.

# Using Instana in the context of CP4BA
in progress

# Using IBM Health Center in the context of CP4BA
The IBM Java runtime ships with an integrated diagnostic tool for monitoring the status of a running JVM: Health Center.
This article shows how to leverage this tool for monitoring components of CP4BA, in this case Business Automation Workflow (BAW) running on Redhat OpenShift:
https://community.ibm.com/community/user/automation/blogs/florian-leybold1/2021/12/28/using-health-center-for-monitoring-business-automa
