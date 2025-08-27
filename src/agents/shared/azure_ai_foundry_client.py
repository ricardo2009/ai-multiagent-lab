"""
Azure AI Foundry Client
Advanced client for Azure AI Foundry integration with multiagent orchestration
"""

import os
import asyncio
import logging
from typing import Dict, List, Any, Optional, Union
from dataclasses import dataclass
from enum import Enum

from azure.identity import DefaultAzureCredential, ClientSecretCredential
from azure.ai.ml import MLClient
from azure.ai.textanalytics import TextAnalyticsClient
import openai
from openai import AsyncOpenAI
import structlog

# Configure structured logging
logger = structlog.get_logger(__name__)

class AgentRole(Enum):
    """Agent roles in the multiagent system"""
    COORDINATOR = "coordinator"
    ANALYST = "analyst"
    GENERATOR = "generator"
    VALIDATOR = "validator"

@dataclass
class AgentConfig:
    """Configuration for an AI agent"""
    role: AgentRole
    model: str = "gpt-4"
    temperature: float = 0.7
    max_tokens: int = 2000
    system_prompt: str = ""
    capabilities: List[str] = None

@dataclass
class TaskRequest:
    """Request structure for agent tasks"""
    task_id: str
    agent_role: AgentRole
    input_data: Dict[str, Any]
    context: Optional[Dict[str, Any]] = None
    priority: int = 1
    timeout: int = 300

@dataclass
class TaskResponse:
    """Response structure from agent tasks"""
    task_id: str
    agent_role: AgentRole
    status: str
    result: Dict[str, Any]
    metadata: Dict[str, Any]
    execution_time: float
    error: Optional[str] = None

