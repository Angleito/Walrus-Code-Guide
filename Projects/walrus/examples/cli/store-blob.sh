#!/bin/bash

# Simple Walrus CLI Example - Store Blob
# This script demonstrates storing a blob using the Walrus HTTP API

set -e

# Configuration
PUBLISHER_URL="https://publisher.testnet.walrus.space"
DEFAULT_EPOCHS=3

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_color() {
    printf "${1}${2}${NC}\n"
}

print_header() {
    echo ""
    print_color $BLUE "🌊 Walrus CLI Example - Store Blob"
    print_color $BLUE "================================="
    echo ""
}

print_usage() {
    echo "Usage: $0 <file_path> [epochs]"
    echo ""
    echo "Arguments:"
    echo "  file_path    Path to the file to store"
    echo "  epochs       Number of epochs to store (default: $DEFAULT_EPOCHS)"
    echo ""
    echo "Examples:"
    echo "  $0 sample.txt"
    echo "  $0 image.jpg 5"
    echo "  $0 document.pdf 10"
}

# Check if curl is installed
check_curl() {
    if ! command -v curl &> /dev/null; then
        print_color $RED "❌ curl is not installed. Please install curl first."
        exit 1
    fi
}

# Check if jq is installed (for JSON parsing)
check_jq() {
    if ! command -v jq &> /dev/null; then
        print_color $YELLOW "⚠️  jq is not installed. JSON output will be raw."
        return 1
    fi
    return 0
}

# Store blob using curl
store_blob() {
    local file_path=$1
    local epochs=$2
    
    print_color $YELLOW "📝 Storing blob: $file_path"
    print_color $BLUE "⏰ Storage epochs: $epochs"
    
    # Check if file exists
    if [ ! -f "$file_path" ]; then
        print_color $RED "❌ File not found: $file_path"
        exit 1
    fi
    
    # Get file size
    local file_size=$(stat -c%s "$file_path" 2>/dev/null || stat -f%z "$file_path" 2>/dev/null || echo "unknown")
    print_color $BLUE "📏 File size: $file_size bytes"
    
    # Store the blob
    local response
    local http_code
    
    print_color $YELLOW "🚀 Uploading to Walrus..."
    
    # Create temporary file for response
    local temp_response=$(mktemp)
    
    # Make the request
    http_code=$(curl -s -w "%{http_code}" \
        -X PUT \
        -H "Content-Type: application/octet-stream" \
        -d "@$file_path" \
        "$PUBLISHER_URL/v1/store?epochs=$epochs" \
        -o "$temp_response")
    
    response=$(cat "$temp_response")
    rm "$temp_response"
    
    # Check response
    if [ "$http_code" -eq 200 ]; then
        print_color $GREEN "✅ Blob stored successfully!"
        
        # Parse response
        if check_jq; then
            local blob_id=$(echo "$response" | jq -r '.blobId // empty')
            local certified_epoch=$(echo "$response" | jq -r '.certifiedEpoch // empty')
            local end_epoch=$(echo "$response" | jq -r '.endEpoch // empty')
            
            if [ -n "$blob_id" ]; then
                print_color $GREEN "📋 Blob ID: $blob_id"
                print_color $BLUE "🏛️  Certified Epoch: $certified_epoch"
                print_color $BLUE "📅 End Epoch: $end_epoch"
                
                # Save blob ID to file
                echo "$blob_id" > "${file_path}.blob_id"
                print_color $GREEN "💾 Blob ID saved to: ${file_path}.blob_id"
                
                # Show retrieval URL
                print_color $BLUE "🔗 Retrieval URL: https://aggregator.testnet.walrus.space/v1/$blob_id"
            else
                print_color $YELLOW "⚠️  Could not extract blob ID from response"
            fi
        else
            print_color $GREEN "📄 Response:"
            echo "$response"
        fi
        
    else
        print_color $RED "❌ Failed to store blob (HTTP $http_code)"
        print_color $RED "Response: $response"
        
        # Provide helpful error messages
        case $http_code in
            400)
                print_color $YELLOW "💡 Bad request - check your file and parameters"
                ;;
            413)
                print_color $YELLOW "💡 File too large - try a smaller file"
                ;;
            429)
                print_color $YELLOW "💡 Rate limited - wait a moment and try again"
                ;;
            500)
                print_color $YELLOW "💡 Server error - try again later"
                ;;
            *)
                print_color $YELLOW "💡 Check your network connection and try again"
                ;;
        esac
        
        exit 1
    fi
}

# Main function
main() {
    print_header
    
    # Check arguments
    if [ $# -lt 1 ]; then
        print_usage
        exit 1
    fi
    
    local file_path=$1
    local epochs=${2:-$DEFAULT_EPOCHS}
    
    # Validate epochs
    if ! [[ "$epochs" =~ ^[0-9]+$ ]] || [ "$epochs" -lt 1 ]; then
        print_color $RED "❌ Invalid epochs value: $epochs"
        print_color $BLUE "Epochs must be a positive integer"
        exit 1
    fi
    
    # Check dependencies
    check_curl
    
    # Store the blob
    store_blob "$file_path" "$epochs"
    
    print_color $GREEN "\n🎉 Operation completed successfully!"
    print_color $BLUE "💡 To retrieve the blob, use: ./retrieve-blob.sh <blob_id>"
    print_color $BLUE "💡 Or visit the retrieval URL shown above"
}

# Run main function
main "$@" 