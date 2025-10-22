# app.py - Flask backend for Community Voice Agent
from flask import Flask, render_template, request, jsonify, send_from_directory
from flask_cors import CORS
import json
import sqlite3
import os
import uuid
import datetime
from typing import Dict, Any, List
import logging

app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CommunityVoiceBackend:
    def __init__(self, db_path='grievances.db'):
        self.db_path = db_path
        self.init_database()
        
    def init_database(self):
        """Initialize SQLite database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS grievances (
                id TEXT PRIMARY KEY,
                type TEXT,
                content TEXT,
                language_hint TEXT,
                processed_content TEXT,
                classification TEXT,
                urgency TEXT,
                routing_recommendation TEXT,
                status TEXT DEFAULT 'New',
                metadata TEXT,
                timestamp TEXT,
                created_at DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        conn.commit()
        conn.close()
        
    def process_grievance(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Process a grievance submission"""
        grievance_id = str(uuid.uuid4())
        
        # Extract content based on type
        content = data.get('content', '')
        if data.get('type') == 'audio':
            content = '[Audio content recorded]'
        elif data.get('type') == 'image':
            content = '[Image content uploaded]'
            
        # Process content (mock translation)
        processed_content = self.process_content(content, data.get('language_hint'))
        
        # Classify grievance
        classification = self.classify_grievance(processed_content)
        
        # Assess urgency
        urgency = self.assess_urgency(processed_content)
        
        # Recommend routing
        routing = self.recommend_routing(classification, urgency)
        
        # Create processed grievance
        processed = {
            'id': grievance_id,
            'type': data.get('type'),
            'content': content,
            'language_hint': data.get('language_hint'),
            'processed_content': processed_content,
            'classification': classification,
            'urgency': urgency,
            'routing_recommendation': routing,
            'status': 'New',
            'metadata': data.get('metadata', {}),
            'timestamp': datetime.datetime.now().isoformat()
        }
        
        # Store in database
        self.store_grievance(processed)
        
        return processed
        
    def process_content(self, content: str, language_hint: str) -> str:
        """Mock content processing with translation"""
        if language_hint and language_hint not in ['english', 'auto']:
            return f"[Translated from {language_hint}]: {content}"
        return content
        
    def classify_grievance(self, content: str) -> str:
        """Classify grievance based on content"""
        content_lower = content.lower()
        
        # Custom categories
        if 'water contamination' in content_lower or 'polluted water' in content_lower:
            return 'Water Contamination Specific'
        if 'noise pollution' in content_lower or 'loud sound' in content_lower:
            return 'Noise Pollution Residential'
            
        # Standard categories
        if any(word in content_lower for word in ['pollution', 'dust', 'effluent', 'habitat', 'environmental']):
            return 'Environmental Damage'
        if any(word in content_lower for word in ['land', 'resettlement', 'compensation', 'displaced', 'boundary']):
            return 'Land Dispute / Resettlement'
        if any(word in content_lower for word in ['wage', 'worker', 'labor', 'safety', 'discrimination']):
            return 'Labor & Working Conditions'
        if any(word in content_lower for word in ['health', 'safety', 'security', 'community', 'disease']):
            return 'Community Health & Safety'
        if any(word in content_lower for word in ['access', 'services', 'water supply', 'electricity', 'road']):
            return 'Access to Resources / Services'
            
        return 'Other (General Inquiry/Feedback)'
        
    def assess_urgency(self, content: str) -> str:
        """Assess urgency level"""
        content_lower = content.lower()
        
        if any(word in content_lower for word in ['urgent', 'emergency', 'immediate', 'critical', 'danger']):
            return 'High'
        if any(word in content_lower for word in ['serious', 'harm', 'illness', 'delay', 'problem', 'issue']):
            return 'Medium'
        return 'Low'
        
    def recommend_routing(self, classification: str, urgency: str) -> List[str]:
        """Recommend routing based on classification and urgency"""
        recommendations = []
        
        if classification in ['Environmental Damage', 'Water Contamination Specific', 'Noise Pollution Residential']:
            recommendations.append('Environmental Team')
            
        if classification in ['Land Dispute / Resettlement', 'Community Health & Safety', 'Access to Resources / Services']:
            recommendations.append('Social Performance Team')
            
        if classification == 'Labor & Working Conditions':
            recommendations.append('HR / Labor Relations')
            
        if urgency == 'High':
            recommendations.append('Senior Management')
            
        return recommendations if recommendations else ['General Support Team']
        
    def store_grievance(self, grievance: Dict[str, Any]):
        """Store grievance in database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            INSERT INTO grievances 
            (id, type, content, language_hint, processed_content, classification, 
             urgency, routing_recommendation, status, metadata, timestamp)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            grievance['id'],
            grievance['type'],
            grievance['content'],
            grievance['language_hint'],
            grievance['processed_content'],
            grievance['classification'],
            grievance['urgency'],
            json.dumps(grievance['routing_recommendation']),
            grievance['status'],
            json.dumps(grievance['metadata']),
            grievance['timestamp']
        ))
        
        conn.commit()
        conn.close()
        
    def get_dashboard_stats(self) -> Dict[str, int]:
        """Get dashboard statistics"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        # Total grievances
        cursor.execute('SELECT COUNT(*) FROM grievances')
        total = cursor.fetchone()[0]
        
        # High urgency grievances
        cursor.execute('SELECT COUNT(*) FROM grievances WHERE urgency = ?', ('High',))
        high_urgency = cursor.fetchone()[0]
        
        # Pending grievances
        cursor.execute('SELECT COUNT(*) FROM grievances WHERE status = ?', ('New',))
        pending = cursor.fetchone()[0]
        
        # Resolved grievances
        cursor.execute('SELECT COUNT(*) FROM grievances WHERE status = ?', ('Resolved',))
        resolved = cursor.fetchone()[0]
        
        conn.close()
        
        return {
            'total': total,
            'high_urgency': high_urgency,
            'pending': pending,
            'resolved': resolved
        }
        
    def get_recent_grievances(self, limit: int = 10) -> List[Dict[str, Any]]:
        """Get recent grievances"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            SELECT * FROM grievances 
            ORDER BY created_at DESC 
            LIMIT ?
        ''', (limit,))
        
        rows = cursor.fetchall()
        columns = [description[0] for description in cursor.description]
        
        grievances = []
        for row in rows:
            grievance = dict(zip(columns, row))
            # Parse JSON fields
            grievance['routing_recommendation'] = json.loads(grievance['routing_recommendation'])
            grievance['metadata'] = json.loads(grievance['metadata'])
            grievances.append(grievance)
            
        conn.close()
        return grievances

# Initialize backend
backend = CommunityVoiceBackend()

@app.route('/')
def index():
    """Serve the main application"""
    return send_from_directory('.', 'index.html')

@app.route('/api/submit_grievance', methods=['POST'])
def submit_grievance():
    """Handle grievance submission"""
    try:
        data = request.get_json()
        result = backend.process_grievance(data)
        return jsonify({'status': 'success', 'data': result})
    except Exception as e:
        logger.error(f"Error processing grievance: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/api/dashboard_stats')
def dashboard_stats():
    """Get dashboard statistics"""
    try:
        stats = backend.get_dashboard_stats()
        return jsonify({'status': 'success', 'data': stats})
    except Exception as e:
        logger.error(f"Error getting dashboard stats: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/api/recent_grievances')
def recent_grievances():
    """Get recent grievances"""
    try:
        limit = request.args.get('limit', 10, type=int)
        grievances = backend.get_recent_grievances(limit)
        return jsonify({'status': 'success', 'data': grievances})
    except Exception as e:
        logger.error(f"Error getting recent grievances: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/api/sample_grievances', methods=['POST'])
def load_sample_grievances():
    """Load sample grievances for demonstration"""
    sample_grievances = [
        {
            "type": "text",
            "content": "Our crops are dying because the local stream has become contaminated with a strange white foam from the nearby processing plant. We need help immediately!",
            "language_hint": "english",
            "metadata": {
                "sender_name": "Farmer Sipho",
                "contact_info": "+27821112222",
                "location": "Green Valley Farm"
            }
        },
        {
            "type": "text", 
            "content": "Land dispute still not resolved. Our families are being pushed out. Please intervene.",
            "language_hint": "english",
            "metadata": {
                "sender_name": "Community Representative",
                "contact_info": "+27719876543"
            }
        },
        {
            "type": "text",
            "content": "Urgent: There is severe water contamination in our well from the new drilling site.",
            "language_hint": "english",
            "metadata": {
                "urgency_level_user_reported": "High"
            }
        },
        {
            "type": "sms",
            "content": "Loud blasting noise at 3 AM. Affecting sleep and children's health.",
            "language_hint": "english",
            "metadata": {
                "submission_channel": "sms"
            }
        }
    ]
    
    try:
        results = []
        for grievance in sample_grievances:
            result = backend.process_grievance(grievance)
            results.append(result)
            
        return jsonify({'status': 'success', 'data': results})
    except Exception as e:
        logger.error(f"Error loading sample grievances: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

if __name__ == '__main__':
    # Ensure data directory exists
    os.makedirs('data', exist_ok=True)
    
    # Run the application
    app.run(debug=True, host='0.0.0.0', port=5000)