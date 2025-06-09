#!/bin/bash

# Bitcoin Core Documentation Opener
# Simple script to open the documentation website

DOC_DIR="docs"
INDEX_FILE="$DOC_DIR/index.html"

echo "🌐 Bitcoin Core Documentation Hub"
echo "=================================="
echo

# Check if documentation exists
if [ ! -f "$INDEX_FILE" ]; then
    echo "❌ Documentation not found!"
    echo "Please ensure the docs/ directory exists with index.html"
    exit 1
fi

# Function to open file
open_doc() {
    local file="$1"
    local full_path="$DOC_DIR/$file"
    
    if [ ! -f "$full_path" ]; then
        echo "❌ File not found: $file"
        return 1
    fi
    
    echo "📖 Opening: $file"
    
    # Detect OS and open accordingly
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        open "$full_path"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        xdg-open "$full_path" 2>/dev/null || echo "🌐 File ready at: file://$(pwd)/$full_path"
    else
        # Windows/Others
        echo "🌐 Open this file in your browser: file://$(pwd)/$full_path"
    fi
}

# Show menu if no arguments
if [ $# -eq 0 ]; then
    echo "📚 Available Documentation:"
    echo "  1. Main Hub (index.html)"
    echo "  2. Commands Reference (commands.html)"
    echo "  3. Developer Onboarding (onboarding.html)" 
    echo "  4. Pruning Guide (pruning.html)"
    echo "  5. Node Setup (node-setup.html)"
    echo "  6. Monitoring Tools (monitoring.html)"
    echo "  7. Network & Threads (network-threads.html)"
    echo "  8. Contributor Guide (contributor-guide.html)"
    echo
    echo "Usage examples:"
    echo "  $0                    # Show this menu"
    echo "  $0 index             # Open main hub"
    echo "  $0 commands          # Open commands reference"
    echo "  $0 onboarding        # Open onboarding guide"
    echo "  $0 contributor       # Open contributor guide"
    echo "  $0 all               # Open all pages"
    echo
    
    # Auto-open main hub
    echo "🚀 Opening main documentation hub..."
    open_doc "index.html"
    exit 0
fi

# Handle arguments
case "$1" in
    "index"|"main"|"hub")
        open_doc "index.html"
        ;;
    "commands"|"cmd"|"reference")
        open_doc "commands.html"
        ;;
    "onboarding"|"guide"|"start")
        open_doc "onboarding.html"
        ;;
    "pruning"|"prune")
        open_doc "pruning.html"
        ;;
    "node"|"setup")
        open_doc "node-setup.html"
        ;;
    "monitoring"|"monitor")
        open_doc "monitoring.html"
        ;;
    "network"|"threads")
        open_doc "network-threads.html"
        ;;
    "contributor"|"contrib"|"guide")
        open_doc "contributor-guide.html"
        ;;
    "all")
        echo "🚀 Opening all documentation pages..."
        open_doc "index.html"
        sleep 1
        open_doc "commands.html"
        sleep 1
        open_doc "onboarding.html"
        sleep 1
        open_doc "contributor-guide.html"
        ;;
    *)
        echo "❌ Unknown option: $1"
        echo "Use '$0' without arguments to see available options"
        exit 1
        ;;
esac

echo "✅ Documentation opened successfully!"
echo "💡 Tip: Bookmark the main hub for quick access" 