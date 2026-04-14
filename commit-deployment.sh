#!/bin/bash

# Make build script executable
chmod +x build-render.sh

# Commit all changes to render-deployment branch
git add -A
git commit -m " Add Render deployment configuration

- Add render.yaml for Render platform
- Add Dockerfile for containerization
- Add build-render.sh for Render builds
- Add .env.example for environment configuration
- Add Spring Boot REST API scaffolding
- Add pom.xml with dependencies
- Add REST controllers: Members, Payments, Dashboard
- Add MongoDB configuration
- Add service layer implementations
- Add MongoDB Atlas setup guide
- Add model classes for Member and Payment
- Add MongoDB repositories

This branch preserves the original desktop version in v1.0-desktop tag
on main branch. Render deployment uses REST API architecture."

echo " Deployment configuration committed!"
git log --oneline -3
