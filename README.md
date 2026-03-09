# Cloud Engineer Intern Assessment - Santhosh

Hi! This is my submission for the CloudEngine Labs Cloud Engineer Intern assessment. I built a Flask REST API, containerized it with Docker, and deployed it to AWS using Terraform.

---

## What I Built

A simple Flask API that returns a JSON greeting when you hit the root endpoint. The whole thing can be deployed to AWS with a single `terraform apply` command.

**Live Demo:** http://13.222.175.133:5000/

---

## Project Files

| File | What it does |
|------|-------------|
| `app.py` | The Flask application |
| `Dockerfile` | Container configuration |
| `requirements.txt` | Python dependencies |
| `main.tf` | Terraform infrastructure code |
| `variables.tf` | Terraform variables |
| `outputs.tf` | Terraform outputs |
| `.github/workflows/ci-cd.yml` | CI/CD pipeline (bonus) |

---

## Task 1: Flask Application

I created a simple Flask app with one endpoint:

```python
@app.route("/")
def hello():
    return jsonify(message="Hello CloudEngine Labs - from Python Flask!")
```

**Testing locally:**
```bash
pip install flask
python app.py
```

Then I opened http://localhost:5000/ in my browser and got:
```json
{"message": "Hello CloudEngine Labs - from Python Flask!"}
```

---

## Task 2: Docker Container

I wrote a Dockerfile to containerize the app:

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
```

**Building and running locally:**
```bash
docker build -t flask-cloudengine .
docker run -d -p 5000:5000 --name flask-app flask-cloudengine
```

**Result:**
```
StatusCode        : 200
Content           : {"message":"Hello CloudEngine Labs - from Python Flask!"}
```

**Pushed to Docker Hub:**
```bash
docker login
docker tag flask-cloudengine santhosh1024/flask-cloudengine:latest
docker push santhosh1024/flask-cloudengine:latest
```

**Docker Image Tag:** `santhosh1024/flask-cloudengine:latest`

---

## Task 3: Terraform Infrastructure

My Terraform code provisions:
- An EC2 t2.micro instance running Ubuntu 22.04
- A security group allowing inbound traffic on ports 22 (SSH) and 5000 (Flask)
- A user_data script that installs Docker, pulls my image, and runs the container

**Deploying:**
```bash
terraform init
terraform plan
terraform apply
```

**Terraform Output:**
```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

flask_app_url = "http://13.222.175.133:5000/"
instance_id = "i-02d5a30468b61c396"
instance_public_dns = "ec2-13-222-175-133.compute-1.amazonaws.com"
instance_public_ip = "13.222.175.133"
```

---

## Task 4: Deployment Verification

After running `terraform apply`, I waited a few minutes for the instance to boot and install everything, then tested the public URL:

```bash
curl http://13.222.175.133:5000/
```

**Response:**
```json
{"message": "Hello CloudEngine Labs - from Python Flask!"}
```

It works!

---
