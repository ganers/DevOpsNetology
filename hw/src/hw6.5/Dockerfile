# Манифест Docker образа.
FROM centos:7

RUN yum install wget -y --nogpgcheck; \
    wget http://mirror.centos.org/centos/7/os/x86_64/Packages/perl-Digest-SHA-5.85-4.el7.x86_64.rpm; \
    yum install perl-Digest-SHA-5.85-4.el7.x86_64.rpm -y --nogpgcheck; \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-linux-x86_64.tar.gz; \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512; \
    shasum -a 512 -c elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512; \
    tar -xzf elasticsearch-7.15.2-linux-x86_64.tar.gz; \
    useradd elastic -p elastic; \
    usermod -aG wheel elastic; \
    chown -R elastic:elastic elasticsearch-7.15.2/; \
    chown -R elastic:elastic /var/lib;

RUN echo 'node.name: netology_test' >> /elasticsearch-7.15.2/config/elasticsearch.yml;
RUN echo 'path.data: /var/lib' >> /elasticsearch-7.15.2/config/elasticsearch.yml;
RUN echo 'network.host: 0.0.0.0' >> /elasticsearch-7.15.2/config/elasticsearch.yml;
RUN echo 'discovery.seed_hosts: ["0.0.0.0"]' >> /elasticsearch-7.15.2/config/elasticsearch.yml;
RUN echo 'discovery.type: single-node' >> /elasticsearch-7.15.2/config/elasticsearch.yml;

USER elastic

EXPOSE 9200
EXPOSE 9300

CMD ["/elasticsearch-7.15.2/bin/elasticsearch"]