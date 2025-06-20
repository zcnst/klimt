# Testing Guide

This document is a guide to tests the API. 

---
## Health Check Endpoint

### Test the health endpoint (GET)
```bash
curl -v http://localhost:4567/health
```

---

## Admin Endpoints

### Test the `admin/test` endpoint with authorization (GET)
```bash
curl -v -H "Authorization: $API_KEY" http://localhost:4567/admin/test
```

### Test the `admin/load` endpoint with valid JSON data (POST)
```bash
curl -v -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    -d '{"type":"artists","artists":[{"name":"Vincent van Gogh"}]}' \
    http://localhost:4567/admin/load
```

### Test the `admin/load` endpoint with an empty body (POST)
```bash
curl -v -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    -d '' \
    http://localhost:4567/admin/load
```

### Test the `admin/load` endpoint with invalid JSON (POST)
```bash
curl -v -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $API_KEY" \
    -d 'not a json body' \
    http://localhost:4567/admin/load
```

---

## Error Handling

### Test a non-existent endpoint
```bash
curl -v http://localhost:4567/non-existent-route
```