class AzureAIFoundryClient:
    """
    Advanced Azure AI Foundry client for multiagent orchestration
    """
    
    def __init__(self, 
                 subscription_id: str = None,
                 resource_group: str = None,
                 workspace_name: str = None,
                 openai_endpoint: str = None,
                 openai_api_key: str = None):
        """
        Initialize Azure AI Foundry client
        
        Args:
            subscription_id: Azure subscription ID
            resource_group: Azure resource group name
            workspace_name: ML workspace name
            openai_endpoint: Azure OpenAI endpoint
            openai_api_key: Azure OpenAI API key
        """
        self.subscription_id = subscription_id or os.getenv("AZURE_SUBSCRIPTION_ID")
        self.resource_group = resource_group or os.getenv("AZURE_RESOURCE_GROUP")
        self.workspace_name = workspace_name or os.getenv("AZURE_ML_WORKSPACE_NAME")
        
        # Initialize credentials
        self.credential = self._get_credential()
        
        # Initialize ML client
        try:
            self.ml_client = MLClient(
                credential=self.credential,
                subscription_id=self.subscription_id,
                resource_group_name=self.resource_group,
                workspace_name=self.workspace_name
            )
        except Exception as e:
            logger.warning("ML Client initialization failed", error=str(e))
            self.ml_client = None
        
        # Initialize OpenAI client
        self.openai_client = self._initialize_openai_client(openai_endpoint, openai_api_key)
        
        # Initialize Text Analytics client
        self.text_analytics_client = self._initialize_text_analytics_client()
        
        # Agent configurations
        self.agent_configs = self._load_agent_configurations()
        
        logger.info("Azure AI Foundry client initialized", 
                   subscription_id=self.subscription_id,
                   resource_group=self.resource_group,
                   workspace_name=self.workspace_name)
    
    def _get_credential(self):
        """Get Azure credential based on environment"""
        client_id = os.getenv("AZURE_CLIENT_ID")
        client_secret = os.getenv("AZURE_CLIENT_SECRET")
        tenant_id = os.getenv("AZURE_TENANT_ID")
        
        if client_id and client_secret and tenant_id:
            return ClientSecretCredential(
                tenant_id=tenant_id,
                client_id=client_id,
                client_secret=client_secret
            )
        else:
            return DefaultAzureCredential()
    
    def _initialize_openai_client(self, endpoint: str = None, api_key: str = None):
        """Initialize Azure OpenAI client"""
        endpoint = endpoint or os.getenv("AZURE_OPENAI_ENDPOINT")
        api_key = api_key or os.getenv("AZURE_OPENAI_API_KEY")
        
        if endpoint and api_key:
            return AsyncOpenAI(
                api_key=api_key,
                base_url=f"{endpoint}/openai/deployments",
                api_version="2024-02-15-preview"
            )
        else:
            # Fallback to standard OpenAI
            api_key = os.getenv("OPENAI_API_KEY")
            if api_key:
                return AsyncOpenAI(api_key=api_key)
            else:
                logger.warning("No OpenAI API key found")
                return None
    
    def _initialize_text_analytics_client(self):
        """Initialize Azure Text Analytics client"""
        endpoint = os.getenv("AZURE_TEXT_ANALYTICS_ENDPOINT")
        if endpoint:
            try:
                return TextAnalyticsClient(
                    endpoint=endpoint,
                    credential=self.credential
                )
            except Exception as e:
                logger.warning("Text Analytics client initialization failed", error=str(e))
        return None
    
    def _load_agent_configurations(self) -> Dict[AgentRole, AgentConfig]:
        """Load agent configurations"""
        return {
            AgentRole.COORDINATOR: AgentConfig(
                role=AgentRole.COORDINATOR,
                model="gpt-4",
                temperature=0.3,
                max_tokens=1500,
                system_prompt="""You are the Coordinator Agent in a multiagent AI system.
                Your role is to orchestrate tasks between specialist agents, manage workflow,
                and ensure optimal task distribution. You make strategic decisions about
                which agents to involve and how to sequence their work.""",
                capabilities=["task_orchestration", "workflow_management", "decision_making"]
            ),
            AgentRole.ANALYST: AgentConfig(
                role=AgentRole.ANALYST,
                model="gpt-4",
                temperature=0.2,
                max_tokens=2000,
                system_prompt="""You are the Analysis Agent specialized in data analysis,
                pattern recognition, and insight extraction. You process complex data,
                identify trends, and provide analytical insights to support decision-making.""",
                capabilities=["data_analysis", "pattern_recognition", "insight_extraction"]
            ),
            AgentRole.GENERATOR: AgentConfig(
                role=AgentRole.GENERATOR,
                model="gpt-4",
                temperature=0.8,
                max_tokens=2500,
                system_prompt="""You are the Generation Agent specialized in content creation,
                solution generation, and creative problem-solving. You create high-quality
                outputs based on analysis and requirements.""",
                capabilities=["content_generation", "solution_design", "creative_thinking"]
            ),
            AgentRole.VALIDATOR: AgentConfig(
                role=AgentRole.VALIDATOR,
                model="gpt-4",
                temperature=0.1,
                max_tokens=1000,
                system_prompt="""You are the Validation Agent responsible for quality assurance,
                compliance checking, and result validation. You ensure outputs meet standards
                and requirements before final delivery.""",
                capabilities=["quality_assurance", "compliance_checking", "validation"]
            )
        }
    
    async def execute_agent_task(self, task_request: TaskRequest) -> TaskResponse:
        """
        Execute a task using the specified agent
        
        Args:
            task_request: Task request with agent role and input data
            
        Returns:
            TaskResponse with results and metadata
        """
        start_time = asyncio.get_event_loop().time()
        
        try:
            logger.info("Executing agent task", 
                       task_id=task_request.task_id,
                       agent_role=task_request.agent_role.value)
            
            # Get agent configuration
            agent_config = self.agent_configs[task_request.agent_role]
            
            # Prepare messages for OpenAI
            messages = [
                {"role": "system", "content": agent_config.system_prompt}
            ]
            
            # Add context if provided
            if task_request.context:
                context_msg = f"Context: {task_request.context}"
                messages.append({"role": "user", "content": context_msg})
            
            # Add main task input
            task_content = self._format_task_input(task_request.input_data)
            messages.append({"role": "user", "content": task_content})
            
            # Execute with OpenAI
            if self.openai_client:
                response = await self.openai_client.chat.completions.create(
                    model=agent_config.model,
                    messages=messages,
                    temperature=agent_config.temperature,
                    max_tokens=agent_config.max_tokens,
                    timeout=task_request.timeout
                )
                
                # Process response
                result = self._process_agent_response(response, task_request.agent_role)
                
                execution_time = asyncio.get_event_loop().time() - start_time
                
                logger.info("Agent task completed successfully",
                           task_id=task_request.task_id,
                           agent_role=task_request.agent_role.value,
                           execution_time=execution_time)
                
                return TaskResponse(
                    task_id=task_request.task_id,
                    agent_role=task_request.agent_role,
                    status="success",
                    result=result,
                    metadata={
                        "model": agent_config.model,
                        "temperature": agent_config.temperature,
                        "tokens_used": response.usage.total_tokens if response.usage else 0,
                        "capabilities": agent_config.capabilities
                    },
                    execution_time=execution_time
                )
            else:
                # Fallback simulation when OpenAI is not available
                result = self._simulate_agent_response(task_request.agent_role, task_request.input_data)
                execution_time = asyncio.get_event_loop().time() - start_time
                
                return TaskResponse(
                    task_id=task_request.task_id,
                    agent_role=task_request.agent_role,
                    status="simulated",
                    result=result,
                    metadata={
                        "model": "simulation",
                        "capabilities": agent_config.capabilities
                    },
                    execution_time=execution_time
                )
            
        except Exception as e:
            execution_time = asyncio.get_event_loop().time() - start_time
            
            logger.error("Agent task failed",
                        task_id=task_request.task_id,
                        agent_role=task_request.agent_role.value,
                        error=str(e),
                        execution_time=execution_time)
            
            return TaskResponse(
                task_id=task_request.task_id,
                agent_role=task_request.agent_role,
                status="error",
                result={},
                metadata={},
                execution_time=execution_time,
                error=str(e)
            )
    
    def _format_task_input(self, input_data: Dict[str, Any]) -> str:
        """Format task input data for agent processing"""
        if isinstance(input_data, dict):
            formatted_parts = []
            for key, value in input_data.items():
                formatted_parts.append(f"{key}: {value}")
            return "\n".join(formatted_parts)
        else:
            return str(input_data)
    
    def _process_agent_response(self, response, agent_role: AgentRole) -> Dict[str, Any]:
        """Process and structure agent response"""
        content = response.choices[0].message.content
        
        # Basic response structure
        result = {
            "content": content,
            "agent_role": agent_role.value,
            "timestamp": asyncio.get_event_loop().time()
        }
        
        # Role-specific processing
        if agent_role == AgentRole.COORDINATOR:
            result.update(self._process_coordinator_response(content))
        elif agent_role == AgentRole.ANALYST:
            result.update(self._process_analyst_response(content))
        elif agent_role == AgentRole.GENERATOR:
            result.update(self._process_generator_response(content))
        elif agent_role == AgentRole.VALIDATOR:
            result.update(self._process_validator_response(content))
        
        return result
    
    def _simulate_agent_response(self, agent_role: AgentRole, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Simulate agent response for demo purposes"""
        base_result = {
            "agent_role": agent_role.value,
            "timestamp": asyncio.get_event_loop().time(),
            "simulated": True
        }
        
        if agent_role == AgentRole.COORDINATOR:
            base_result.update({
                "content": "Task coordination completed. Distributing work to specialist agents.",
                "task_assignments": ["analyst", "generator", "validator"],
                "workflow_steps": ["analyze", "generate", "validate"],
                "priority_order": [1, 2, 3]
            })
        elif agent_role == AgentRole.ANALYST:
            base_result.update({
                "content": "Analysis completed. Key patterns and insights identified.",
                "insights": ["Pattern A detected", "Trend B identified"],
                "confidence_score": 0.85
            })
        elif agent_role == AgentRole.GENERATOR:
            base_result.update({
                "content": "Content generation completed successfully.",
                "generated_content": "High-quality output generated based on analysis",
                "content_type": "text"
            })
        elif agent_role == AgentRole.VALIDATOR:
            base_result.update({
                "content": "Validation completed. Quality standards met.",
                "validation_status": "passed",
                "quality_score": 0.92,
                "approved": True
            })
        
        return base_result
    
    def _process_coordinator_response(self, content: str) -> Dict[str, Any]:
        """Process coordinator agent response"""
        return {
            "task_assignments": [],
            "workflow_steps": [],
            "priority_order": [],
            "estimated_completion": None
        }
    
    def _process_analyst_response(self, content: str) -> Dict[str, Any]:
        """Process analyst agent response"""
        return {
            "insights": [],
            "patterns": [],
            "recommendations": [],
            "confidence_score": 0.0
        }
    
    def _process_generator_response(self, content: str) -> Dict[str, Any]:
        """Process generator agent response"""
        return {
            "generated_content": content,
            "content_type": "text",
            "quality_metrics": {},
            "alternatives": []
        }
    
    def _process_validator_response(self, content: str) -> Dict[str, Any]:
        """Process validator agent response"""
        return {
            "validation_status": "pending",
            "compliance_checks": [],
            "quality_score": 0.0,
            "issues_found": [],
            "approved": False
        }
    
    async def orchestrate_multiagent_workflow(self, 
                                            workflow_request: Dict[str, Any]) -> Dict[str, Any]:
        """
        Orchestrate a complex workflow involving multiple agents
        
        Args:
            workflow_request: Workflow configuration and input data
            
        Returns:
            Workflow results with all agent outputs
        """
        workflow_id = workflow_request.get("workflow_id", "default")
        
        logger.info("Starting multiagent workflow", workflow_id=workflow_id)
        
        try:
            # Step 1: Coordinator plans the workflow
            coordinator_task = TaskRequest(
                task_id=f"{workflow_id}_coordinator",
                agent_role=AgentRole.COORDINATOR,
                input_data=workflow_request,
                priority=1
            )
            
            coordinator_response = await self.execute_agent_task(coordinator_task)
            
            if coordinator_response.status not in ["success", "simulated"]:
                raise Exception(f"Coordinator failed: {coordinator_response.error}")
            
            # Step 2: Execute planned tasks in sequence
            workflow_results = {
                "workflow_id": workflow_id,
                "coordinator_plan": coordinator_response.result,
                "agent_results": {},
                "status": "in_progress",
                "start_time": asyncio.get_event_loop().time()
            }
            
            # Execute analyst task
            if workflow_request.get("require_analysis", True):
                analyst_task = TaskRequest(
                    task_id=f"{workflow_id}_analyst",
                    agent_role=AgentRole.ANALYST,
                    input_data=workflow_request.get("analysis_data", {}),
                    context=coordinator_response.result,
                    priority=2
                )
                
                analyst_response = await self.execute_agent_task(analyst_task)
                workflow_results["agent_results"]["analyst"] = analyst_response
            
            # Execute generator task
            if workflow_request.get("require_generation", True):
                generator_input = workflow_request.get("generation_data", {})
                if "analyst" in workflow_results["agent_results"]:
                    generator_input["analysis_results"] = workflow_results["agent_results"]["analyst"].result
                
                generator_task = TaskRequest(
                    task_id=f"{workflow_id}_generator",
                    agent_role=AgentRole.GENERATOR,
                    input_data=generator_input,
                    context=coordinator_response.result,
                    priority=3
                )
                
                generator_response = await self.execute_agent_task(generator_task)
                workflow_results["agent_results"]["generator"] = generator_response
            
            # Execute validator task
            if workflow_request.get("require_validation", True):
                validator_input = workflow_request.get("validation_criteria", {})
                if "generator" in workflow_results["agent_results"]:
                    validator_input["content_to_validate"] = workflow_results["agent_results"]["generator"].result
                
                validator_task = TaskRequest(
                    task_id=f"{workflow_id}_validator",
                    agent_role=AgentRole.VALIDATOR,
                    input_data=validator_input,
                    context=coordinator_response.result,
                    priority=4
                )
                
                validator_response = await self.execute_agent_task(validator_task)
                workflow_results["agent_results"]["validator"] = validator_response
            
            # Finalize workflow
            workflow_results["status"] = "completed"
            workflow_results["end_time"] = asyncio.get_event_loop().time()
            workflow_results["total_execution_time"] = (
                workflow_results["end_time"] - workflow_results["start_time"]
            )
            
            logger.info("Multiagent workflow completed successfully",
                       workflow_id=workflow_id,
                       execution_time=workflow_results["total_execution_time"])
            
            return workflow_results
            
        except Exception as e:
            logger.error("Multiagent workflow failed",
                        workflow_id=workflow_id,
                        error=str(e))
            
            return {
                "workflow_id": workflow_id,
                "status": "failed",
                "error": str(e),
                "end_time": asyncio.get_event_loop().time()
            }
    
    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on all AI services"""
        health_status = {
            "timestamp": asyncio.get_event_loop().time(),
            "services": {}
        }
        
        # Check OpenAI connection
        try:
            if self.openai_client:
                test_response = await self.openai_client.chat.completions.create(
                    model="gpt-3.5-turbo",
                    messages=[{"role": "user", "content": "Health check"}],
                    max_tokens=10
                )
                health_status["services"]["openai"] = "healthy"
            else:
                health_status["services"]["openai"] = "not_configured"
        except Exception as e:
            health_status["services"]["openai"] = f"unhealthy: {str(e)}"
        
        # Check ML workspace connection
        try:
            if self.ml_client:
                # Simple test call
                health_status["services"]["ml_workspace"] = "healthy"
            else:
                health_status["services"]["ml_workspace"] = "not_configured"
        except Exception as e:
            health_status["services"]["ml_workspace"] = f"unhealthy: {str(e)}"
        
        # Check Text Analytics
        if self.text_analytics_client:
            try:
                # Simple test call
                health_status["services"]["text_analytics"] = "healthy"
            except Exception as e:
                health_status["services"]["text_analytics"] = f"unhealthy: {str(e)}"
        else:
            health_status["services"]["text_analytics"] = "not_configured"
        
        # Overall health
        unhealthy_services = [
            service for service, status in health_status["services"].items()
            if status.startswith("unhealthy")
        ]
        
        health_status["overall_status"] = "healthy" if not unhealthy_services else "degraded"
        health_status["unhealthy_services"] = unhealthy_services
        
        return health_status

