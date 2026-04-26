#!/bin/bash

# SolventZ - Supabase Quick Deployment Script
# This script sets up all Supabase tables and configurations

set -e

echo "🚀 SolventZ Supabase Setup Script"
echo "=================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ Supabase CLI not found!${NC}"
    echo "Install it with: brew install supabase/tap/supabase"
    exit 1
fi

echo -e "${BLUE}✓ Supabase CLI found${NC}"
echo ""

# Navigate to supabase directory
cd supabase || { echo -e "${RED}❌ supabase directory not found${NC}"; exit 1; }

# Ask user what they want to do
echo -e "${YELLOW}Choose setup option:${NC}"
echo "1) Local Development (Supabase CLI)"
echo "2) Production (Supabase Cloud)"
echo "3) Push to existing project"
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo -e "${BLUE}Starting local Supabase instance...${NC}"
        echo ""
        supabase start
        echo ""
        echo -e "${GREEN}✅ Local Supabase is running!${NC}"
        echo ""
        echo "Environment variables for local development:"
        echo "  NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321"
        echo "  NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WfrbgaSRCFqr3z8QA7dUQeFPFo00xiJLlVaI"
        echo ""
        echo "Update your .env.local files with these values"
        echo "Studio URL: http://127.0.0.1:54323"
        ;;
    2)
        echo ""
        echo -e "${BLUE}Setting up Production Supabase...${NC}"
        echo ""
        read -p "Enter your Supabase Project ID (from URL): " project_id
        echo ""
        echo -e "${YELLOW}Linking to project: $project_id${NC}"
        supabase link --project-ref "$project_id"
        echo ""
        echo -e "${BLUE}Pushing database migrations...${NC}"
        supabase db push
        echo ""
        echo -e "${GREEN}✅ Production database set up complete!${NC}"
        echo ""
        echo "Get your API keys from: https://app.supabase.com/project/$project_id/settings/api"
        ;;
    3)
        echo ""
        read -p "Enter your Supabase Project ID: " project_id
        echo ""
        echo -e "${BLUE}Pushing migrations to: $project_id${NC}"
        supabase link --project-ref "$project_id"
        supabase db push
        echo ""
        echo -e "${GREEN}✅ Migrations pushed!${NC}"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Update .env.local in admin-web with your Supabase credentials"
echo "2. Update .env.local in mobile-app with your Supabase credentials"
echo "3. Run: npm run dev (in admin-web folder)"
echo "4. Run: npm start (in mobile-app folder)"
echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
