#
# Aerospike Server Enterprise Edition Dockerfile
#
# http://github.com/aerospike/aerospike-server-enterprise.docker
#

FROM ubuntu:14.04

# Add Aerospike package
ADD aerospike-server.deb /tmp/aerospike-server.deb

# Add the Aerospike run script
ADD aerospike.sh /usr/bin/aerospike

# Work from /tmp
WORKDIR /tmp

# Install Aerospike
RUN \
  chmod +x /usr/bin/aerospike \
  && dpkg -i aerospike-server.deb

# Add the Aerospike configuration
ADD aerospike.conf /etc/aerospike/aerospike.conf

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
ENTRYPOINT ["/usr/bin/aerospike"]
