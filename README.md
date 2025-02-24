# mysql-data-generator
setting up a Kubernetes cluster, deploying MySQL with replication, with a writer and reader application running on a Kind Kubernetes cluster. Prometheus and Grafana are used for monitoring.


## Components

- **MySQL Master-Slave**: A replicated MySQL setup.
- **Writer Application**: Inserts data into MySQL master every second.
- **Reader Application**: Reads row count from MySQL slave.
- **Prometheus & Grafana**: Monitoring stack to track query response times.

## Deployment Steps

### Prerequisites

- Install [Kind]
- Install [kubectl]


### Deploying the Project

1. Clone this repository:
   
   git clone https://github.com/uditsawhney/mysql-data-generator.git
   cd <repository-folder>
   
2. Run the deployment script:
   
   chmod +x scripts/deploy.sh
   ./scripts/deploy.sh
  

   ```

## API Endpoints

- **Reader API**: Open http://localhost:8080 in your browser.
- **Prometheus Metrics**: Open http://localhost:3000 in your browser.

## Monitoring

- Grafana dashboards display query response times.
- Prometheus scrapes metrics from the writer and reader applications.

## Cleanup

To delete all resources and stop Minikube:

```bash
kind delete cluster
```


