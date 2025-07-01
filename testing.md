In this section, we discuss key elements of planning for, executing, and interpreting the results of a performance or load test by addressing the following points:
* Create a performance evaluation checklist
* Establish clear performance objectives
* Plan the performance evaluation early in the development cycle
* Ensure performance results are representative
* Apply Performance tuning methodology
* Sample: JMeter based test using the HiringSample process application 

# Create a performance evaluation checklist
Performance evaluations take many forms. The following is one common:
* A load test, which is typically done to ensure a given volume of work (for example, a predefined throughput rate or number of concurrent users) can be sustained on a specified topology while meeting a service level agreement (SLA).

Executing performance evaluations requires great care in planning the tests, and obtaining relevant results. Following is a checklist of key attributes to consider, each of which is detailed further in the remainder of this chapter:
* Establish clear performance objectives that are representative of business requirements. For example, 
* Ensure that the scenario measured accurately represents the one described in the objective.
* Perform initial tuning of the environment, for example apply the correct SML size of a CP4BA installation.
* Monitor systems on an on-going basis (for example, processor, memory, disk usage) and adjust tuning accordingly.
* When obtaining measurements, follow the following guidelines:
* Ensure the environment is warmed up before obtaining measurements.
* Preload system to the wanted state (e.g. number of process instances).
* Ensure realistic think times are used between requests. Consider how long does an user work on a single Coach?

# Establish clear performance objectives
Performance objectives should be defined early in a project. These should be developed by interlocking with the business stakeholders to define the key scenarios, and then establishing SLAs for the required performance for each scenario. These SLAs should be clearly stated and measurable. An example of a well-defined response time focused SLA can be:
* Refreshing the Task List in Workplace should take < 2 seconds using Chrome version X with 100 milliseconds of network latency between the Workplace server and the browser.
* Another example of a well-defined throughput focused SLA can be: The system will be able to sustain steady state throughput of 20 process instances completed per second while maintaining response times less than 2 seconds, measured at the 90th percentile.

# Plan the performance evaluation early in the development cycle
After the performance objectives are defined, a performance plan should be written that describes the methodology that will be used to assess the objectives. One of the key elements of this plan will be to describe how to obtain performance data that is representative of the expected production usage. Among the topics to include, consider:
* Define a workload that properly models the business scenarios of interest.
* Provision a topology that is as close to the production topology as possible.
* Define a database population (for example, user and group membership, number of process instances and tasks, both active and complete) that represent the expected steady state of the production environment.
* Choose a performance testing tool that can script the scenarios and apply the necessary load to mimic a production environment. Apache JMeter is one example.
* Design workloads that are reliable, produce repeatable results, are easy to run, and will complete in a reasonable amount of time.

# Ensure performance results are representative
When running the performance test, ensure that the results obtained are representative of the expected production usage. To do this, follow these guidelines:
* Perform initial tuning of the environment
* Deploy IT monitoring tools in key components of the infrastructure
* Plan to run the performance test multiple times, using the IT monitoring tools’ output to guide further tuning. 
* Since this is an iterative process, it is important that the performance test runs in a reasonable amount of time, and cleanup is done after each run.
* Use the following measurement methodology to obtain reliable, repeatable, representative performance data:
    * Ensure that the environment is warmed up before obtaining measurements. This generally requires running several hundred iterations of the test to bring the system to steady state by ensuring that Just In Time compiling Java code, populating caches, and DB buffer pools, are all completed.
    * Ensure realistic think times are used between requests. The think times should match the expected behavior of the users. One way to determine realistic think time is to determine the expected peak throughput rate, and how many concurrent users will be working during that time. 
    * Maintain steady state in the Process Server database, such as a consistent number of active and completed tasks and instances.
    * Clean up at the end of the run, particularly queues and the databases. To ensure that repeatable results are obtained, each measurement run should start with the system in a state consistent with the start of the previous measurement run and matching the preload state defined in your performance plan.
* Check for errors, exceptions, and time outs in logs and reports. These are typically indicative of functional problems or configuration issues, and can also skew performance results. Any sound performance measurement methodology insists upon fixing functional problems before evaluating performance metrics.

# Sample: JMeter based test using the HiringSample process application

<https://community.ibm.com/community/user/automation/blogs/torsten-wilms1/2023/02/17/workflow-process-performance-testing-sample>
