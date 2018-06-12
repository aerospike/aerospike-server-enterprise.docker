#
# Aerospike Server Enterprise Edition Dockerfile
#
# http://github.com/aerospike/aerospike-server-enterprise.docker
#

FROM ubuntu:16.04

# Add Aerospike package
ADD aerospike-server.deb /tmp/aerospike-server.deb
ADD aerospike-tools.deb /tmp/aerospike-tools.deb

# Work from /tmp
WORKDIR /tmp

# Install Aerospike
RUN \
  apt-get update -y \
  && apt-get install -y wget python python-argparse python-bcrypt python-openssl logrotate net-tools iproute2 iputils-ping gettext-base\
  && dpkg -i aerospike-server.deb \
  && dpkg -i aerospike-tools.deb 


RUN \
   apt-get install ldap-utils -y 

# Add the Aerospike configuration specific to this dockerfile
COPY aerospike.template.conf /etc/aerospike/aerospike.template.conf
COPY entrypoint.sh /entrypoint.sh

# Mount the Aerospike data directory
VOLUME ["/opt/aerospike/data"]

# Expose Aerospike ports
#
#   3000 – service port, for client connections
#   3001 – fabric port, for cluster communication
#   3002 – mesh port, for cluster heartbeat
#   3003 – info port
#
EXPOSE 3000 3001 3002 3003 9918

# Execute the run script
# We use the `ENTRYPOINT` because it allows us to forward additional
# arguments to `aerospike`
# Execute the run script in foreground mode
ENTRYPOINT ["/entrypoint.sh"]
CMD ["asd"]
