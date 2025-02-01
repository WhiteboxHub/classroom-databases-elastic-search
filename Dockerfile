FROM docker.elastic.co/elasticsearch/elasticsearch:8.5.1

# Set environment variables
ENV discovery.type=single-node
ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"

# Expose Elasticsearch port
EXPOSE 9200 9300
