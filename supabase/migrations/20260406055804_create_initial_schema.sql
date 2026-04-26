-- Enums
CREATE TYPE user_role AS ENUM ('customer', 'admin', 'support_agent', 'super_admin');
CREATE TYPE order_status AS ENUM ('pending', 'processing', 'packed', 'shipped', 'delivered', 'cancelled');
CREATE TYPE payment_method AS ENUM ('bank_transfer', 'cod', 'online_payment');
CREATE TYPE payment_status AS ENUM ('unpaid', 'paid', 'refunded');
CREATE TYPE property_type AS ENUM ('residential', 'commercial', 'industrial', 'agricultural');
CREATE TYPE survey_status AS ENUM ('new', 'scheduled', 'completed', 'quote_sent', 'accepted', 'declined');
CREATE TYPE ticket_category AS ENUM ('product_defect', 'installation_issue', 'billing', 'general');
CREATE TYPE ticket_status AS ENUM ('open', 'in_review', 'awaiting_customer', 'resolved', 'closed');

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid() REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    city VARCHAR(100),
    role user_role DEFAULT 'customer',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Staff check function to prevent infinite recursion in RLS
CREATE FUNCTION is_staff() RETURNS boolean
LANGUAGE sql SECURITY DEFINER STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'super_admin', 'support_agent')
  );
$$;

-- Operations Manager/Admin check function
CREATE FUNCTION is_manager() RETURNS boolean
LANGUAGE sql SECURITY DEFINER STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.users WHERE id = auth.uid() AND role IN ('admin', 'super_admin')
  );
$$;

-- Categories Table
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    slug VARCHAR(120) NOT NULL UNIQUE,
    icon_url TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Products Table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    brand VARCHAR(80) NOT NULL,
    description TEXT,
    specifications JSONB,
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0),
    images TEXT[],
    is_active BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Orders Table
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    order_number VARCHAR(20) NOT NULL UNIQUE,
    status order_status NOT NULL DEFAULT 'pending',
    delivery_address JSONB NOT NULL,
    payment_method payment_method NOT NULL,
    payment_status payment_status DEFAULT 'unpaid',
    subtotal NUMERIC(12,2) NOT NULL,
    delivery_fee NUMERIC(10,2) DEFAULT 0,
    grand_total NUMERIC(12,2) NOT NULL,
    admin_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Order Items Table
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE SET NULL,
    product_snapshot JSONB NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL,
    line_total NUMERIC(12,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- Surveys Table
CREATE TABLE surveys (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    property_type property_type NOT NULL,
    address TEXT NOT NULL,
    monthly_bill NUMERIC(10,2) NOT NULL,
    preferred_date DATE NOT NULL,
    notes TEXT,
    status survey_status DEFAULT 'new',
    scheduled_at TIMESTAMPTZ,
    quote_amount NUMERIC(14,2),
    quote_details JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Support Tickets Table
CREATE TABLE support_tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    assigned_to UUID REFERENCES users(id) ON DELETE SET NULL,
    category ticket_category NOT NULL,
    subject VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    attachments TEXT[],
    status ticket_status DEFAULT 'open',
    resolved_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_products_category_brand ON products(category_id, brand, is_active, is_deleted);
CREATE INDEX idx_orders_user_status ON orders(user_id, status, created_at);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);
CREATE INDEX idx_surveys_user_status ON surveys(user_id, status, created_at);
CREATE INDEX idx_support_tickets_user_status ON support_tickets(user_id, status, assigned_to, created_at);

-- RLS Policies
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE surveys ENABLE ROW LEVEL SECURITY;
ALTER TABLE support_tickets ENABLE ROW LEVEL SECURITY;

-- users
CREATE POLICY "Users can read own record" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own record" ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Staff can read all users" ON users FOR SELECT USING (is_staff());

-- categories
CREATE POLICY "Everyone can read active categories" ON categories FOR SELECT USING (is_active = TRUE);
CREATE POLICY "Managers can manage categories" ON categories FOR ALL USING (is_manager());

-- products
CREATE POLICY "Everyone can read active products" ON products FOR SELECT USING (is_active = TRUE AND is_deleted = FALSE);
CREATE POLICY "Managers can manage products" ON products FOR ALL USING (is_manager());

-- orders
CREATE POLICY "Users can read own orders" ON orders FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own orders" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Managers can manage orders" ON orders FOR ALL USING (is_manager());

-- order_items
CREATE POLICY "Users can read own order items" ON order_items FOR SELECT USING (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()));
CREATE POLICY "Users can insert own order items" ON order_items FOR INSERT WITH CHECK (EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid()));
CREATE POLICY "Managers can manage order items" ON order_items FOR ALL USING (is_manager());

-- surveys
CREATE POLICY "Users can read own surveys" ON surveys FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own surveys" ON surveys FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Managers can manage surveys" ON surveys FOR ALL USING (is_manager());

-- support_tickets
CREATE POLICY "Users can read own tickets" ON support_tickets FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own tickets" ON support_tickets FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Staff can manage tickets" ON support_tickets FOR ALL USING (is_staff());
