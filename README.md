# IronPulse

IronPulse is a Spring Boot and MongoDB gym management web app with a built-in frontend dashboard for members, payments, activity, and reports.

## Live App

- Production URL: https://ironpluse.onrender.com/
- Default login: admin / admin123

## Features

- Web dashboard with overview cards, recent payments, member distribution, and activity feed
- Member management: create, view, update, delete, and search
- Payment tracking with paid and pending statuses
- Reports and summary endpoints for dashboard analytics
- Single-deploy backend + frontend from one Spring Boot service
- Render-ready Docker deployment
- MongoDB Atlas support via environment variables

## Tech Stack

- Java 21
- Spring Boot 3
- Spring Data MongoDB
- Maven
- Vanilla HTML, CSS, JavaScript frontend in static resources
- Docker + Render deployment

## Project Structure

- src/main/java/com/ironpulse/controller: REST controllers
- src/main/java/com/ironpulse/service: business logic
- src/main/java/com/ironpulse/model: MongoDB document models
- src/main/java/com/ironpulse/repository: Mongo repositories
- src/main/resources/static/index.html: frontend app
- src/main/resources/application.yml: runtime configuration
- seed-demo-data.sh: helper script to populate demo data

## Local Run

1. Set Java 21 and Maven.
2. Configure MongoDB URI if needed.
3. Start the app.

```bash
mvn spring-boot:run
```

App URL:

```text
http://localhost:8080
```

## Environment Variables

Set these for local or cloud deployment:

```bash
MONGO_URI=mongodb+srv://<user>:<password>@<cluster>/<database>?retryWrites=true&w=majority&appName=Cluster0
DB_NAME=ironpulse
PORT=8080
```

Spring defaults are configured in application.yml, but Render should provide MONGO_URI in service environment variables.

## Seed Demo Data

Use the included script to clear existing data and seed demo members and payments:

```bash
./seed-demo-data.sh https://ironpluse.onrender.com
```

What it does:

- Verifies service connectivity
- Deletes existing members and payments
- Seeds 25 demo members
- Seeds 20 demo payments

## Deploy on Render

1. Connect repository branch render-deployment.
2. Ensure Docker deployment is enabled.
3. Set MONGO_URI and DB_NAME in Render environment variables.
4. Deploy and verify:

```text
GET /api/dashboard/overview
GET /api/dashboard/members/distribution
GET /api/dashboard/activities/recent
```

## API Overview

- /api/members
- /api/payments
- /api/dashboard/overview
- /api/dashboard/members/distribution
- /api/dashboard/activities/recent

## Notes

- If dashboard shows connection unavailable, verify dashboard endpoints return 200 and MongoDB credentials are valid.
- If data looks stale, rerun the seeding script.
