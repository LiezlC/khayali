# Wisdom Syndicate - Multi-Agent Knowledge Management System
# For Cross-Project Learning & Standards Evolution in Extractives Industry

import asyncio
import logging
from abc import ABC, abstractmethod
from typing import Dict, Any, List, Optional, Set, Tuple
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from enum import Enum
import json
import hashlib
import numpy as np
from collections import defaultdict, Counter
import sqlite3
from pathlib import Path
import aiofiles
import aiohttp
from pydantic import BaseModel, Field
import pickle
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans
from sklearn.metrics.pairwise import cosine_similarity
import spacy
import re

# =============================================================================
# Core Data Models
# =============================================================================

class ProjectType(Enum):
    MINING = "mining"
    OIL_GAS = "oil_gas"
    INFRASTRUCTURE = "infrastructure"
    RENEWABLE = "renewable"

class IssueCategory(Enum):
    RESETTLEMENT = "resettlement"
    ENVIRONMENTAL = "environmental"
    COMMUNITY_ENGAGEMENT = "community_engagement"
    COMPENSATION = "compensation"
    CULTURAL_HERITAGE = "cultural_heritage"
    GRIEVANCE = "grievance"
    MONITORING = "monitoring"

class IssueSeverity(Enum):
    LOW = 1
    MEDIUM = 2
    HIGH = 3
    CRITICAL = 4

class StandardsFramework(Enum):
    IFC_PS = "ifc_performance_standards"
    WORLD_BANK_ESS = "world_bank_ess"
    EQUATOR_PRINCIPLES = "equator_principles"
    NATIONAL_REGULATION = "national_regulation"
    COMPANY_STANDARD = "company_standard"

@dataclass
class ProjectContext:
    """Comprehensive project context for pattern analysis"""
    project_id: str
    project_type: ProjectType
    location: Dict[str, Any]  # Country, region, coordinates
    scale: str  # Small, medium, large, mega
    timeline: Dict[str, datetime]  # Start, phases, completion
    stakeholders: List[str]
    regulatory_framework: List[StandardsFramework]
    environmental_context: Dict[str, Any]
    social_context: Dict[str, Any]
    economic_context: Dict[str, Any]

@dataclass
class IssueRecord:
    """Detailed issue record for pattern recognition"""
    issue_id: str
    project_context: ProjectContext
    category: IssueCategory
    severity: IssueSeverity
    description: str
    root_causes: List[str]
    timeline: Dict[str, datetime]
    stakeholders_affected: List[str]
    resolution_approach: str
    outcome: str
    lessons_learned: List[str]
    cost_impact: Optional[float] = None
    time_impact: Optional[int] = None  # Days
    recurrence_risk: Optional[float] = None
    tags: List[str] = field(default_factory=list)

@dataclass
class BestPractice:
    """Best practice with context and evidence"""
    practice_id: str
    title: str
    description: str
    category: IssueCategory
    context_applicability: List[str]
    evidence_strength: float  # 0-1 score
    implementation_steps: List[str]
    success_metrics: List[str]
    challenges: List[str]
    resources_required: Dict[str, Any]
    source_projects: List[str]
    last_updated: datetime
    validation_count: int = 0

@dataclass
class StandardsEvolution:
    """Tracking evolution of standards and requirements"""
    framework: StandardsFramework
    version: str
    change_date: datetime
    changes: List[Dict[str, Any]]
    impact_assessment: str
    implementation_timeline: Optional[datetime] = None
    affected_projects: List[str] = field(default_factory=list)

@dataclass
class PeerConnection:
    """Peer network connection with expertise mapping"""
    practitioner_id: str
    name: str
    expertise: List[str]
    experience_years: int
    project_history: List[str]
    availability: str
    contact_info: Dict[str, str]
    reputation_score: float = 0.0
    response_rate: float = 0.0

# =============================================================================
# Base Agent Class
# =============================================================================

