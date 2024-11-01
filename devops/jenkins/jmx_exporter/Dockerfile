FROM jenkins/jenkins:2.415

ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.19.0/jmx_prometheus_javaagent-0.19.0.jar /opt/jmx_exporter/jmx_prometheus_javaagent-0.19.0.jar

USER root

RUN ln -svf /opt/jmx_exporter/jmx_prometheus_javaagent-0.19.0.jar /opt/jmx_exporter/jmx_exporter.jar

USER jenkins
