1.  Set up the Flask Application

          mkdir flask-docker-app
          cd flask-docker-app

2. Create a virtual environment:

          python3 -m venv venv
          source venv/bin/activate

3. Install Flask

          pip install Flask

4. Create a file named app.py and add the following code

          from flask import Flask
          
          app = Flask(__name__)
          
          @app.route('/')
          def hello_world():
              return 'Hello, Docker!'
          
          if __name__ == '__main__':
              app.run(host='0.0.0.0', port=8080)

5. Create Dockerfile
          #### - Use an official Python runtime as a parent image
          FROM python:3.9-slim
          
          #### -Set the working directory in the container
          WORKDIR /app
          
          #### - Copy the current directory contents into the container at /app
          COPY . /app
          
          #### - Install any needed packages specified in requirements.txt
          RUN pip install --no-cache-dir Flask
          
          #### - Make port 8080 available to the world outside this container
          EXPOSE 8080
          
          #### - Define environment variable
          ENV NAME World
          
          #### - Run app.py when the container launches
          CMD ["python", "app.py"]


6. Build the Docker image

          docker build -t flask-docker-app .

7. Run the Docker container

          docker run -p 8080:8080 flask-docker-app

8. Test the Docker container

         http://127.0.0.1:8080





## ++++++++++ MONITORING GRAFANA PROMETHEUS ++++++++++++++

1. Create a prometheus.yml configuration file
          global:
            scrape_interval: 15s
          
          scrape_configs:
            - job_name: 'flask'
              static_configs:
                - targets: ['flask-app:5000']
          


2. Create a directory named prometheus and within it, create a Dockerfile 
          FROM prom/prometheus
          COPY prometheus.yml /etc/prometheus/prometheus.yml


3. Set Up Flask Metrics Exporter
          pip install prometheus_client


4. Update app.py to include the Prometheus client:

          from flask import Flask, Response
          from prometheus_client import Counter, generate_latest, CollectorRegistry, multiprocess, CONTENT_TYPE_LATEST
          
          app = Flask(__name__)
          
          REQUEST_COUNT = Counter('request_count', 'App Request Count', ['endpoint'])
          
          @app.route('/')
          def hello_world():
              REQUEST_COUNT.labels('/').inc()
              return 'Hello, Docker!'
          
          @app.route('/metrics')
          def metrics():
              registry = CollectorRegistry()
              multiprocess.MultiProcessCollector(registry)
              return Response(generate_latest(registry), mimetype=CONTENT_TYPE_LATEST)
          
          if __name__ == '__main__':
              app.run(host='0.0.0.0', port=8080)
          
          
          5. Set Up Grafana
          Create a docker-compose.yml file
          
          version: '3'
          services:
            flask-app:
              build: .
              ports:
                - "5000:5000"
          
            prometheus:
              build: ./prometheus
              ports:
                - "9090:9090"
              volumes:
                - prometheus_data:/prometheus
          
            grafana:
              image: grafana/grafana
              ports:
                - "3000:3000"
              volumes:
                - grafana_data:/var/lib/grafana
          
          volumes:
            prometheus_data:
            grafana_data:


6. Run the Docker Compose:
          docker-compose up -d


7. Configure Prometheus as a Data Source in Grafana
          Open Grafana by navigating to http://localhost:3000.
          Log in with the default credentials (admin / admin).
          Add a new data source:
          Go to Configuration > Data Sources.
          Click Add data source.
          Select Prometheus.
          Set the URL to http://prometheus:9090.
          Click Save & Test.
          Step 5: Create a Dashboard in Grafana
          Create a new dashboard:
          Click the + icon on the left sidebar.
          Select Dashboard > Add new panel.