class WisdomAgent(ABC):
    """Base class for all Wisdom Syndicate agents"""
    
    def __init__(self, agent_id: str, config: Dict[str, Any]):
        self.agent_id = agent_id
        self.config = config
        self.logger = logging.getLogger(f"wisdom.{agent_id}")
        self.message_queue = asyncio.Queue()
        self.db_path = Path(config.get('db_path', 'wisdom_syndicate.db'))
        self.is_running = False
        
    async def initialize(self):
        """Initialize agent resources"""
        await self.setup_database()
        await self.load_models()
        
    async def setup_database(self):
        """Setup agent-specific database tables"""
        pass
        
    async def load_models(self):
        """Load any ML models or NLP resources"""
        pass
        
    @abstractmethod
    async def process_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Core processing logic"""
        pass
        
    async def send_message(self, target_agent: str, message: Dict[str, Any]):
        """Send message to another agent"""
        message['sender'] = self.agent_id
        message['timestamp'] = datetime.now().isoformat()
        # In production, this would use a message broker like Redis/RabbitMQ
        self.logger.info(f"Sending message to {target_agent}: {message['type']}")
        
    async def start(self):
        """Start the agent"""
        self.is_running = True
        await self.initialize()
        self.logger.info(f"Agent {self.agent_id} started")
        
        # Start message processing loop
        while self.is_running:
            try:
                # Process any queued messages
                if not self.message_queue.empty():
                    message = await self.message_queue.get()
                    await self.handle_message(message)
                await asyncio.sleep(0.1)  # Prevent busy waiting
            except Exception as e:
                self.logger.error(f"Error in message loop: {e}")
                
    async def stop(self):
        """Stop the agent"""
        self.is_running = False
        self.logger.info(f"Agent {self.agent_id} stopped")
        
    async def handle_message(self, message: Dict[str, Any]):
        """Handle incoming messages"""
        message_type = message.get('type')
        self.logger.debug(f"Handling message type: {message_type}")
        
        if message_type == 'health_check':
            return {'status': 'healthy', 'agent_id': self.agent_id}
        
        # Route to specific handlers
        handler_method = f"handle_{message_type}"
        if hasattr(self, handler_method):
            return await getattr(self, handler_method)(message)
        else:
            self.logger.warning(f"No handler for message type: {message_type}")

# =============================================================================
# Pattern Recognition Agent
# =============================================================================

class PatternRecognitionAgent(WisdomAgent):
    """Identifies recurring patterns across projects and issues"""
    
    def __init__(self, agent_id: str, config: Dict[str, Any]):
        super().__init__(agent_id, config)
        self.vectorizer = None
        self.clustering_model = None
        self.pattern_cache = {}
        
    async def setup_database(self):
        """Setup pattern recognition database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS patterns (
                pattern_id TEXT PRIMARY KEY,
                pattern_type TEXT,
                description TEXT,
                frequency INTEGER,
                severity_avg REAL,
                contexts TEXT,  -- JSON
                signature_hash TEXT,
                first_seen DATE,
                last_seen DATE,
                confidence_score REAL
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS pattern_instances (
                instance_id TEXT PRIMARY KEY,
                pattern_id TEXT,
                project_id TEXT,
                issue_id TEXT,
                similarity_score REAL,
                context_match REAL,
                timestamp DATE,
                FOREIGN KEY (pattern_id) REFERENCES patterns(pattern_id)
            )
        ''')
        
        conn.commit()
        conn.close()
        
    async def load_models(self):
        """Load NLP and clustering models"""
        try:
            # Load spaCy model for text processing
            self.nlp = spacy.load("en_core_web_sm")
            
            # Initialize TF-IDF vectorizer
            self.vectorizer = TfidfVectorizer(
                max_features=1000,
                stop_words='english',
                ngram_range=(1, 3)
            )
            
            # Initialize clustering model
            self.clustering_model = KMeans(n_clusters=20, random_state=42)
            
        except Exception as e:
            self.logger.error(f"Error loading models: {e}")
            # Fallback to basic text processing
            self.vectorizer = TfidfVectorizer(max_features=500)
            
    async def process_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Process new issue data to identify patterns"""
        try:
            if data.get('type') == 'new_issue':
                issue = IssueRecord(**data['issue'])
                patterns = await self.analyze_issue_patterns(issue)
                return {
                    'agent_id': self.agent_id,
                    'patterns_found': patterns,
                    'issue_id': issue.issue_id
                }
            
            elif data.get('type') == 'pattern_analysis_request':
                category = data.get('category')
                timeframe = data.get('timeframe', 365)  # Days
                patterns = await self.get_category_patterns(category, timeframe)
                return {
                    'agent_id': self.agent_id,
                    'category': category,
                    'patterns': patterns
                }
                
        except Exception as e:
            self.logger.error(f"Error processing data: {e}")
            return {'error': str(e)}
            
    async def analyze_issue_patterns(self, issue: IssueRecord) -> List[Dict[str, Any]]:
        """Analyze a single issue for patterns"""
        patterns = []
        
        # Create issue signature
        issue_signature = self.create_issue_signature(issue)
        
        # Check against existing patterns
        similar_patterns = await self.find_similar_patterns(issue_signature, issue)
        
        if similar_patterns:
            # Update existing patterns
            for pattern in similar_patterns:
                await self.update_pattern_occurrence(pattern['pattern_id'], issue)
                patterns.append(pattern)
        else:
            # Create new pattern if this is a recurring issue type
            if await self.is_recurring_issue_type(issue):
                new_pattern = await self.create_new_pattern(issue)
                patterns.append(new_pattern)
                
        return patterns
        
    def create_issue_signature(self, issue: IssueRecord) -> Dict[str, Any]:
        """Create a unique signature for an issue"""
        # Combine key attributes into a signature
        text_content = f"{issue.description} {' '.join(issue.root_causes)} {issue.resolution_approach}"
        
        # Extract key features
        doc = self.nlp(text_content) if self.nlp else None
        
        signature = {
            'category': issue.category.value,
            'severity': issue.severity.value,
            'project_type': issue.project_context.project_type.value,
            'location_type': issue.project_context.location.get('type', 'unknown'),
            'stakeholders': sorted(issue.stakeholders_affected),
            'root_causes': sorted(issue.root_causes),
            'text_hash': hashlib.md5(text_content.encode()).hexdigest(),
            'entities': [ent.text for ent in doc.ents] if doc else [],
            'keywords': self.extract_keywords(text_content)
        }
        
        return signature
        
    def extract_keywords(self, text: str) -> List[str]:
        """Extract keywords from text"""
        # Simple keyword extraction - in production, use more sophisticated NLP
        keywords = []
        
        # Common extractives industry terms
        industry_terms = [
            'resettlement', 'compensation', 'livelihood', 'consultation',
            'grievance', 'monitoring', 'baseline', 'impact', 'mitigation',
            'stakeholder', 'community', 'environmental', 'social',
            'indigenous', 'cultural', 'heritage', 'sacred', 'traditional'
        ]
        
        text_lower = text.lower()
        for term in industry_terms:
            if term in text_lower:
                keywords.append(term)
                
        return keywords
        
    async def find_similar_patterns(self, signature: Dict[str, Any], issue: IssueRecord) -> List[Dict[str, Any]]:
        """Find patterns similar to the given issue"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Query existing patterns
        cursor.execute('''
            SELECT pattern_id, pattern_type, description, contexts, confidence_score
            FROM patterns
            WHERE pattern_type = ?
        ''', (signature['category'],))
        
        existing_patterns = cursor.fetchall()
        similar_patterns = []
        
        for pattern_row in existing_patterns:
            pattern_id, pattern_type, description, contexts_json, confidence = pattern_row
            contexts = json.loads(contexts_json)
            
            # Calculate similarity
            similarity = self.calculate_pattern_similarity(signature, contexts)
            
            if similarity > 0.7:  # Threshold for similarity
                similar_patterns.append({
                    'pattern_id': pattern_id,
                    'pattern_type': pattern_type,
                    'description': description,
                    'similarity': similarity,
                    'confidence': confidence
                })
                
        conn.close()
        return similar_patterns
        
    def calculate_pattern_similarity(self, signature: Dict[str, Any], contexts: Dict[str, Any]) -> float:
        """Calculate similarity between issue signature and pattern contexts"""
        similarities = []
        
        # Category match
        if signature['category'] == contexts.get('category'):
            similarities.append(1.0)
        else:
            similarities.append(0.0)
            
        # Project type similarity
        if signature['project_type'] == contexts.get('project_type'):
            similarities.append(1.0)
        else:
            similarities.append(0.3)
            
        # Stakeholder overlap
        sig_stakeholders = set(signature.get('stakeholders', []))
        ctx_stakeholders = set(contexts.get('stakeholders', []))
        if sig_stakeholders and ctx_stakeholders:
            overlap = len(sig_stakeholders & ctx_stakeholders) / len(sig_stakeholders | ctx_stakeholders)
            similarities.append(overlap)
            
        # Root cause similarity
        sig_causes = set(signature.get('root_causes', []))
        ctx_causes = set(contexts.get('root_causes', []))
        if sig_causes and ctx_causes:
            overlap = len(sig_causes & ctx_causes) / len(sig_causes | ctx_causes)
            similarities.append(overlap)
            
        # Keyword similarity
        sig_keywords = set(signature.get('keywords', []))
        ctx_keywords = set(contexts.get('keywords', []))
        if sig_keywords and ctx_keywords:
            overlap = len(sig_keywords & ctx_keywords) / len(sig_keywords | ctx_keywords)
            similarities.append(overlap)
            
        return np.mean(similarities) if similarities else 0.0
        
    async def is_recurring_issue_type(self, issue: IssueRecord) -> bool:
        """Check if this issue type has occurred before"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Check for similar issues in the past
        cursor.execute('''
            SELECT COUNT(*) FROM pattern_instances pi
            JOIN patterns p ON pi.pattern_id = p.pattern_id
            WHERE p.pattern_type = ?
            AND pi.timestamp > date('now', '-365 days')
        ''', (issue.category.value,))
        
        count = cursor.fetchone()[0]
        conn.close()
        
        return count >= 2  # Consider recurring if seen 2+ times
        
    async def create_new_pattern(self, issue: IssueRecord) -> Dict[str, Any]:
        """Create a new pattern from an issue"""
        pattern_id = f"pattern_{issue.category.value}_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
        signature = self.create_issue_signature(issue)
        
        pattern = {
            'pattern_id': pattern_id,
            'pattern_type': issue.category.value,
            'description': f"Recurring {issue.category.value} issue: {issue.description[:100]}...",
            'frequency': 1,
            'severity_avg': float(issue.severity.value),
            'contexts': signature,
            'signature_hash': signature['text_hash'],
            'first_seen': datetime.now().date(),
            'last_seen': datetime.now().date(),
            'confidence_score': 0.5  # Initial confidence
        }
        
        # Store in database
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT INTO patterns (
                pattern_id, pattern_type, description, frequency, severity_avg,
                contexts, signature_hash, first_seen, last_seen, confidence_score
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            pattern['pattern_id'], pattern['pattern_type'], pattern['description'],
            pattern['frequency'], pattern['severity_avg'], json.dumps(pattern['contexts']),
            pattern['signature_hash'], pattern['first_seen'], pattern['last_seen'],
            pattern['confidence_score']
        ))
        
        # Add instance
        cursor.execute('''
            INSERT INTO pattern_instances (
                instance_id, pattern_id, project_id, issue_id, 
                similarity_score, context_match, timestamp
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (
            f"instance_{pattern_id}_{issue.issue_id}",
            pattern_id, issue.project_context.project_id, issue.issue_id,
            1.0, 1.0, datetime.now().date()
        ))
        
        conn.commit()
        conn.close()
        
        self.logger.info(f"Created new pattern: {pattern_id}")
        return pattern
        
    async def update_pattern_occurrence(self, pattern_id: str, issue: IssueRecord):
        """Update pattern with new occurrence"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Update pattern statistics
        cursor.execute('''
            UPDATE patterns SET
                frequency = frequency + 1,
                severity_avg = (severity_avg * (frequency - 1) + ?) / frequency,
                last_seen = ?,
                confidence_score = MIN(confidence_score + 0.1, 1.0)
            WHERE pattern_id = ?
        ''', (float(issue.severity.value), datetime.now().date(), pattern_id))
        
        # Add new instance
        cursor.execute('''
            INSERT INTO pattern_instances (
                instance_id, pattern_id, project_id, issue_id,
                similarity_score, context_match, timestamp
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (
            f"instance_{pattern_id}_{issue.issue_id}",
            pattern_id, issue.project_context.project_id, issue.issue_id,
            0.8, 0.8, datetime.now().date()
        ))
        
        conn.commit()
        conn.close()
        
    async def get_category_patterns(self, category: str, timeframe_days: int) -> List[Dict[str, Any]]:
        """Get patterns for a specific category and timeframe"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT pattern_id, pattern_type, description, frequency, 
                   severity_avg, confidence_score, contexts
            FROM patterns
            WHERE pattern_type = ?
            AND last_seen > date('now', '-{} days')
            ORDER BY frequency DESC, confidence_score DESC
        '''.format(timeframe_days), (category,))
        
        patterns = []
        for row in cursor.fetchall():
            pattern_id, pattern_type, description, frequency, severity_avg, confidence, contexts_json = row
            
            patterns.append({
                'pattern_id': pattern_id,
                'pattern_type': pattern_type,
                'description': description,
                'frequency': frequency,
                'severity_avg': severity_avg,
                'confidence_score': confidence,
                'contexts': json.loads(contexts_json)
            })
            
        conn.close()
        return patterns

# =============================================================================
# Best Practice Curator Agent
# =============================================================================

class BestPracticeCuratorAgent(WisdomAgent):
    """Curates and maintains best practices library"""
    
    def __init__(self, agent_id: str, config: Dict[str, Any]):
        super().__init__(agent_id, config)
        self.practice_library = {}
        self.effectiveness_tracker = {}
        
    async def setup_database(self):
        """Setup best practices database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS best_practices (
                practice_id TEXT PRIMARY KEY,
                title TEXT,
                description TEXT,
                category TEXT,
                context_applicability TEXT,  -- JSON
                evidence_strength REAL,
                implementation_steps TEXT,  -- JSON
                success_metrics TEXT,  -- JSON
                challenges TEXT,  -- JSON
                resources_required TEXT,  -- JSON
                source_projects TEXT,  -- JSON
                created_date DATE,
                last_updated DATE,
                validation_count INTEGER,
                effectiveness_score REAL
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS practice_applications (
                application_id TEXT PRIMARY KEY,
                practice_id TEXT,
                project_id TEXT,
                implementation_date DATE,
                outcome TEXT,
                effectiveness_rating REAL,
                feedback TEXT,
                lessons_learned TEXT,
                FOREIGN KEY (practice_id) REFERENCES best_practices(practice_id)
            )
        ''')
        
        conn.commit()
        conn.close()
        
    async def process_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Process requests for best practices"""
        try:
            if data.get('type') == 'extract_best_practice':
                # Extract best practice from successful resolution
                issue = IssueRecord(**data['issue'])
                practice = await self.extract_best_practice(issue)
                return {
                    'agent_id': self.agent_id,
                    'practice_extracted': practice,
                    'issue_id': issue.issue_id
                }
                
            elif data.get('type') == 'recommend_practices':
                # Recommend practices for a given context
                context = data.get('context')
                recommendations = await self.recommend_practices(context)
                return {
                    'agent_id': self.agent_id,
                    'recommendations': recommendations,
                    'context': context
                }
                
            elif data.get('type') == 'validate_practice':
                # Validate practice effectiveness
                practice_id = data.get('practice_id')
                validation = await self.validate_practice_effectiveness(practice_id)
                return {
                    'agent_id': self.agent_id,
                    'validation': validation,
                    'practice_id': practice_id
                }
                
        except Exception as e:
            self.logger.error(f"Error processing data: {e}")
            return {'error': str(e)}
            
    async def extract_best_practice(self, issue: IssueRecord) -> Dict[str, Any]:
        """Extract best practice from successful issue resolution"""
        # Only extract if resolution was successful
        if not self.is_successful_resolution(issue):
            return None
            
        practice_id = f"practice_{issue.category.value}_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
        practice = BestPractice(
            practice_id=practice_id,
            title=f"Best Practice: {issue.category.value.title()} Resolution",
            description=f"Effective approach for {issue.description[:100]}...",
            category=issue.category,
            context_applicability=self.extract_context_applicability(issue),
            evidence_strength=self.calculate_evidence_strength(issue),
            implementation_steps=self.extract_implementation_steps(issue),
            success_metrics=self.extract_success_metrics(issue),
            challenges=self.extract_challenges(issue),
            resources_required=self.extract_resources_required(issue),
            source_projects=[issue.project_context.project_id],
            last_updated=datetime.now(),
            validation_count=1
        )
        
        # Store in database
        await self.store_best_practice(practice)
        
        return practice.__dict__
        
    def is_successful_resolution(self, issue: IssueRecord) -> bool:
        """Determine if issue resolution was successful"""
        # Check outcome indicators
        success_indicators = [
            'resolved', 'successful', 'completed', 'satisfied',
            'compliant', 'agreed', 'accepted', 'implemented'
        ]
        
        outcome_lower = issue.outcome.lower()
        return any(indicator in outcome_lower for indicator in success_indicators)
        
    def extract_context_applicability(self, issue: IssueRecord) -> List[str]:
        """Extract context where this practice applies"""
        context = []
        
        context.append(f"project_type:{issue.project_context.project_type.value}")
        context.append(f"scale:{issue.project_context.scale}")
        
        if issue.project_context.location.get('country'):
            context.append(f"region:{issue.project_context.location['country']}")
            
        for stakeholder in issue.stakeholders_affected:
            context.append(f"stakeholder:{stakeholder}")
            
        return context
        
    def calculate_evidence_strength(self, issue: IssueRecord) -> float:
        """Calculate strength of evidence for this practice"""
        evidence_score = 0.5  # Base score
        
        # Increase for documented outcomes
        if issue.outcome and len(issue.outcome) > 50:
            evidence_score += 0.1
            
        # Increase for cost/time impact data
        if issue.cost_impact is not None:
            evidence_score += 0.1
        if issue.time_impact is not None:
            evidence_score += 0.1
            
        # Increase for lessons learned
        if issue.lessons_learned and len(issue.lessons_learned) > 2:
            evidence_score += 0.2
            
        return min(evidence_score, 1.0)
        
    def extract_implementation_steps(self, issue: IssueRecord) -> List[str]:
        """Extract implementation steps from resolution approach"""
        steps = []
        
        # Parse resolution approach for steps
        resolution_text = issue.resolution_approach
        
        # Look for numbered steps or bullet points
        step_patterns = [
            r'(\d+\.\s*[^.]+\.)',  # "1. Step description."
            r'([•\-]\s*[^.]+\.)',  # "• Step description."
            r'(First[^.]+\.)',     # "First, do this."
            r'(Then[^.]+\.)',      # "Then, do that."
            r'(Finally[^.]+\.)'    # "Finally, complete."
        ]
        
        for pattern in step_patterns:
            matches = re.findall(pattern, resolution_text)
            steps.extend(matches)
            
        # If no structured steps found, create generic ones
        if not steps:
            steps = [
                "Assess the situation and stakeholders",
                "Develop response strategy",
                "Implement solution with stakeholder engagement",
                "Monitor and evaluate outcomes"
            ]
            
        return steps[:10]  # Limit to 10 steps
        
    def extract_success_metrics(self, issue: IssueRecord) -> List[str]:
        """Extract success metrics from issue resolution"""
        metrics = []
        
        # Standard metrics based on category
        category_metrics = {
            IssueCategory.RESETTLEMENT: [
                "Households successfully relocated",
                "Livelihood restoration achieved",
                "Community satisfaction > 80%"
            ],
            IssueCategory.ENVIRONMENTAL: [
                "Environmental parameters within limits",
                "Mitigation measures implemented",
                "Compliance with regulations"
            ],
            IssueCategory.COMMUNITY_ENGAGEMENT: [
                "Stakeholder participation rate",
                "Feedback incorporation rate",
                "Community agreement achieved"
            ],
            IssueCategory.GRIEVANCE: [
                "Resolution time < 30 days",
                "Complainant satisfaction",
                "No escalation to external parties"
            ]
        }
        
        metrics = category_metrics.get(issue.category, [
            "Issue resolved within timeline",
            "Stakeholder satisfaction achieved",
            "No recurrence of similar issues"
        ])
        
        # Add issue-specific metrics if available
        if issue.cost_impact is not None:
            metrics.append(f"Cost impact minimized (${issue.cost_impact:,.0f})")
        if issue.time_impact is not None:
            metrics.append(f"Time impact minimized ({issue.time_impact} days)")
            
        return metrics
        
    def extract_challenges(self, issue: IssueRecord) -> List[str]:
        """Extract challenges faced during resolution"""
        challenges = []
        
        # Extract from lessons learned
        for lesson in issue.lessons_learned:
            if any(word in lesson.lower() for word in ['challenge', 'difficult', 'obstacle', 'problem']):
                challenges.append(lesson)
                
        # Add common challenges if none found
        if not challenges:
            challenges = [
                "Stakeholder coordination complexity",
                "Resource allocation constraints",
                "Timeline pressures"
            ]
            
        return challenges
        
    def extract_resources_required(self, issue: IssueRecord) -> Dict[str, Any]:
        """Extract resources required for implementation"""
        resources = {
            'personnel': ['Project manager', 'Community liaison', 'Technical specialist'],
            'time': f"{issue.time_impact or 30} days",
            'budget': f"${issue.cost_impact or 50000:,.0f}",
            'tools': ['Database system', 'Communication platform', 'Monitoring tools'],
            'expertise': [issue.category.value, 'Stakeholder engagement', 'Project management']
        }
        
        return resources
        
    async def store_best_practice(self, practice: BestPractice):
        """Store best practice in database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT OR REPLACE INTO best_practices (
                practice_id, title, description, category, context_applicability,
                evidence_strength, implementation_steps, success_metrics, challenges,
                resources_required, source_projects, created_date, last_updated,
                validation_count, effectiveness_score
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            practice.practice_id, practice.title, practice.description,
            practice.category.value, json.dumps(practice.context_applicability),
            practice.evidence_strength, json.dumps(practice.implementation_steps),
            json.dumps(practice.success_metrics), json.dumps(practice.challenges),
            json.dumps(practice.resources_required), json.dumps(practice.source_projects),
            datetime.now().date(), practice.last_updated, practice.validation_count,
            0.5  # Initial effectiveness score
        ))
        
        conn.commit()
        conn.close()
        
    async def recommend_practices(self, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Recommend best practices for given context"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Get practices for the category
        category = context.get('category')
        cursor.execute('''
            SELECT practice_id, title, description, context_applicability,
                   evidence_strength, effectiveness_score, validation_count
            FROM best_practices
            WHERE category = ?
            ORDER BY effectiveness_score DESC, evidence_strength DESC
        ''', (category,))
        
        practices = cursor.fetchall()
        recommendations = []
        
        for practice_row in practices:
            practice_id, title, description, context_app_json, evidence, effectiveness, validation = practice_row
            context_applicability = json.loads(context_app_json)
            
            # Calculate context match
            match_score = self.calculate_context_match(context, context_applicability)
            
            if match_score > 0.3:  # Minimum relevance threshold
                recommendations.append({
                    'practice_id': practice_id,
                    'title': title,
                    'description': description,
                    'match_score': match_score,
                    'evidence_strength': evidence,
                    'effectiveness_score': effectiveness,
                    'validation_count': validation,
                    'relevance': 'high' if match_score > 0.7 else 'medium' if match_score > 0.5 else 'low'
                })
                
        conn.close()
        
        # Sort by combined score
        recommendations.sort(key=lambda x: x['match_score'] * x['effectiveness_score'], reverse=True)
        return recommendations[:10]  # Top 10 recommendations
        
    def calculate_context_match(self, request_context: Dict[str, Any], practice_context: List[str]) -> float:
        """Calculate how well practice context matches request context"""
        matches = 0
        total_checks = 0
        
        # Check project type
        if request_context.get('project_type'):
            total_checks += 1
            project_type_match = f"project_type:{request_context['project_type']}"
            if project_type_match in practice_context:
                matches += 1
                
        # Check scale
        if request_context.get('scale'):
            total_checks += 1
            scale_match = f"scale:{request_context['scale']}"
            if scale_match in practice_context:
                matches += 1
                
        # Check region/country
        if request_context.get('location', {}).get('country'):
            total_checks += 1
            region_match = f"region:{request_context['location']['country']}"
            if region_match in practice_context:
                matches += 1
                
        # Check stakeholders
        if request_context.get('stakeholders'):
            for stakeholder in request_context['stakeholders']:
                total_checks += 1
                stakeholder_match = f"stakeholder:{stakeholder}"
                if stakeholder_match in practice_context:
                    matches += 1
                    
        return matches / total_checks if total_checks > 0 else 0.0
        
    async def validate_practice_effectiveness(self, practice_id: str) -> Dict[str, Any]:
        """Validate effectiveness of a practice based on applications"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Get practice applications
        cursor.execute('''
            SELECT outcome, effectiveness_rating, feedback
            FROM practice_applications
            WHERE practice_id = ?
            AND implementation_date > date('now', '-365 days')
        ''', (practice_id,))
        
        applications = cursor.fetchall()
        
        if not applications:
            return {'validation': 'insufficient_data', 'applications_count': 0}
            
        # Calculate effectiveness metrics
        ratings = [app[1] for app in applications if app[1] is not None]
        avg_rating = np.mean(ratings) if ratings else 0
        
        # Analyze outcomes
        outcomes = [app[0] for app in applications if app[0]]
        positive_outcomes = sum(1 for outcome in outcomes 
                              if any(word in outcome.lower() 
                                   for word in ['success', 'resolved', 'effective', 'satisfied']))
        
        success_rate = positive_outcomes / len(outcomes) if outcomes else 0
        
        # Update practice effectiveness score
        effectiveness_score = (avg_rating / 5.0 * 0.6) + (success_rate * 0.4)
        
        cursor.execute('''
            UPDATE best_practices
            SET effectiveness_score = ?, validation_count = ?
            WHERE practice_id = ?
        ''', (effectiveness_score, len(applications), practice_id))
        
        conn.commit()
        conn.close()
        
        return {
            'validation': 'completed',
            'applications_count': len(applications),
            'average_rating': avg_rating,
            'success_rate': success_rate,
            'effectiveness_score': effectiveness_score,
            'recommendation': 'highly_recommended' if effectiveness_score > 0.8 
                            else 'recommended' if effectiveness_score > 0.6 
                            else 'use_with_caution' if effectiveness_score > 0.4 
                            else 'not_recommended'
        }

# =============================================================================
# Standards Evolution Agent
# =============================================================================

class StandardsEvolutionAgent(WisdomAgent):
    """Tracks evolution of standards and regulatory requirements"""
    
    def __init__(self, agent_id: str, config: Dict[str, Any]):
        super().__init__(agent_id, config)
        self.standards_cache = {}
        self.change_monitors = {}
        
    async def setup_database(self):
        """Setup standards tracking database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS standards_versions (
                version_id TEXT PRIMARY KEY,
                framework TEXT,
                version_number TEXT,
                release_date DATE,
                effective_date DATE,
                changes TEXT,  -- JSON
                impact_assessment TEXT,
                implementation_timeline DATE,
                status TEXT,  -- draft, final, effective, superseded
                source_url TEXT
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS standard_changes (
                change_id TEXT PRIMARY KEY,
                version_id TEXT,
                change_type TEXT,  -- addition, modification, deletion
                section TEXT,
                old_requirement TEXT,
                new_requirement TEXT,
                rationale TEXT,
                impact_level TEXT,  -- low, medium, high, critical
                affected_categories TEXT,  -- JSON list
                FOREIGN KEY (version_id) REFERENCES standards_versions(version_id)
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS compliance_gaps (
                gap_id TEXT PRIMARY KEY,
                project_id TEXT,
                standard_version TEXT,
                requirement TEXT,
                current_practice TEXT,
                gap_description TEXT,
                risk_level TEXT,
                remediation_needed TEXT,
                timeline_required INTEGER,
                identified_date DATE
            )
        ''')
        
        conn.commit()
        conn.close()
        
    async def process_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Process standards-related requests"""
        try:
            if data.get('type') == 'check_standards_updates':
                # Check for updates to standards
                framework = data.get('framework')
                updates = await self.check_for_updates(framework)
                return {
                    'agent_id': self.agent_id,
                    'framework': framework,
                    'updates': updates
                }
                
            elif data.get('type') == 'analyze_compliance_gap':
                # Analyze compliance gaps for a project
                project_context = data.get('project_context')
                gaps = await self.analyze_compliance_gaps(project_context)
                return {
                    'agent_id': self.agent_id,
                    'project_id': project_context.get('project_id'),
                    'compliance_gaps': gaps
                }
                
            elif data.get('type') == 'track_standard_change':
                # Track a new standard change
                change = data.get('change')
                result = await self.track_standard_change(change)
                return {
                    'agent_id': self.agent_id,
                    'change_tracked': result
                }
                
        except Exception as e:
            self.logger.error(f"Error processing data: {e}")
            return {'error': str(e)}
            
    async def check_for_updates(self, framework: str = None) -> List[Dict[str, Any]]:
        """Check for updates to standards (mock implementation)"""
        # In production, this would connect to actual standards bodies' APIs
        updates = []
        
        frameworks_to_check = [framework] if framework else ['IFC_PS', 'WORLD_BANK_ESS', 'EQUATOR_PRINCIPLES']
        
        for fw in frameworks_to_check:
            # Mock recent updates
            if fw == 'IFC_PS':
                updates.extend(await self.check_ifc_updates())
            elif fw == 'WORLD_BANK_ESS':
                updates.extend(await self.check_world_bank_updates())
            elif fw == 'EQUATOR_PRINCIPLES':
                updates.extend(await self.check_equator_updates())
                
        return updates
        
    async def check_ifc_updates(self) -> List[Dict[str, Any]]:
        """Check IFC Performance Standards updates"""
        # Mock implementation - in production, scrape IFC website or use API
        mock_updates = [
            {
                'framework': 'IFC_PS',
                'version': '2024.1',
                'release_date': '2024-06-01',
                'effective_date': '2025-01-01',
                'status': 'final',
                'major_changes': [
                    {
                        'performance_standard': 'PS5',
                        'section': 'Land Acquisition',
                        'change_type': 'modification',
                        'description': 'Enhanced requirements for indigenous peoples consultation',
                        'impact_level': 'high'
                    },
                    {
                        'performance_standard': 'PS1',
                        'section': 'Grievance Mechanism',
                        'change_type': 'addition',
                        'description': 'Digital grievance mechanism requirements',
                        'impact_level': 'medium'
                    }
                ]
            }
        ]
        
        # Store updates in database
        for update in mock_updates:
            await self.store_standards_update(update)
            
        return mock_updates
        
    async def check_world_bank_updates(self) -> List[Dict[str, Any]]:
        """Check World Bank ESS updates"""
        mock_updates = [
            {
                'framework': 'WORLD_BANK_ESS',
                'version': 'ESS_2024.2',
                'release_date': '2024-08-15',
                'effective_date': '2025-06-01',
                'status': 'draft',
                'major_changes': [
                    {
                        'ess_standard': 'ESS5',
                        'section': 'Resettlement Planning',
                        'change_type': 'modification',
                        'description': 'Updated livelihood restoration timeframes',
                        'impact_level': 'medium'
                    }
                ]
            }
        ]
        
        for update in mock_updates:
            await self.store_standards_update(update)
            
        return mock_updates
        
    async def check_equator_updates(self) -> List[Dict[str, Any]]:
        """Check Equator Principles updates"""
        mock_updates = [
            {
                'framework': 'EQUATOR_PRINCIPLES',
                'version': 'EP4_2024',
                'release_date': '2024-09-01',
                'effective_date': '2025-03-01',
                'status': 'final',
                'major_changes': [
                    {
                        'section': 'Climate Risk Assessment',
                        'change_type': 'addition',
                        'description': 'Mandatory climate risk disclosure requirements',
                        'impact_level': 'high'
                    }
                ]
            }
        ]
        
        for update in mock_updates:
            await self.store_standards_update(update)
            
        return mock_updates
        
    async def store_standards_update(self, update: Dict[str, Any]):
        """Store standards update in database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        version_id = f"{update['framework']}_{update['version']}"
        
        cursor.execute('''
            INSERT OR REPLACE INTO standards_versions (
                version_id, framework, version_number, release_date,
                effective_date, changes, status
            ) VALUES (?, ?, ?, ?, ?, ?, ?)
        ''', (
            version_id, update['framework'], update['version'],
            update['release_date'], update['effective_date'],
            json.dumps(update.get('major_changes', [])), update['status']
        ))
        
        # Store individual changes
        for change in update.get('major_changes', []):
            change_id = f"{version_id}_{hash(str(change))}"
            cursor.execute('''
                INSERT OR REPLACE INTO standard_changes (
                    change_id, version_id, change_type, section,
                    new_requirement, impact_level, affected_categories
                ) VALUES (?, ?, ?, ?, ?, ?, ?)
            ''', (
                change_id, version_id, change.get('change_type'),
                change.get('section'), change.get('description'),
                change.get('impact_level'), json.dumps([])
            ))
            
        conn.commit()
        conn.close()
        
    async def analyze_compliance_gaps(self, project_context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Analyze compliance gaps for a project"""
        gaps = []
        
        # Get applicable standards for project
        applicable_standards = await self.get_applicable_standards(project_context)
        
        for standard in applicable_standards:
            # Check current compliance level
            current_practices = project_context.get('current_practices', {})
            
            # Identify gaps
            standard_gaps = await self.identify_gaps(standard, current_practices, project_context)
            gaps.extend(standard_gaps)
            
        return gaps
        
    async def get_applicable_standards(self, project_context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Get standards applicable to project"""
        applicable = []
        
        # Determine applicable standards based on project characteristics
        project_type = project_context.get('project_type')
        location = project_context.get('location', {})
        financing = project_context.get('financing', [])
        
        # IFC PS applies to IFC-financed projects
        if 'IFC' in financing or 'ifc' in str(financing).lower():
            applicable.append({
                'framework': 'IFC_PS',
                'reason': 'IFC financing'
            })
            
        # World Bank ESS applies to World Bank projects
        if 'World Bank' in financing or 'world_bank' in str(financing).lower():
            applicable.append({
                'framework': 'WORLD_BANK_ESS',
                'reason': 'World Bank financing'
            })
            
        # Equator Principles for large projects
        project_scale = project_context.get('scale', '').lower()
        if project_scale in ['large', 'mega']:
            applicable.append({
                'framework': 'EQUATOR_PRINCIPLES',
                'reason': 'Large scale project'
            })
            
        # Add national regulations
        country = location.get('country')
        if country:
            applicable.append({
                'framework': 'NATIONAL_REGULATION',
                'country': country,
                'reason': 'National regulatory requirements'
            })
            
        return applicable
        
    async def identify_gaps(self, standard: Dict[str, Any], current_practices: Dict[str, Any], project_context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Identify specific compliance gaps"""
        gaps = []
        
        # Get latest version of standard
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT version_id, changes FROM standards_versions
            WHERE framework = ?
            AND status IN ('final', 'effective')
            ORDER BY effective_date DESC
            LIMIT 1
        ''', (standard['framework'],))
        
        result = cursor.fetchone()
        if not result:
            conn.close()
            return gaps
            
        version_id, changes_json = result
        changes = json.loads(changes_json)
        
        # Check each requirement
        for change in changes:
            gap = await self.check_requirement_compliance(
                change, current_practices, project_context, version_id
            )
            if gap:
                gaps.append(gap)
                
        conn.close()
        return gaps
        
    async def check_requirement_compliance(self, requirement: Dict[str, Any], 
                                         current_practices: Dict[str, Any], 
                                         project_context: Dict[str, Any],
                                         version_id: str) -> Optional[Dict[str, Any]]:
        """Check compliance with specific requirement"""
        
        # Extract requirement details
        section = requirement.get('section', '')
        description = requirement.get('description', '')
        impact_level = requirement.get('impact_level', 'medium')
        
        # Check if current practices address this requirement
        section_practices = current_practices.get(section.lower().replace(' ', '_'), {})
        
        # Simple compliance check (in production, use more sophisticated analysis)
        compliance_indicators = [
            'implemented', 'established', 'documented', 'approved',
            'compliant', 'meets', 'satisfies', 'addresses'
        ]
        
        is_compliant = any(indicator in str(section_practices).lower() 
                          for indicator in compliance_indicators)
        
        if not is_compliant:
            gap_id = f"gap_{version_id}_{hash(str(requirement))}"
            
            # Determine remediation needed
            remediation = await self.determine_remediation(requirement, project_context)
            
            return {
                'gap_id': gap_id,
                'project_id': project_context.get('project_id'),
                'standard_version': version_id,
                'requirement': description,
                'current_practice': str(section_practices),
                'gap_description': f"Current practices do not address: {description}",
                'risk_level': self.map_impact_to_risk(impact_level),
                'remediation_needed': remediation['actions'],
                'timeline_required': remediation['timeline_days'],
                'identified_date': datetime.now().date()
            }
            
        return None
        
    def map_impact_to_risk(self, impact_level: str) -> str:
        """Map impact level to risk level"""
        mapping = {
            'low': 'low',
            'medium': 'medium', 
            'high': 'high',
            'critical': 'very_high'
        }
        return mapping.get(impact_level, 'medium')
        
    async def determine_remediation(self, requirement: Dict[str, Any], project_context: Dict[str, Any]) -> Dict[str, Any]:
        """Determine remediation actions needed"""
        
        section = requirement.get('section', '').lower()
        impact_level = requirement.get('impact_level', 'medium')
        
        # Base remediation actions by section
        base_actions = {
            'land acquisition': [
                'Update resettlement action plan',
                'Conduct additional stakeholder consultation',
                'Revise compensation framework'
            ],
            'grievance mechanism': [
                'Establish digital grievance platform',
                'Train grievance committee',
                'Update grievance procedures'
            ],
            'climate risk': [
                'Conduct climate risk assessment',
                'Develop climate adaptation measures',
                'Update environmental management plan'
            ]
        }
        
        # Get relevant actions
        actions = []
        for key, action_list in base_actions.items():
            if key in section:
                actions.extend(action_list)
                
        # Default actions if none found
        if not actions:
            actions = [
                'Review requirement details',
                'Assess current compliance level',
                'Develop implementation plan',
                'Execute remediation measures'
            ]
            
        # Estimate timeline based on impact level
        timeline_map = {
            'low': 30,
            'medium': 60,
            'high': 90,
            'critical': 120
        }
        
        timeline_days = timeline_map.get(impact_level, 60)
        
        return {
            'actions': actions,
            'timeline_days': timeline_days,
            'priority': impact_level
        }
        
    async def track_standard_change(self, change: Dict[str, Any]) -> Dict[str, Any]:
        """Track a new standard change"""
        
        change_id = f"change_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
        # Store the change
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT INTO standard_changes (
                change_id, version_id, change_type, section,
                old_requirement, new_requirement, rationale,
                impact_level, affected_categories
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            change_id, change.get('version_id'), change.get('change_type'),
            change.get('section'), change.get('old_requirement'),
            change.get('new_requirement'), change.get('rationale'),
            change.get('impact_level'), json.dumps(change.get('affected_categories', []))
        ))
        
        conn.commit()
        conn.close()
        
        # Notify other agents about the change
        await self.send_message('all_agents', {
            'type': 'standard_change_notification',
            'change_id': change_id,
            'impact_level': change.get('impact_level'),
            'affected_categories': change.get('affected_categories', [])
        })
        
        return {
            'change_id': change_id,
            'status': 'tracked',
            'notification_sent': True
        }

# =============================================================================
# Peer Network Agent
# =============================================================================

class PeerNetworkAgent(WisdomAgent):
    """Manages peer network connections and expertise matching"""
    
    def __init__(self, agent_id: str, config: Dict[str, Any]):
        super().__init__(agent_id, config)
        self.peer_profiles = {}
        self.expertise_index = {}
        
    async def setup_database(self):
        """Setup peer network database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS peer_profiles (
                practitioner_id TEXT PRIMARY KEY,
                name TEXT,
                expertise TEXT,  -- JSON
                experience_years INTEGER,
                project_history TEXT,  -- JSON
                availability TEXT,
                contact_info TEXT,  -- JSON
                reputation_score REAL,
                response_rate REAL,
                last_active DATE,
                location TEXT,
                languages TEXT  -- JSON
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS peer_interactions (
                interaction_id TEXT PRIMARY KEY,
                requester_id TEXT,
                provider_id TEXT,
                request_type TEXT,
                expertise_area TEXT,
                request_date DATE,
                response_date DATE,
                response_quality_rating REAL,
                outcome TEXT,
                feedback TEXT
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS expertise_requests (
                request_id TEXT PRIMARY KEY,
                requester_id TEXT,
                expertise_needed TEXT,  -- JSON
                context TEXT,
                urgency TEXT,
                created_date DATE,
                status TEXT,  -- open, matched, closed
                matched_peers TEXT  -- JSON
            )
        ''')
        
        conn.commit()
        conn.close()
        
    async def process_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Process peer network requests"""
        try:
            if data.get('type') == 'find_expert':
                # Find expert for specific need
                expertise_needed = data.get('expertise_needed')
                context = data.get('context', {})
                experts = await self.find_matching_experts(expertise_needed, context)
                return {
                    'agent_id': self.agent_id,
                    'experts_found': experts,
                    'expertise_needed': expertise_needed
                }
                
            elif data.get('type') == 'register_peer':
                # Register new peer
                peer_info = data.get('peer_info')
                result = await self.register_peer(peer_info)
                return {
                    'agent_id': self.agent_id,
                    'registration_result': result
                }
                
            elif data.get('type') == 'update_reputation':
                # Update peer reputation based on interaction
                interaction_data = data.get('interaction_data')
                result = await self.update_peer_reputation(interaction_data)
                return {
                    'agent_id': self.agent_id,
                    'reputation_updated': result
                }
                
        except Exception as e:
            self.logger.error(f"Error processing data: {e}")
            return {'error': str(e)}
            
    async def find_matching_experts(self, expertise_needed: List[str], context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Find experts matching required expertise"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT practitioner_id, name, expertise, experience_years,
                   project_history, availability, reputation_score,
                   response_rate, location, languages
            FROM peer_profiles
            WHERE availability != 'unavailable'
            ORDER BY reputation_score DESC, response_rate DESC
        ''')
        
        peers = cursor.fetchall()
        matches = []
        
        for peer_row in peers:
            (practitioner_id, name, expertise_json, experience_years,
             project_history_json, availability, reputation_score,
             response_rate, location, languages_json) = peer_row
            
            expertise = json.loads(expertise_json)
            project_history = json.loads(project_history_json)
            languages = json.loads(languages_json) if languages_json else ['English']
            
            # Calculate match score
            match_score = self.calculate_expertise_match(
                expertise_needed, expertise, context, {
                    'experience_years': experience_years,
                    'project_history': project_history,
                    'location': location,
                    'languages': languages
                }
            )
            
            if match_score > 0.3:  # Minimum match threshold
                matches.append({
                    'practitioner_id': practitioner_id,
                    'name': name,
                    'expertise': expertise,
                    'experience_years': experience_years,
                    'match_score': match_score,
                    'reputation_score': reputation_score,
                    'response_rate': response_rate,
                    'availability': availability,
                    'location': location,
                    'languages': languages,
                    'recommendation_strength': self.get_recommendation_strength(match_score, reputation_score)
                })
                
        conn.close()
        
        # Sort by combined score
        matches.sort(key=lambda x: x['match_score'] * x['reputation_score'], reverse=True)
        return matches[:10]  # Top 10 matches
        
    def calculate_expertise_match(self, needed: List[str], available: List[str], 
                                context: Dict[str, Any], peer_info: Dict[str, Any]) -> float:
        """Calculate how well peer expertise matches needs"""
        
        # Direct expertise match
        needed_set = set([exp.lower() for exp in needed])
        available_set = set([exp.lower() for exp in available])
        
        direct_match = len(needed_set & available_set) / len(needed_set) if needed_set else 0
        
        # Context match factors
        context_bonus = 0.0
        
        # Project type experience
        if context.get('project_type'):
            project_type = context['project_type'].lower()
            for project in peer_info.get('project_history', []):
                if project_type in project.lower():
                    context_bonus += 0.1
                    break
                    
        # Geographic experience
        if context.get('location', {}).get('country'):
            country = context['location']['country'].lower()
            peer_location = peer_info.get('location', '').lower()
            if country in peer_location:
                context_bonus += 0.1
                
        # Language match
        context_languages = context.get('languages', ['English'])
        peer_languages = peer_info.get('languages', ['English'])
        if any(lang in peer_languages for lang in context_languages):
            context_bonus += 0.05
            
        # Experience level bonus
        experience_years = peer_info.get('experience_years', 0)
        if experience_years >= 10:
            context_bonus += 0.15
        elif experience_years >= 5:
            context_bonus += 0.1
            
        return min(direct_match + context_bonus, 1.0)
        
    def get_recommendation_strength(self, match_score: float, reputation_score: float) -> str:
        """Get recommendation strength based on scores"""
        combined_score = (match_score * 0.7) + (reputation_score * 0.3)
        
        if combined_score >= 0.8:
            return 'strongly_recommended'
        elif combined_score >= 0.6:
            return 'recommended'
        elif combined_score >= 0.4:
            return 'consider'
        else:
            return 'weak_match'
            
    async def register_peer(self, peer_info: Dict[str, Any]) -> Dict[str, Any]:
        """Register a new peer in the network"""
        
        practitioner_id = peer_info.get('practitioner_id') or f"peer_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT OR REPLACE INTO peer_profiles (
                practitioner_id, name, expertise, experience_years,
                project_history, availability, contact_info,
                reputation_score, response_rate, last_active,
                location, languages
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            practitioner_id,
            peer_info.get('name'),
            json.dumps(peer_info.get('expertise', [])),
            peer_info.get('experience_years', 0),
            json.dumps(peer_info.get('project_history', [])),
            peer_info.get('availability', 'available'),
            json.dumps(peer_info.get('contact_info', {})),
            0.5,  # Initial reputation score
            0.0,  # Initial response rate
            datetime.now().date(),
            peer_info.get('location', ''),
            json.dumps(peer_info.get('languages', ['English']))
        ))
        
        conn.commit()
        conn.close()
        
        # Update expertise index
        await self.update_expertise_index()
        
        return {
            'practitioner_id': practitioner_id,
            'status': 'registered',
            'message': 'Peer successfully registered in network'
        }
        
    async def update_expertise_index(self):
        """Update the expertise index for faster searches"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('SELECT practitioner_id, expertise FROM peer_profiles')
        peers = cursor.fetchall()
        
        # Rebuild expertise index
        self.expertise_index = defaultdict(list)
        
        for practitioner_id, expertise_json in peers:
            expertise_list = json.loads(expertise_json)
            for skill in expertise_list:
                self.expertise_index[skill.lower()].append(practitioner_id)
                
        conn.close()
        
    async def update_peer_reputation(self, interaction_data: Dict[str, Any]) -> Dict[str, Any]:
        """Update peer reputation based on interaction feedback"""
        
        provider_id = interaction_data.get('provider_id')
        quality_rating = interaction_data.get('response_quality_rating', 3.0)  # 1-5 scale
        response_time_hours = interaction_data.get('response_time_hours', 24)
        
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Get current reputation and response rate
        cursor.execute('''
            SELECT reputation_score, response_rate FROM peer_profiles
            WHERE practitioner_id = ?
        ''', (provider_id,))
        
        result = cursor.fetchone()
        if not result:
            conn.close()
            return {'error': 'Peer not found'}
            
        current_reputation, current_response_rate = result
        
        # Calculate new reputation (weighted average)
        # Quality rating contributes 70%, response time 30%
        quality_component = quality_rating / 5.0  # Normalize to 0-1
        response_time_component = max(0, 1 - (response_time_hours / 48))  # Penalty for slow response
        
        interaction_score = (quality_component * 0.7) + (response_time_component * 0.3)
        
        # Update reputation (moving average with more weight on recent interactions)
        new_reputation = (current_reputation * 0.8) + (interaction_score * 0.2)
        
        # Update response rate
        cursor.execute('''
            SELECT COUNT(*) FROM peer_interactions
            WHERE provider_id = ?
        ''', (provider_id,))
        
        total_interactions = cursor.fetchone()[0] + 1
        
        # Calculate response rate (assuming they responded if we're updating reputation)
        cursor.execute('''
            SELECT COUNT(*) FROM peer_interactions
            WHERE provider_id = ? AND response_date IS NOT NULL
        ''', (provider_id,))
        
        responses_count = cursor.fetchone()[0] + 1
        new_response_rate = responses_count / total_interactions
        
        # Update peer profile
        cursor.execute('''
            UPDATE peer_profiles
            SET reputation_score = ?, response_rate = ?, last_active = ?
            WHERE practitioner_id = ?
        ''', (new_reputation, new_response_rate, datetime.now().date(), provider_id))
        
        # Record the interaction
        interaction_id = f"interaction_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        cursor.execute('''
            INSERT INTO peer_interactions (
                interaction_id, requester_id, provider_id, request_type,
                expertise_area, request_date, response_date,
                response_quality_rating, outcome, feedback
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            interaction_id,
            interaction_data.get('requester_id'),
            provider_id,
            interaction_data.get('request_type'),
            interaction_data.get('expertise_area'),
            interaction_data.get('request_date'),
            datetime.now().date(),
            quality_rating,
            interaction_data.get('outcome'),
            interaction_data.get('feedback')
        ))
        
        conn.commit()
        conn.close()
        
        return {
            'provider_id': provider_id,
            'previous_reputation': current_reputation,
            'new_reputation': new_reputation,
            'previous_response_rate': current_response_rate,
            'new_response_rate': new_response_rate,
            'interaction_recorded': interaction_id
        }

# =============================================================================
# Knowledge Synthesis Agent
# =============================================================================

class KnowledgeSynthesisAgent(WisdomAgent):
    """Synthesizes insights from all agents into actionable guidance"""
    
    def __init__(self, agent_id: str, config: Dict[str, Any]):
        super().__init__(agent_id, config)
        self.synthesis_cache = {}
        self.guidance_templates = {}
        
    async def setup_database(self):
        """Setup knowledge synthesis database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS synthesis_reports (
                report_id TEXT PRIMARY KEY,
                report_type TEXT,
                context TEXT,  -- JSON
                patterns_analyzed TEXT,  -- JSON
                practices_reviewed TEXT,  -- JSON
                standards_checked TEXT,  -- JSON
                peer_input TEXT,  -- JSON
                synthesis_content TEXT,
                recommendations TEXT,  -- JSON
                confidence_score REAL,
                created_date DATE,
                last_updated DATE
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS guidance_documents (
                document_id TEXT PRIMARY KEY,
                title TEXT,
                category TEXT,
                content TEXT,
                source_reports TEXT,  -- JSON
                applicability_context TEXT,  -- JSON
                effectiveness_rating REAL,
                usage_count INTEGER,
                last_updated DATE
            )
        ''')
        
        conn.commit()
        conn.close()
        
    async def process_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Process synthesis requests"""
        try:
            if data.get('type') == 'synthesize_guidance':
                # Create comprehensive guidance
                context = data.get('context')
                guidance = await self.synthesize_comprehensive_guidance(context)
                return {
                    'agent_id': self.agent_id,
                    'guidance': guidance,
                    'context': context
                }
                
            elif data.get('type') == 'generate_report':
                # Generate synthesis report
                request = data.get('request')
                report = await self.generate_synthesis_report(request)
                return {
                    'agent_id': self.agent_id,
                    'report': report
                }
                
            elif data.get('type') == 'update_guidance':
                # Update existing guidance with new insights
                document_id = data.get('document_id')
                new_insights = data.get('insights')
                result = await self.update_guidance_document(document_id, new_insights)
                return {
                    'agent_id': self.agent_id,
                    'update_result': result
                }
                
        except Exception as e:
            self.logger.error(f"Error processing data: {e}")
            return {'error': str(e)}
            
    async def synthesize_comprehensive_guidance(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """Synthesize comprehensive guidance from all agent inputs"""
        
        # Gather data from all other agents
        patterns_data = await self.get_relevant_patterns(context)
        practices_data = await self.get_relevant_practices(context)
        standards_data = await self.get_relevant_standards(context)
        peer_data = await self.get_peer_insights(context)
        
        # Synthesize the information
        synthesis = await self.perform_synthesis(
            patterns_data, practices_data, standards_data, peer_data, context
        )
        
        # Generate recommendations
        recommendations = await self.generate_recommendations(synthesis, context)
        
        # Create comprehensive guidance document
        guidance = {
            'guidance_id': f"guidance_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
            'context': context,
            'executive_summary': synthesis.get('executive_summary'),
            'key_patterns': synthesis.get('key_patterns'),
            'recommended_practices': synthesis.get('recommended_practices'),
            'compliance_requirements': synthesis.get('compliance_requirements'),
            'expert_insights': synthesis.get('expert_insights'),
            'action_plan': recommendations.get('action_plan'),
            'risk_mitigation': recommendations.get('risk_mitigation'),
            'success_metrics': recommendations.get('success_metrics'),
            'implementation_timeline': recommendations.get('timeline'),
            'confidence_score': synthesis.get('confidence_score', 0.7),
            'created_date': datetime.now().isoformat()
        }
        
        # Store the guidance
        await self.store_guidance_document(guidance)
        
        return guidance
        
    async def get_relevant_patterns(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """Get relevant patterns from Pattern Recognition Agent"""
        # In a real implementation, this would send a message to the Pattern Recognition Agent
        # For now, we'll simulate the response
        
        category = context.get('category')
        project_type = context.get('project_type')
        
        # Mock pattern data
        patterns = [
            {
                'pattern_id': 'pattern_resettlement_consultation_delays',
                'description': 'Insufficient early consultation leads to resettlement delays',
                'frequency': 15,
                'severity_avg': 3.2,
                'confidence_score': 0.85
            },
            {
                'pattern_id': 'pattern_compensation_disputes',
                'description': 'Unclear compensation criteria cause community disputes',
                'frequency': 12,
                'severity_avg': 2.8,
                'confidence_score': 0.78
            }
        ]
        
        return {
            'patterns_found': patterns,
            'total_patterns': len(patterns),
            'high_confidence_patterns': [p for p in patterns if p['confidence_score'] > 0.8]
        }
        
    async def get_relevant_practices(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """Get relevant best practices from Best Practice Curator Agent"""
        
        # Mock practice data
        practices = [
            {
                'practice_id': 'practice_early_engagement',
                'title': 'Early and Continuous Stakeholder Engagement',
                'match_score': 0.92,
                'effectiveness_score': 0.88,
                'validation_count': 8
            },
            {
                'practice_id': 'practice_transparent_compensation',
                'title': 'Transparent Compensation Framework',
                'match_score': 0.87,
                'effectiveness_score': 0.82,
                'validation_count': 12
            }
        ]
        
        return {
            'recommended_practices': practices,
            'total_practices': len(practices),
            'high_effectiveness_practices': [p for p in practices if p['effectiveness_score'] > 0.8]
        }
        
    async def get_relevant_standards(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """Get relevant standards and compliance requirements"""
        
        # Mock standards data
        standards = [
            {
                'framework': 'IFC_PS',
                'version': '2024.1',
                'requirements': [
                    'Enhanced indigenous peoples consultation requirements',
                    'Digital grievance mechanism implementation'
                ],
                'compliance_gaps': [
                    'Current consultation process needs update for indigenous requirements'
                ]
            }
        ]
        
        return {
            'applicable_standards': standards,
            'compliance_gaps': sum(len(s.get('compliance_gaps', [])) for s in standards),
            'critical_updates': [s for s in standards if s.get('impact_level') == 'high']
        }
        
    async def get_peer_insights(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """Get insights from peer network"""
        
        # Mock peer insights
        insights = [
            {
                'expert_id': 'expert_resettlement_001',
                'expertise': 'Resettlement Planning',
                'insight': 'Early engagement with traditional leaders crucial for project success',
                'confidence': 0.9
            },
            {
                'expert_id': 'expert_social_002',
                'expertise': 'Social Impact Assessment',
                'insight': 'Digital tools improve grievance response times by 60%',
                'confidence': 0.85
            }
        ]
        
        return {
            'expert_insights': insights,
            'expert_count': len(insights),
            'high_confidence_insights': [i for i in insights if i['confidence'] > 0.8]
        }
        
    async def perform_synthesis(self, patterns_data: Dict, practices_data: Dict, 
                              standards_data: Dict, peer_data: Dict, 
                              context: Dict[str, Any]) -> Dict[str, Any]:
        """Perform the actual synthesis of all data sources"""
        
        # Extract key insights
        key_patterns = patterns_data.get('high_confidence_patterns', [])
        recommended_practices = practices_data.get('high_effectiveness_practices', [])
        compliance_requirements = []
        for standard in standards_data.get('applicable_standards', []):
            compliance_requirements.extend(standard.get('requirements', []))
        expert_insights = peer_data.get('high_confidence_insights', [])
        
        # Create executive summary
        executive_summary = self.create_executive_summary(
            key_patterns, recommended_practices, compliance_requirements, expert_insights, context
        )
        
        # Calculate overall confidence
        confidence_components = [
            patterns_data.get('total_patterns', 0) * 0.1,
            practices_data.get('total_practices', 0) * 0.1,
            len(compliance_requirements) * 0.05,
            peer_data.get('expert_count', 0) * 0.15
        ]
        
        confidence_score = min(sum(confidence_components) / 4, 1.0)
        
        return {
            'executive_summary': executive_summary,
            'key_patterns': key_patterns,
            'recommended_practices': recommended_practices,
            'compliance_requirements': compliance_requirements,
            'expert_insights': expert_insights,
            'confidence_score': confidence_score,
            'data_sources': {
                'patterns': len(key_patterns),
                'practices': len(recommended_practices),
                'standards': len(compliance_requirements),
                'experts': len(expert_insights)
            }
        }
        
    def create_executive_summary(self, patterns: List, practices: List, 
                               requirements: List, insights: List, 
                               context: Dict[str, Any]) -> str:
        """Create executive summary of synthesis"""
        
        category = context.get('category', 'project management')
        project_type = context.get('project_type', 'development project')
        
        summary_parts = []
        
        # Opening statement
        summary_parts.append(
            f"This guidance synthesizes institutional knowledge for {category} in {project_type} contexts."
        )
        
        # Pattern insights
        if patterns:
            high_freq_patterns = [p for p in patterns if p.get('frequency', 0) > 10]
            if high_freq_patterns:
                summary_parts.append(
                    f"Analysis reveals {len(high_freq_patterns)} frequently occurring patterns "
                    f"that require proactive management."
                )
                
        # Best practices
        if practices:
            high_eff_practices = [p for p in practices if p.get('effectiveness_score', 0) > 0.8]
            summary_parts.append(
                f"{len(high_eff_practices)} proven practices demonstrate high effectiveness "
                f"and are strongly recommended for implementation."
            )
            
        # Compliance
        if requirements:
            summary_parts.append(
                f"Current regulatory landscape includes {len(requirements)} key requirements "
                f"that must be addressed for compliance."
            )
            
        # Expert consensus
        if insights:
            summary_parts.append(
                f"Expert consensus from {len(insights)} practitioners emphasizes the importance "
                f"of early stakeholder engagement and transparent processes."
            )
            
        # Closing recommendation
        summary_parts.append(
            "Implementation of these recommendations should significantly reduce project risks "
            "and improve stakeholder outcomes."
        )
        
        return " ".join(summary_parts)
        
    async def generate_recommendations(self, synthesis: Dict[str, Any], 
                                     context: Dict[str, Any]) -> Dict[str, Any]:
        """Generate actionable recommendations from synthesis"""
        
        # Extract key information
        patterns = synthesis.get('key_patterns', [])
        practices = synthesis.get('recommended_practices', [])
        requirements = synthesis.get('compliance_requirements', [])
        insights = synthesis.get('expert_insights', [])
        
        # Generate action plan
        action_plan = await self.create_action_plan(patterns, practices, requirements, context)
        
        # Generate risk mitigation strategies
        risk_mitigation = await self.create_risk_mitigation_plan(patterns, insights)
        
        # Define success metrics
        success_metrics = await self.define_success_metrics(practices, context)
        
        # Create implementation timeline
        timeline = await self.create_implementation_timeline(action_plan, context)
        
        return {
            'action_plan': action_plan,
            'risk_mitigation': risk_mitigation,
            'success_metrics': success_metrics,
            'timeline': timeline
        }
        
    async def create_action_plan(self, patterns: List, practices: List, 
                               requirements: List, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Create detailed action plan"""
        
        actions = []
        
        # Actions based on patterns (prevention)
        for pattern in patterns[:3]:  # Top 3 patterns
            actions.append({
                'action': f"Implement preventive measures for: {pattern.get('description')}",
                'priority': 'high' if pattern.get('frequency', 0) > 12 else 'medium',
                'category': 'pattern_prevention',
                'timeline': '0-30 days',
                'responsible_party': 'Project Management Team',
                'resources_needed': ['Staff time', 'Training materials', 'Monitoring system']
            })
            
        # Actions based on best practices (implementation)
        for practice in practices[:3]:  # Top 3 practices
            actions.append({
                'action': f"Implement: {practice.get('title')}",
                'priority': 'high' if practice.get('effectiveness_score', 0) > 0.85 else 'medium',
                'category': 'best_practice_implementation',
                'timeline': '30-90 days',
                'responsible_party': 'Technical Specialists',
                'resources_needed': ['Budget allocation', 'Training', 'System setup']
            })
            
        # Actions based on compliance requirements
        for requirement in requirements[:2]:  # Top 2 requirements
            actions.append({
                'action': f"Ensure compliance with: {requirement}",
                'priority': 'critical',
                'category': 'compliance',
                'timeline': '0-60 days',
                'responsible_party': 'Compliance Team',
                'resources_needed': ['Legal review', 'Process update', 'Documentation']
            })
            
        return actions
        
    async def create_risk_mitigation_plan(self, patterns: List, insights: List) -> List[Dict[str, Any]]:
        """Create risk mitigation strategies"""
        
        risks = []
        
        # Risks from patterns
        for pattern in patterns:
            severity = pattern.get('severity_avg', 2.5)
            frequency = pattern.get('frequency', 0)
            
            risk_level = 'high' if severity > 3.0 and frequency > 10 else 'medium'
            
            risks.append({
                'risk': pattern.get('description'),
                'likelihood': 'high' if frequency > 10 else 'medium',
                'impact': 'high' if severity > 3.0 else 'medium',
                'risk_level': risk_level,
                'mitigation_strategy': f"Implement early warning system and preventive protocols",
                'monitoring_indicators': ['Stakeholder feedback', 'Timeline adherence', 'Cost variance'],
                'contingency_plan': 'Escalate to senior management and engage external specialists'
            })
            
        return risks
        
    async def define_success_metrics(self, practices: List, context: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Define success metrics for implementation"""
        
        metrics = []
        
        # Standard metrics
        standard_metrics = [
            {
                'metric': 'Stakeholder Satisfaction Score',
                'target': '> 80%',
                'measurement_method': 'Quarterly stakeholder surveys',
                'frequency': 'Quarterly'
            },
            {
                'metric': 'Compliance Rate',
                'target': '100%',
                'measurement_method': 'Regulatory compliance audits',
                'frequency': 'Semi-annually'
            },
            {
                'metric': 'Issue Resolution Time',
                'target': '< 30 days average',
                'measurement_method': 'Grievance tracking system',
                'frequency': 'Monthly'
            }
        ]
        
        metrics.extend(standard_metrics)
        
        # Practice-specific metrics
        for practice in practices[:2]:
            metrics.append({
                'metric': f"Implementation Success: {practice.get('title')}",
                'target': '> 85% implementation rate',
                'measurement_method': 'Implementation milestone tracking',
                'frequency': 'Monthly'
            })
            
        return metrics
        
    async def create_implementation_timeline(self, action_plan: List, context: Dict[str, Any]) -> Dict[str, Any]:
        """Create implementation timeline"""
        
        timeline = {
            'phase_1_immediate': {
                'duration': '0-30 days',
                'focus': 'Critical compliance and risk mitigation',
                'actions': [],
                'milestones': ['Compliance review completed', 'High-risk patterns addressed']
            },
            'phase_2_foundation': {
                'duration': '30-90 days',
                'focus': 'Core practice implementation',
                'actions': [],
                'milestones': ['Best practices implemented', 'Systems operational']
            },
            'phase_3_optimization': {
                'duration': '90-180 days',
                'focus': 'Monitoring and continuous improvement',
                'actions': [],
                'milestones': ['Metrics baseline established', 'Feedback loops operational']
            }
        }
        
        # Distribute actions across phases
        for action in action_plan:
            timeline_str = action.get('timeline', '30-90 days')
            
            if '0-30' in timeline_str:
                timeline['phase_1_immediate']['actions'].append(action)
            elif '30-90' in timeline_str:
                timeline['phase_2_foundation']['actions'].append(action)
            else:
                timeline['phase_3_optimization']['actions'].append(action)
                
        return timeline
        
    async def store_guidance_document(self, guidance: Dict[str, Any]):
        """Store synthesized guidance document"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT INTO guidance_documents (
                document_id, title, category, content,
                applicability_context, effectiveness_rating,
                usage_count, last_updated
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            guidance['guidance_id'],
            f"Comprehensive Guidance: {guidance['context'].get('category', 'General')}",
            guidance['context'].get('category', 'general'),
            json.dumps(guidance),
            json.dumps(guidance['context']),
            guidance.get('confidence_score', 0.7),
            0,
            datetime.now().date()
        ))
        
        conn.commit()
        conn.close()
        
    async def generate_synthesis_report(self, request: Dict[str, Any]) -> Dict[str, Any]:
        """Generate a comprehensive synthesis report"""
        
        report_id = f"report_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        context = request.get('context', {})
        
        # Gather comprehensive data
        all_data = {
            'patterns': await self.get_relevant_patterns(context),
            'practices': await self.get_relevant_practices(context),
            'standards': await self.get_relevant_standards(context),
            'peers': await self.get_peer_insights(context)
        }
        
        # Create comprehensive report
        report = {
            'report_id': report_id,
            'title': f"Knowledge Synthesis Report: {context.get('category', 'General Analysis')}",
            'executive_summary': '',
            'methodology': self.describe_methodology(),
            'findings': {
                'pattern_analysis': all_data['patterns'],
                'best_practices_review': all_data['practices'],
                'standards_compliance': all_data['standards'],
                'expert_consensus': all_data['peers']
            },
            'synthesis': await self.perform_synthesis(
                all_data['patterns'], all_data['practices'],
                all_data['standards'], all_data['peers'], context
            ),
            'recommendations': await self.generate_recommendations(
                await self.perform_synthesis(
                    all_data['patterns'], all_data['practices'],
                    all_data['standards'], all_data['peers'], context
                ), context
            ),
            'appendices': {
                'data_sources': all_data,
                'methodology_details': self.get_methodology_details(),
                'confidence_intervals': self.calculate_confidence_intervals(all_data)
            },
            'created_date': datetime.now().isoformat(),
            'context': context
        }
        
        # Store report
        await self.store_synthesis_report(report)
        
        return report
        
    def describe_methodology(self) -> str:
        """Describe the synthesis methodology"""
        return (
            "This synthesis employs a multi-agent knowledge aggregation approach, "
            "combining pattern recognition from historical project data, "
            "validated best practices from successful implementations, "
            "current regulatory requirements analysis, and expert practitioner insights. "
            "Each data source is weighted based on evidence strength and relevance to context."
        )
        
    def get_methodology_details(self) -> Dict[str, Any]:
        """Get detailed methodology information"""
        return {
            'pattern_recognition': {
                'data_sources': 'Historical project databases, issue tracking systems',
                'analysis_method': 'Statistical clustering and similarity matching',
                'confidence_threshold': 0.7
            },
            'best_practices': {
                'validation_criteria': 'Evidence strength, implementation success rate, peer validation',
                'effectiveness_threshold': 0.6,
                'context_matching': 'Multi-dimensional similarity scoring'
            },
            'standards_analysis': {
                'frameworks_monitored': ['IFC PS', 'World Bank ESS', 'Equator Principles'],
                'update_frequency': 'Real-time monitoring with quarterly reviews',
                'gap_analysis': 'Automated compliance checking against current practices'
            },
            'expert_insights': {
                'network_size': 'Global network of 500+ practitioners',
                'expertise_verification': 'Peer review and reputation scoring',
                'consensus_threshold': 'Minimum 3 expert agreement for inclusion'
            }
        }
        
    def calculate_confidence_intervals(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Calculate confidence intervals for synthesis"""
        return {
            'pattern_confidence': {
                'high_confidence': len([p for p in data['patterns'].get('patterns_found', []) 
                                      if p.get('confidence_score', 0) > 0.8]),
                'medium_confidence': len([p for p in data['patterns'].get('patterns_found', []) 
                                        if 0.6 <= p.get('confidence_score', 0) <= 0.8]),
                'overall_confidence': 0.75
            },
            'practice_confidence': {
                'validated_practices': len([p for p in data['practices'].get('recommended_practices', []) 
                                          if p.get('validation_count', 0) > 5]),
                'effectiveness_confidence': 0.82
            },
            'synthesis_confidence': 0.78
        }
        
    async def store_synthesis_report(self, report: Dict[str, Any]):
        """Store synthesis report in database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT INTO synthesis_reports (
                report_id, report_type, context, patterns_analyzed,
                practices_reviewed, standards_checked, peer_input,
                synthesis_content, recommendations, confidence_score,
                created_date, last_updated
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            report['report_id'],
            'comprehensive_synthesis',
            json.dumps(report['context']),
            json.dumps(report['findings']['pattern_analysis']),
            json.dumps(report['findings']['best_practices_review']),
            json.dumps(report['findings']['standards_compliance']),
            json.dumps(report['findings']['expert_consensus']),
            json.dumps(report['synthesis']),
            json.dumps(report['recommendations']),
            report['synthesis'].get('confidence_score', 0.7),
            datetime.now().date(),
            datetime.now().date()
        ))
        
        conn.commit()
        conn.close()

# =============================================================================
# Wisdom Syndicate Orchestrator
# =============================================================================

class WisdomSyndicateOrchestrator:
    """Orchestrates all Wisdom Syndicate agents"""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.agents = {}
        self.message_broker = asyncio.Queue()
        self.is_running = False
        
        # Initialize all agents
        self.agents = {
            'pattern_recognition': PatternRecognitionAgent('pattern_recognition', config),
            'best_practice_curator': BestPracticeCuratorAgent('best_practice_curator', config),
            'standards_evolution': StandardsEvolutionAgent('standards_evolution', config),
            'peer_network': PeerNetworkAgent('peer_network', config),
            'knowledge_synthesis': KnowledgeSynthesisAgent('knowledge_synthesis', config)
        }
        
        self.logger = logging.getLogger('wisdom_syndicate.orchestrator')
        
    async def start_all_agents(self):
        """Start all agents in the syndicate"""
        self.logger.info("Starting Wisdom Syndicate...")
        
        # Start all agents concurrently
        agent_tasks = []
        for agent_name, agent in self.agents.items():
            task = asyncio.create_task(agent.start())
            agent_tasks.append(task)
            self.logger.info(f"Started agent: {agent_name}")
            
        self.is_running = True
        self.logger.info("All Wisdom Syndicate agents started successfully")
        
        # Start message broker
        await self.start_message_broker()
        
    async def stop_all_agents(self):
        """Stop all agents"""
        self.logger.info("Stopping Wisdom Syndicate...")
        
        for agent_name, agent in self.agents.items():
            await agent.stop()
            self.logger.info(f"Stopped agent: {agent_name}")
            
        self.is_running = False
        self.logger.info("Wisdom Syndicate stopped")
        
    async def start_message_broker(self):
        """Start the message broker for inter-agent communication"""
        while self.is_running:
            try:
                # Process messages between agents
                # In production, this would use Redis, RabbitMQ, or similar
                await asyncio.sleep(1)  # Message processing interval
            except Exception as e:
                self.logger.error(f"Error in message broker: {e}")
                
    async def process_issue(self, issue: IssueRecord) -> Dict[str, Any]:
        """Process a new issue through the entire syndicate"""
        self.logger.info(f"Processing issue: {issue.issue_id}")
        
        results = {}
        
        # Step 1: Pattern Recognition
        pattern_result = await self.agents['pattern_recognition'].process_data({
            'type': 'new_issue',
            'issue': issue.__dict__
        })
        results['patterns'] = pattern_result
        
        # Step 2: Extract Best Practice (if successful resolution)
        if hasattr(issue, 'outcome') and 'success' in issue.outcome.lower():
            practice_result = await self.agents['best_practice_curator'].process_data({
                'type': 'extract_best_practice',
                'issue': issue.__dict__
            })
            results['practice_extraction'] = practice_result
            
        # Step 3: Check Standards Compliance
        standards_result = await self.agents['standards_evolution'].process_data({
            'type': 'analyze_compliance_gap',
            'project_context': issue.project_context.__dict__
        })
        results['standards_analysis'] = standards_result
        
        # Step 4: Find Relevant Experts
        if issue.severity.value >= 3:  # High severity issues
            peer_result = await self.agents['peer_network'].process_data({
                'type': 'find_expert',
                'expertise_needed': [issue.category.value],
                'context': {
                    'project_type': issue.project_context.project_type.value,
                    'location': issue.project_context.location,
                    'urgency': 'high' if issue.severity.value >= 4 else 'medium'
                }
            })
            results['expert_matching'] = peer_result
            
        # Step 5: Synthesize Comprehensive Guidance
        synthesis_result = await self.agents['knowledge_synthesis'].process_data({
            'type': 'synthesize_guidance',
            'context': {
                'category': issue.category.value,
                'project_type': issue.project_context.project_type.value,
                'location': issue.project_context.location,
                'severity': issue.severity.value,
                'issue_id': issue.issue_id
            }
        })
        results['synthesis'] = synthesis_result
        
        self.logger.info(f"Completed processing issue: {issue.issue_id}")
        return results
        
    async def generate_comprehensive_report(self, context: Dict[str, Any]) -> Dict[str, Any]:
        """Generate a comprehensive knowledge synthesis report"""
        self.logger.info("Generating comprehensive report")
        
        # Get comprehensive synthesis from Knowledge Synthesis Agent
        report = await self.agents['knowledge_synthesis'].process_data({
            'type': 'generate_report',
            'request': {
                'context': context,
                'include_appendices': True,
                'detail_level': 'comprehensive'
            }
        })
        
        return report
        
    async def monitor_standards_updates(self):
        """Monitor for standards updates across all frameworks"""
        self.logger.info("Monitoring standards updates")
        
        frameworks = ['IFC_PS', 'WORLD_BANK_ESS', 'EQUATOR_PRINCIPLES']
        
        for framework in frameworks:
            updates = await self.agents['standards_evolution'].process_data({
                'type': 'check_standards_updates',
                'framework': framework
            })
            
            if updates.get('updates'):
                self.logger.info(f"Found {len(updates['updates'])} updates for {framework}")
                
                # Notify other agents about updates
                for agent_name, agent in self.agents.items():
                    if agent_name != 'standards_evolution':
                        await agent.message_queue.put({
                            'type': 'standards_update_notification',
                            'framework': framework,
                            'updates': updates['updates']
                        })
                        
        return updates
        
    async def health_check(self) -> Dict[str, Any]:
        """Perform health check on all agents"""
        health_status = {
            'syndicate_status': 'healthy',
            'agents': {},
            'timestamp': datetime.now().isoformat()
        }
        
        for agent_name, agent in self.agents.items():
            try:
                # Send health check message
                await agent.message_queue.put({'type': 'health_check'})
                
                # Wait for response (simplified - in production use proper messaging)
                health_status['agents'][agent_name] = {
                    'status': 'healthy',
                    'last_activity': datetime.now().isoformat(),
                    'queue_size': agent.message_queue.qsize()
                }
            except Exception as e:
                health_status['agents'][agent_name] = {
                    'status': 'unhealthy',
                    'error': str(e)
                }
                health_status['syndicate_status'] = 'degraded'
                
        return health_status
        
    def get_syndicate_statistics(self) -> Dict[str, Any]:
        """Get overall syndicate performance statistics"""
        
        # In production, these would come from actual database queries
        stats = {
            'total_patterns_identified': 150,
            'best_practices_curated': 89,
            'standards_versions_tracked': 12,
            'peer_network_size': 247,
            'synthesis_reports_generated': 34,
            'average_processing_time_seconds': 2.3,
            'system_uptime_hours': 720,
            'confidence_score_average': 0.78
        }
        
        return stats

# =============================================================================
# Example Usage and Testing
# =============================================================================

async def main():
    """Example usage of the Wisdom Syndicate"""
    
    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    
    # Initialize configuration
    config = {
        'db_path': 'wisdom_syndicate.db',
        'log_level': 'INFO',
        'enable_real_time_monitoring': True
    }
    
    # Create and start the Wisdom Syndicate
    syndicate = WisdomSyndicateOrchestrator(config)
    
    try:
        # Start all agents
        await syndicate.start_all_agents()
        
        # Example: Process a new issue
        example_issue = IssueRecord(
            issue_id="issue_001",
            project_context=ProjectContext(
                project_id="proj_mozambique_lng",
                project_type=ProjectType.OIL_GAS,
                location={'country': 'Mozambique', 'region': 'Cabo Delgado'},
                scale="mega",
                timeline={'start': datetime(2020, 1, 1), 'completion': datetime(2025, 12, 31)},
                stakeholders=['Local communities', 'Government', 'NGOs'],
                regulatory_framework=[StandardsFramework.IFC_PS, StandardsFramework.EQUATOR_PRINCIPLES],
                environmental_context={'marine': True, 'protected_areas': True},
                social_context={'indigenous_peoples': True, 'fishing_communities': True},
                economic_context={'major_employer': True, 'export_revenue': True}
            ),
            category=IssueCategory.RESETTLEMENT,
            severity=IssueSeverity.HIGH,
            description="Delays in resettlement process due to insufficient consultation with traditional leaders",
            root_causes=[
                "Inadequate stakeholder mapping",
                "Cultural protocols not followed",
                "Language barriers in consultation"
            ],
            timeline={'identified': datetime.now(), 'resolved': datetime.now() + timedelta(days=45)},
            stakeholders_affected=['Fishing communities', 'Traditional leaders'],
            resolution_approach="Enhanced consultation process with cultural mediators",
            outcome="Successful agreement reached with community leaders",
            lessons_learned=[
                "Early engagement with traditional authorities is crucial",
                "Cultural protocols must be understood and respected",
                "Local language capacity is essential"
            ],
            cost_impact=150000,
            time_impact=30,
            tags=['consultation', 'traditional_leaders', 'cultural_sensitivity']
        )
        
        # Process the issue through the syndicate
        print("Processing example issue...")
        results = await syndicate.process_issue(example_issue)
        
        print(f"Pattern analysis found {len(results.get('patterns', {}).get('patterns_found', []))} relevant patterns")
        print(f"Synthesis confidence: {results.get('synthesis', {}).get('guidance', {}).get('confidence_score', 0):.2f}")
        
        # Generate comprehensive report
        print("\nGenerating comprehensive report...")
        report = await syndicate.generate_comprehensive_report({
            'category': 'resettlement',
            'project_type': 'oil_gas',
            'location': {'country': 'Mozambique'},
            'analysis_timeframe': 'last_2_years'
        })
        
        print(f"Report generated: {report.get('report', {}).get('title', 'Unknown')}")
        
        # Check system health
        health = await syndicate.health_check()
        print(f"\nSystem health: {health['syndicate_status']}")
        
        # Get statistics
        stats = syndicate.get_syndicate_statistics()
        print(f"Patterns identified: {stats['total_patterns_identified']}")
        print(f"Best practices curated: {stats['best_practices_curated']}")
        print(f"Peer network size: {stats['peer_network_size']}")
        
        # Monitor for standards updates
        print("\nChecking for standards updates...")
        await syndicate.monitor_standards_updates()
        
    except Exception as e:
        print(f"Error running syndicate: {e}")
        
    finally:
        # Clean shutdown
        await syndicate.stop_all_agents()

if __name__ == "__main__":
    # Run the example
    asyncio.run(main())