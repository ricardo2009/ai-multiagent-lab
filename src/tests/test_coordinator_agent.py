from fastapi.testclient import TestClient
from src.agents.coordinator.main import app

client = TestClient(app)

def test_process_task():
    response = client.post("/tasks/", json={"description": "Test task"})
    assert response.status_code == 200
    assert response.json() == {"status": "Task received"}


