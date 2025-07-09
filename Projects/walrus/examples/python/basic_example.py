#!/usr/bin/env python3
"""
Basic Walrus Blob Storage Example using HTTP API

This example demonstrates how to:
1. Store a blob using the Publisher API
2. Retrieve a blob using the Aggregator API
3. Handle errors and check blob status
"""

import json
import time
import sys
import os
from datetime import datetime
from typing import Optional, Dict, Any

import requests
from requests.exceptions import RequestException

# Configuration
PUBLISHER_URL = "https://publisher.testnet.walrus.space"
AGGREGATOR_URL = "https://aggregator.testnet.walrus.space"
DEFAULT_EPOCHS = 3

class WalrusClient:
    """Simple Walrus client using HTTP API"""
    
    def __init__(self, publisher_url: str = PUBLISHER_URL, aggregator_url: str = AGGREGATOR_URL):
        self.publisher_url = publisher_url.rstrip('/')
        self.aggregator_url = aggregator_url.rstrip('/')
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Walrus-Learning-Client/1.0'
        })
    
    def store_blob(self, data: bytes, epochs: int = DEFAULT_EPOCHS) -> Dict[str, Any]:
        """Store a blob and return the blob ID and other metadata"""
        print(f"📝 Storing blob ({len(data)} bytes) for {epochs} epochs...")
        
        try:
            # Prepare the request
            url = f"{self.publisher_url}/v1/store"
            params = {"epochs": epochs}
            
            # Send the blob data
            response = self.session.put(
                url,
                params=params,
                data=data,
                headers={'Content-Type': 'application/octet-stream'},
                timeout=30
            )
            
            response.raise_for_status()
            result = response.json()
            
            print(f"✅ Blob stored successfully!")
            print(f"📋 Blob ID: {result.get('blobId', 'Unknown')}")
            
            return result
            
        except RequestException as e:
            print(f"❌ Error storing blob: {e}")
            if hasattr(e, 'response') and e.response is not None:
                print(f"   Status: {e.response.status_code}")
                print(f"   Response: {e.response.text}")
            raise
    
    def retrieve_blob(self, blob_id: str) -> bytes:
        """Retrieve a blob by its ID"""
        print(f"📥 Retrieving blob: {blob_id}")
        
        try:
            url = f"{self.aggregator_url}/v1/{blob_id}"
            
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            
            print(f"✅ Blob retrieved successfully! ({len(response.content)} bytes)")
            return response.content
            
        except RequestException as e:
            print(f"❌ Error retrieving blob: {e}")
            if hasattr(e, 'response') and e.response is not None:
                print(f"   Status: {e.response.status_code}")
                print(f"   Response: {e.response.text}")
            raise
    
    def check_blob_status(self, blob_id: str) -> Dict[str, Any]:
        """Check the status of a blob"""
        try:
            url = f"{self.aggregator_url}/v1/{blob_id}"
            
            response = self.session.head(url, timeout=10)
            response.raise_for_status()
            
            return {
                'exists': True,
                'size': int(response.headers.get('content-length', 0)),
                'content_type': response.headers.get('content-type', 'unknown')
            }
            
        except RequestException as e:
            if hasattr(e, 'response') and e.response is not None and e.response.status_code == 404:
                return {'exists': False}
            raise

def create_sample_data() -> bytes:
    """Create sample data for testing"""
    data = {
        "message": "Hello from Walrus Python example!",
        "timestamp": datetime.now().isoformat(),
        "author": "Walrus Learning Repository",
        "data": {
            "numbers": [1, 2, 3, 4, 5],
            "nested": {
                "value": "This is nested data from Python",
                "active": True,
                "python_version": sys.version
            }
        },
        "metadata": {
            "example_type": "basic_python_example",
            "encoding": "utf-8",
            "language": "python"
        }
    }
    
    return json.dumps(data, indent=2).encode('utf-8')

def main():
    """Main function demonstrating Walrus blob operations"""
    print("🌊 Walrus Python Basic Example - Store and Retrieve Blob")
    print("========================================================\n")
    
    # Initialize client
    client = WalrusClient()
    
    try:
        # Create sample data
        sample_data = create_sample_data()
        print(f"📊 Sample data created ({len(sample_data)} bytes)")
        
        # Store the blob
        store_result = client.store_blob(sample_data, epochs=3)
        blob_id = store_result.get('blobId')
        
        if not blob_id:
            print("❌ Failed to get blob ID from store result")
            return
        
        print(f"📏 Original size: {len(sample_data)} bytes")
        print(f"⏰ Storage epochs: 3")
        print(f"📋 Blob ID: {blob_id}\n")
        
        # Wait a moment for propagation
        print("⏳ Waiting for blob to propagate...")
        time.sleep(2)
        
        # Check blob status
        print("🔍 Checking blob status...")
        status = client.check_blob_status(blob_id)
        print(f"   • Exists: {status['exists']}")
        if status['exists']:
            print(f"   • Size: {status['size']} bytes")
            print(f"   • Content Type: {status['content_type']}")
        
        # Retrieve the blob
        retrieved_data = client.retrieve_blob(blob_id)
        
        # Verify data integrity
        is_data_intact = sample_data == retrieved_data
        print(f"\n🔍 Data integrity check: {'✅ PASSED' if is_data_intact else '❌ FAILED'}")
        
        if is_data_intact:
            print("🎉 Success! Your blob was stored and retrieved correctly.")
            
            # Parse and display the retrieved data
            try:
                parsed_data = json.loads(retrieved_data.decode('utf-8'))
                print("\n📄 Retrieved data:")
                print(json.dumps(parsed_data, indent=2))
            except json.JSONDecodeError:
                print("\n📄 Retrieved data (raw):")
                print(retrieved_data.decode('utf-8', errors='replace'))
                
        else:
            print("❌ Warning: Retrieved data differs from original data.")
            print(f"   Original size: {len(sample_data)} bytes")
            print(f"   Retrieved size: {len(retrieved_data)} bytes")
        
        # Summary
        print("\n📊 Summary:")
        print(f"   • Blob ID: {blob_id}")
        print(f"   • Original size: {len(sample_data)} bytes")
        print(f"   • Retrieved size: {len(retrieved_data)} bytes")
        print(f"   • Storage duration: 3 epochs")
        print(f"   • Data integrity: {'✅ Verified' if is_data_intact else '❌ Failed'}")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        
        # Provide helpful error messages
        if "connection" in str(e).lower():
            print("\n💡 Tip: Check your network connection and try again")
        elif "timeout" in str(e).lower():
            print("\n💡 Tip: Request timed out, try again or check network")
        elif "404" in str(e):
            print("\n💡 Tip: Blob not found, it may have expired or the ID is incorrect")
        
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main()) 