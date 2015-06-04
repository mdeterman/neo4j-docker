FROM switchback/debian

RUN wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - && \
	echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list && \
	apt-get update ; apt-get install neo4j -y && \
	rm -rf /var/lib/apt/lists/*

# set shell host of docker
RUN  sed -i "s|#node_auto_indexing|node_auto_indexing|g" /var/lib/neo4j/conf/neo4j.properties && \
    sed -i "s|#node_keys_indexable|node_keys_indexable|g" /var/lib/neo4j/conf/neo4j.properties && \ 
    echo "remote_shell_host=0.0.0.0" >> /var/lib/neo4j/conf/neo4j.properties && \
	 sed -i "s|#org.neo4j.server.webserver.address=0.0.0.0|org.neo4j.server.webserver.address=0.0.0.0|g" /var/lib/neo4j/conf/neo4j-server.properties && \
	 sed -i "s|org.neo4j.server.database.location=data/graph.db|org.neo4j.server.database.location=/var/data/graph.db|g" /var/lib/neo4j/conf/neo4j-server.properties

VOLUME /var/data

expose 7474
expose 1337

ENTRYPOINT ["/var/lib/neo4j/bin/neo4j", "console"]