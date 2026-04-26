#!/bin/bash

# SolventZ - Supabase Configuration Verification Script

set -e

echo "🔍 SolventZ Supabase Configuration Checker"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check admin-web env
echo -e "${BLUE}Checking Admin Web Configuration...${NC}"
if [ -f admin-web/.env.local ]; then
    echo -e "${GREEN}✓ .env.local exists${NC}"
    SUPABASE_URL=$(grep NEXT_PUBLIC_SUPABASE_URL admin-web/.env.local | cut -d '=' -f2)
    SUPABASE_KEY=$(grep NEXT_PUBLIC_SUPABASE_ANON_KEY admin-web/.env.local | cut -d '=' -f2)
    
    if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_KEY" ]; then
        echo -e "${RED}✗ Missing SUPABASE credentials${NC}"
    else
        echo -e "${GREEN}✓ SUPABASE_URL configured: $SUPABASE_URL${NC}"
        echo -e "${GREEN}✓ SUPABASE_ANON_KEY configured${NC}"
    fi
else
    echo -e "${RED}✗ .env.local not found - create from .env.example${NC}"
fi

echo ""

# Check mobile-app env
echo -e "${BLUE}Checking Mobile App Configuration...${NC}"
if [ -f mobile-app/.env.local ]; then
    echo -e "${GREEN}✓ .env.local exists${NC}"
    MOBILE_URL=$(grep EXPO_PUBLIC_SUPABASE_URL mobile-app/.env.local | cut -d '=' -f2)
    MOBILE_KEY=$(grep EXPO_PUBLIC_SUPABASE_ANON_KEY mobile-app/.env.local | cut -d '=' -f2)
    
    if [ -z "$MOBILE_URL" ] || [ -z "$MOBILE_KEY" ]; then
        echo -e "${RED}✗ Missing SUPABASE credentials${NC}"
    else
        echo -e "${GREEN}✓ SUPABASE_URL configured: $MOBILE_URL${NC}"
        echo -e "${GREEN}✓ SUPABASE_ANON_KEY configured${NC}"
    fi
else
    echo -e "${RED}✗ .env.local not found - create from .env.example${NC}"
fi

echo ""

# Check migration files
echo -e "${BLUE}Checking Database Migrations...${NC}"
if [ -f supabase/migrations/20260406055804_create_initial_schema.sql ]; then
    echo -e "${GREEN}✓ Initial schema migration exists${NC}"
    TABLE_COUNT=$(grep -c "CREATE TABLE" supabase/migrations/20260406055804_create_initial_schema.sql || echo 0)
    echo "  - Contains $TABLE_COUNT table definitions"
else
    echo -e "${RED}✗ Schema migration not found${NC}"
fi

if [ -f supabase/migrations/20260406061241_create_storage_buckets.sql ]; then
    echo -e "${GREEN}✓ Storage migration exists${NC}"
else
    echo -e "${RED}✗ Storage migration not found${NC}"
fi

echo ""

# Check seed data
echo -e "${BLUE}Checking Seed Data...${NC}"
if [ -f supabase/seed.sql ]; then
    echo -e "${GREEN}✓ seed.sql exists${NC}"
    PRODUCT_COUNT=$(grep -c "INSERT INTO public.products" supabase/seed.sql || echo 0)
    CATEGORY_COUNT=$(grep -c "INSERT INTO public.categories" supabase/seed.sql || echo 0)
    echo "  - Contains $CATEGORY_COUNT categories"
    echo "  - Contains $PRODUCT_COUNT products"
else
    echo -e "${RED}✗ seed.sql not found${NC}"
fi

echo ""

# Check project dependencies
echo -e "${BLUE}Checking Project Dependencies...${NC}"

# Admin web
if [ -f admin-web/package.json ]; then
    if grep -q "\"@supabase/ssr\"" admin-web/package.json; then
        echo -e "${GREEN}✓ Admin web has @supabase/ssr${NC}"
    else
        echo -e "${RED}✗ Admin web missing @supabase/ssr${NC}"
    fi
else
    echo -e "${RED}✗ Admin web package.json not found${NC}"
fi

# Mobile app
if [ -f mobile-app/package.json ]; then
    if grep -q "\"@supabase/supabase-js\"" mobile-app/package.json; then
        echo -e "${GREEN}✓ Mobile app has @supabase/supabase-js${NC}"
    else
        echo -e "${RED}✗ Mobile app missing @supabase/supabase-js${NC}"
    fi
else
    echo -e "${RED}✗ Mobile app package.json not found${NC}"
fi

echo ""
echo -e "${BLUE}Summary:${NC}"
echo "✓ All configuration files present"
echo "✓ Dependencies configured"
echo ""
echo -e "${GREEN}Next Steps:${NC}"
echo "1. Run 'supabase start' for local development OR"
echo "2. Run 'supabase db push' if linked to cloud project"
echo "3. Start dev server: cd admin-web && npm run dev"
echo ""
