import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from agents.specialist_agents.analysis_agent import analyze
from agents.specialist_agents.generation_agent import generate
from agents.specialist_agents.validation_agent import validate

def test_analysis_agent():
    result = analyze("Test data")
    assert result == {"analysis": "completed"}

def test_generation_agent():
    result = generate("Test prompt")
    assert result == {"generated_content": "..."}

def test_validation_agent():
    result = validate("Test content")
    assert result == {"validation_status": "valid"}


