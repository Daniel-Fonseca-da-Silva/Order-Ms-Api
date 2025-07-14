# 🛒 OrderMS - Order Management Microservice

[![Java](https://img.shields.io/badge/Java-24-orange.svg)](https://openjdk.org/projects/jdk/24/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.3-green.svg)](https://spring.io/projects/spring-boot)
[![MongoDB](https://img.shields.io/badge/MongoDB-6.0+-blue.svg)](https://www.mongodb.com/)
[![RabbitMQ](https://img.shields.io/badge/RabbitMQ-3.13+-yellow.svg)](https://www.rabbitmq.com/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## 📋 Table of Contents

- [About the Project](#-about-the-project)
- [Architecture](#-architecture)
- [Technologies](#-technologies)
- [Prerequisites](#-prerequisites)
- [Installation and Setup](#-installation-and-setup)
- [Running the Project](#-running-the-project)
- [API Documentation](#-api-documentation)
- [Project Structure](#-project-structure)
- [Development](#-development)
- [Contributing](#-contributing)
- [License](#-license)

## 🎯 About the Project

**OrderMS** is a microservice responsible for order management in a distributed architecture. It consumes order creation events via RabbitMQ, stores data in MongoDB, and exposes REST APIs for querying orders by customer.

### Main Features

- ✅ **Event Consumption**: Processes order creation events via RabbitMQ
- ✅ **Data Storage**: Persists orders in MongoDB with optimized structure
- ✅ **Order Query**: REST API to list orders by customer
- ✅ **Total Calculation**: Aggregation of total values by customer
- ✅ **Pagination**: Pagination support in queries
- ✅ **Indexing**: Optimized indexes for performance

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   RabbitMQ      │    │   OrderMS       │    │   MongoDB       │
│                 │    │                 │    │                 │
│ Order Created   │───▶│ Event Listener  │───▶│ Orders          │
│ Events          │    │                 │    │ Collection      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                              │
                              ▼
                       ┌─────────────────┐
                       │   REST API      │
                       │                 │
                       │ GET /customers/ │
                       │ {id}/orders     │
                       └─────────────────┘
```

### Architectural Patterns

- **Event-Driven Architecture**: Event consumption via RabbitMQ
- **Layered Architecture**: Controller → Service → Repository
- **Repository Pattern**: Data access abstraction
- **DTO Pattern**: Separation between entities and transfer objects

## 🛠️ Technologies

### Backend
- **Java 24**: Programming language
- **Spring Boot 3.5.3**: Java application framework
- **Spring Data MongoDB**: MongoDB integration
- **Spring AMQP**: RabbitMQ integration
- **Lombok**: Boilerplate code reduction

### Database
- **MongoDB 6.0+**: NoSQL database
- **MongoDB Compass**: Graphical interface (optional)

### Message Broker
- **RabbitMQ 3.13+**: Message broker for events

### Development Tools
- **Maven**: Dependency manager
- **Docker & Docker Compose**: Containerization
- **Git**: Version control

## 📋 Prerequisites

Before running the project, make sure you have installed:

- **Java 24** or higher
- **Maven 3.8+**
- **Docker** and **Docker Compose**
- **Git**

### Checking Installations

```bash
# Check Java
java -version

# Check Maven
mvn -version

# Check Docker
docker --version
docker-compose --version

# Check Git
git --version
```

## 🚀 Installation and Setup

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/orderms.git
cd orderms
```

### 2. Environment Setup

The project uses Docker Compose to manage external dependencies. Run:

```bash
# Start MongoDB and RabbitMQ
docker-compose -f local/docker-compose.yml up -d
```

### 3. Environment Variables Configuration

Create a `.env` file in the project root (optional):

```env
# MongoDB Configuration
MONGODB_HOST=localhost
MONGODB_PORT=27017
MONGODB_DATABASE=ordermsdb
MONGODB_USERNAME=admin
MONGODB_PASSWORD=123

# RabbitMQ Configuration
RABBITMQ_HOST=localhost
RABBITMQ_PORT=5672
RABBITMQ_USERNAME=guest
RABBITMQ_PASSWORD=guest
```

## ▶️ Running the Project

### Local Development

```bash
# Compile the project
mvn clean compile

# Run the application
mvn spring-boot:run
```

### With Docker

```bash
# Build image
docker build -t orderms .

# Run container
docker run -p 8080:8080 orderms
```

### Verifying if it's Working

After starting the application, you can verify if it's working:

```bash
# Test the API endpoint
curl http://localhost:8080/customers/1/orders
```

## 📚 API Documentation

### Available Endpoints

#### GET /customers/{customerId}/orders

Lists orders for a specific customer with pagination.

**Parameters:**
- `customerId` (path): Customer ID
- `page` (query, optional): Page number (default: 0)
- `pageSize` (query, optional): Page size (default: 10)

**Request Example:**
```bash
curl -X GET "http://localhost:8080/customers/123/orders?page=0&pageSize=5"
```

**Response Example:**
```json
{
  "summary": {
    "totalOnOrders": 1500.00
  },
  "data": [
    {
      "orderId": 1001,
      "customerId": 123,
      "total": 299.99
    },
    {
      "orderId": 1002,
      "customerId": 123,
      "total": 150.50
    }
  ],
  "pagination": {
    "page": 0,
    "pageSize": 5,
    "totalElements": 25,
    "totalPages": 5
  }
}
```

### Consumed Events

The service consumes events from the `orderms-order-created` queue in RabbitMQ.

**Event Structure:**
```json
{
  "codeOrder": 1001,
  "codeClient": 123,
  "itens": [
    {
      "product": "Smartphone XYZ",
      "quantity": 1,
      "price": 299.99
    }
  ]
}
```

## 📁 Project Structure

```
orderms/
├── src/
│   ├── main/
│   │   ├── java/dafon/dev/orderms/
│   │   │   ├── config/                 # Configurations
│   │   │   │   └── RabbitMqConfig.java
│   │   │   ├── controller/             # REST Controllers
│   │   │   │   ├── dto/               # Response DTOs
│   │   │   │   │   ├── ApiResponse.java
│   │   │   │   │   ├── OrderResponse.java
│   │   │   │   │   └── PaginationResponse.java
│   │   │   │   └── OrderController.java
│   │   │   ├── entity/                 # JPA Entities
│   │   │   │   ├── OrderEntity.java
│   │   │   │   └── OrderItem.java
│   │   │   ├── listener/               # Event Listeners
│   │   │   │   ├── dto/               # Event DTOs
│   │   │   │   │   ├── OrderCreatedEvent.java
│   │   │   │   │   └── OrderItemEvent.java
│   │   │   │   └── OrderCreatedListener.java
│   │   │   ├── repository/             # Repositories
│   │   │   │   └── OrderRepository.java
│   │   │   ├── service/                # Business Services
│   │   │   │   └── OrderService.java
│   │   │   └── OrdermsApplication.java # Main class
│   │   └── resources/
│   │       └── application.properties  # Configurations
│   └── test/
│       └── java/dafon/dev/orderms/
│           └── OrdermsApplicationTests.java
├── local/
│   └── docker-compose.yml              # Local infrastructure
├── pom.xml                             # Maven dependencies
└── README.md                           # This file
```

## 👨‍💻 Development

### Development Environment Setup

1. **Recommended IDE**: IntelliJ IDEA or Eclipse
2. **Useful Plugins**:
   - Lombok Plugin
   - Spring Boot Tools
   - MongoDB Plugin

### Useful Commands

```bash
# Clean and compile
mvn clean compile

# Check dependencies
mvn dependency:tree

# Run with specific profile
mvn spring-boot:run -Dspring.profiles.active=dev
```

### Debug

To debug the application:

```bash
# Run in debug mode
mvn spring-boot:run -Dspring-boot.run.jvmArguments="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
```

### Logs

Logs are configured to output to console. For more detailed logs:

```bash
# Run with debug
mvn spring-boot:run -Dlogging.level.dafon.dev.orderms=DEBUG
```

## 🐳 Docker

### Build Image

```bash
# Build
docker build -t orderms:latest .

# Build with specific tag
docker build -t orderms:v1.0.0 .
```

### Run Container

```bash
# Run
docker run -p 8080:8080 orderms:latest

# Run with environment variables
docker run -p 8080:8080 \
  -e MONGODB_HOST=host.docker.internal \
  -e RABBITMQ_HOST=host.docker.internal \
  orderms:latest
```

### Complete Docker Compose

```yaml
version: '3.8'
services:
  orderms:
    build: .
    ports:
      - "8080:8080"
    environment:
      - MONGODB_HOST=mongodb
      - RABBITMQ_HOST=rabbitmq
    depends_on:
      - mongodb
      - rabbitmq
  
  mongodb:
    image: mongo:6.0
    ports:
      - "27017:27017"
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=123
  
  rabbitmq:
    image: rabbitmq:3.13-management
    ports:
      - "5672:5672"
      - "15672:15672"
```

## 🤝 Contributing

### How to Contribute

1. **Fork** the project
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Code Standards

- Follow Java conventions
- Use descriptive names for variables and methods
- Add comments when necessary
- Keep methods small and focused
- Write tests for new features

### Pull Request Checklist

- [ ] Code follows established standards
- [ ] Tests have been added/updated
- [ ] Documentation has been updated
- [ ] Build passes without errors
- [ ] No merge conflicts

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:

- **Email**: your-email@example.com
- **Issues**: [GitHub Issues](https://github.com/your-username/orderms/issues)
- **Documentation**: [Project Wiki](https://github.com/your-username/orderms/wiki)

## 🙏 Acknowledgments

- Spring Boot Team
- MongoDB Team
- RabbitMQ Team
- Java Community

---

**Developed with ❤️ by the OrderMS Team** 