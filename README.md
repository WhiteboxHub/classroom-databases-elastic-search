# Elasticsearch Setup and Usage Guide

## 🚀 Getting Started with Elasticsearch

### 1️⃣ Run Elasticsearch in a Docker Container
```sh
docker run --name elasticsearch_container -d -p 9200:9200 -p 9300:9300 
  -e "discovery.type=single-node" 
  -e "ES_JAVA_OPTS=-Xms512m -Xmx512m"
  -e "xpack.security.enabled=false" 
  docker.elastic.co/elasticsearch/elasticsearch:8.5.1
```


### 2️⃣ Stop and Remove Elasticsearch Container
```sh
docker stop elasticsearch_container
docker rm elasticsearch_container
```

### 3️⃣ Access Elasticsearch UI
Open your browser and go to:

[http://localhost:9200](http://localhost:9200)

If Elasticsearch is running, you should see a JSON response with cluster details.

---

## 📊 Kibana (Optional, for UI-based Queries)
To install and run Kibana, use:
```sh
docker run --name kibana_container -d -p 5601:5601 --link elasticsearch_container:elasticsearch docker.elastic.co/kibana/kibana:8.5.1
```
Then, open:

[http://localhost:5601](http://localhost:5601)

Go to **"Dev Tools"** → Run queries in the **Console**.

---

## 🖥️ Command Line (curl Commands)

### 🔎 Check Elasticsearch Status
```sh
curl -X GET "localhost:9200"
```

### 📋 List All Indices
```sh
curl -X GET "localhost:9200/_cat/indices?v"
```

---

## 🛠️ Developer Tools

### 1️⃣ **VS Code**
- Install the **REST Client** extension.
- Create a `.http` file, e.g., `elasticsearch.http`.
- Add a request:
```http
GET http://localhost:9200/training_programs/_search
Content-Type: application/json
```
- Click **Send Request** to view the response.

### 2️⃣ **Postman**
- Open **Postman**.
- Create the Index
Set method to `Get` .
- URL:
```sh
http://localhost:9200/training_programs
```
Body (JSON):
```sh
{
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 0
    },
    "mappings": {
      "properties": {
        "id": { "type": "integer" },
        "name": { "type": "text" },
        "category": { "type": "keyword" },
        "trainer": { "type": "text" },
        "skills_covered": { "type": "keyword" },
        "duration_weeks": { "type": "integer" },
        "price_usd": { "type": "double" },
        "available_slots": { "type": "integer" },
        "is_online": { "type": "boolean" },
        "start_date": { "type": "date", "format": "yyyy-MM-dd" },
        "end_date": { "type": "date", "format": "yyyy-MM-dd" },
        "rating": { "type": "double" },
        "max_students": { "type": "integer" },
        "description": { "type": "text" }
      }
    }
  }
  ```
- Verify Index Creation
Set method to `GET`.
- Enter the URL:
```sh
URL: http://localhost:9200/_cat/indices?v
```
Set method to `POST`
- Enter the URL:
```sh
URL: http://localhost:9200/training_programs/_doc/1
```
Body (JSON)
```sh
{
  "id": 1,
  "name": "Deep Learning with TensorFlow",
  "category": "Machine Learning",
  "trainer": "Dr. John Smith",
  "skills_covered": ["Neural Networks", "CNN", "RNN", "TensorFlow"],
  "duration_weeks": 6,
  "price_usd": 499.99,
  "available_slots": 20,
  "is_online": true,
  "start_date": "2025-02-01",
  "end_date": "2025-03-15",
  "rating": 4.8,
  "max_students": 30,
  "description": "An advanced deep learning course covering CNNs, RNNs, and TensorFlow."
}
```

- Create a new request → Set method to `GET`.
- Enter the URL:
```sh
http://localhost:9200/training_programs/_search
```
- Click **Send** to retrieve data.

For advanced queries, use the **Body (JSON)** tab:
```json
{
  "query": {
    "match": { "category": "Machine Learning" }
  }
}
```

---

## 🔍 Query Examples

### 1️⃣ Get All Training Programs
```sh
curl -X GET "localhost:9200/training_programs/_search?pretty"
```

### 2️⃣ Get a Specific Document (By ID)
```sh
curl -X GET "localhost:9200/training_programs/_doc/1"
```

### 3️⃣ Find Online Training Programs
```sh
curl -X GET "localhost:9200/training_programs/_search" -H "Content-Type: application/json" -d '
{
  "query": {
    "term": { "is_online": true }
  }
}'
```

### 4️⃣ Find Programs on "Machine Learning"
```sh
curl -X GET "localhost:9200/training_programs/_search" -H "Content-Type: application/json" -d '
{
  "query": {
    "match": { "category": "Machine Learning" }
  }
}'
```

### 5️⃣ Find Training Programs Cheaper Than $500
```sh
curl -X GET "localhost:9200/training_programs/_search" -H "Content-Type: application/json" -d '
{
  "query": {
    "range": {
      "price_usd": {
        "lt": 500
      }
    }
  }
}'
```

### 6️⃣ Find Programs Covering "Kafka"
```sh
curl -X GET "localhost:9200/training_programs/_search" -H "Content-Type: application/json" -d '
{
  "query": {
    "terms": { "skills_covered": ["Kafka"] }
  }
}'
```

### 7️⃣ Sort Training Programs by Rating (Descending)
```sh
curl -X GET "localhost:9200/training_programs/_search" -H "Content-Type: application/json" -d '
{
  "sort": [
    { "rating": { "order": "desc" } }
  ]
}'
```

### 8️⃣ Paginate Results (Limit to 2 per Page)
```sh
curl -X GET "localhost:9200/training_programs/_search" -H "Content-Type: application/json" -d '
{
  "from": 0,
  "size": 2,
  "query": { "match_all": {} }
}'
```

---

## 📥 Insert Data

### ➕ Insert a Single Document
```sh
curl -X POST "localhost:9200/training_programs/_doc/1" -H "Content-Type: application/json" -d '
{
  "id": 1,
  "name": "Deep Learning with TensorFlow",
  "category": "Machine Learning",
  "trainer": "Dr. John Smith",
  "skills_covered": ["Neural Networks", "CNN", "RNN", "TensorFlow"],
  "duration_weeks": 6,
  "price_usd": 499.99,
  "available_slots": 20,
  "is_online": true,
  "start_date": "2025-02-01",
  "end_date": "2025-03-15",
  "rating": 4.8,
  "max_students": 30,
  "description": "An advanced deep learning course covering CNNs, RNNs, and TensorFlow."
}'
```

---

## ✏️ Update Data

### 🔄 Update a Training Program (Change Price)
```sh
curl -X POST "localhost:9200/training_programs/_update/1" -H "Content-Type: application/json" -d '
{
  "doc": {
    "price_usd": 599.99
  }
}'
```

### 📌 Update Multiple Fields (e.g., Slots and Duration)
```sh
curl -X POST "localhost:9200/training_programs/_update/1" -H "Content-Type: application/json" -d '
{
  "doc": {
    "available_slots": 15,
    "duration_weeks": 8
  }
}'
```

### 📈 Update Prices by 10% for Machine Learning Courses
```sh
curl -X POST "localhost:9200/training_programs/_update_by_query" -H "Content-Type: application/json" -d '
{
  "query": {
    "match": { "category": "Machine Learning" }
  },
  "script": {
    "source": "ctx._source.price_usd *= 1.1"
  }
}'
```

---

## 🗑️ Delete Data

### ❌ Delete a Specific Document (By ID)
```sh
curl -X DELETE "localhost:9200/training_programs/_doc/1"
```

### 🗑️ Delete All Documents in an Index
```sh
curl -X DELETE "localhost:9200/training_programs"
```

### 🔢 Count the Number of Documents
```sh
curl -X GET "localhost:9200/training_programs/_count"
```

---

## License
This project is licensed under the MIT License.

## Contributors
- Whitebox Learning
