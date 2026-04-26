-- Seed data for SolventZ application

-- Categories
INSERT INTO public.categories (name, slug, icon_url, is_active) VALUES
('Solar Panels', 'solar-panels', 'https://cdn-icons-png.flaticon.com/512/1995/1995506.png', TRUE),
('Inverters', 'inverters', 'https://cdn-icons-png.flaticon.com/512/3050/3050159.png', TRUE),
('Batteries', 'batteries', 'https://cdn-icons-png.flaticon.com/512/4436/4436481.png', TRUE),
('VED (Voltage Enhancement Devices)', 'ved', 'https://cdn-icons-png.flaticon.com/512/3064/3064197.png', TRUE)
ON CONFLICT DO NOTHING;

-- Products - Solar Panels
INSERT INTO public.products (category_id, sku, name, brand, description, specifications, price, stock_quantity, is_active, is_deleted) 
SELECT id as category_id, 
  'SP-550W-001', 
  'Monocrystalline Solar Panel 550W', 
  'JinkoSolar',
  'Premium monocrystalline solar panel with high efficiency rating',
  '{"efficiency": "22.5%", "dimensions": "2270x1134x35mm", "weight": "22.5kg", "warranty": "25 years"}'::jsonb,
  75000, 
  50, 
  TRUE, 
  FALSE
FROM public.categories WHERE slug = 'solar-panels' LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO public.products (category_id, sku, name, brand, description, specifications, price, stock_quantity, is_active, is_deleted) 
SELECT id as category_id, 
  'SP-600W-002',
  'Monocrystalline Solar Panel 600W',
  'Canadian Solar',
  'High power output monocrystalline panel for residential use',
  '{"efficiency": "22.6%", "dimensions": "2257x1127x35mm", "weight": "24kg", "warranty": "25 years"}'::jsonb,
  85000,
  45,
  TRUE,
  FALSE
FROM public.categories WHERE slug = 'solar-panels' LIMIT 1
ON CONFLICT DO NOTHING;

-- Products - Inverters
INSERT INTO public.products (category_id, sku, name, brand, description, specifications, price, stock_quantity, is_active, is_deleted)
SELECT id as category_id,
  'INV-5KW-001',
  'Hybrid Solar Inverter 5KW',
  'Growatt',
  'All-in-one hybrid inverter with battery management',
  '{"power": "5kW", "voltage": "48V", "efficiency": "96.5%", "warranty": "10 years"}'::jsonb,
  150000,
  25,
  TRUE,
  FALSE
FROM public.categories WHERE slug = 'inverters' LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO public.products (category_id, sku, name, brand, description, specifications, price, stock_quantity, is_active, is_deleted)
SELECT id as category_id,
  'INV-8KW-002',
  'Hybrid Solar Inverter 8KW',
  'Sungrow',
  'Industrial grade hybrid inverter for large installations',
  '{"power": "8kW", "voltage": "48V", "efficiency": "97.2%", "warranty": "10 years"}'::jsonb,
  220000,
  18,
  TRUE,
  FALSE
FROM public.categories WHERE slug = 'inverters' LIMIT 1
ON CONFLICT DO NOTHING;

-- Products - Batteries
INSERT INTO public.products (category_id, sku, name, brand, description, specifications, price, stock_quantity, is_active, is_deleted)
SELECT id as category_id,
  'BAT-5KWH-001',
  'Lithium Ion Battery 5kWh',
  'CATL',
  'High-performance lithium ion battery storage system',
  '{"capacity": "5kWh", "voltage": "48V", "chemistry": "LiFePO4", "cycles": "8000", "warranty": "10 years"}'::jsonb,
  250000,
  15,
  TRUE,
  FALSE
FROM public.categories WHERE slug = 'batteries' LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO public.products (category_id, sku, name, brand, description, specifications, price, stock_quantity, is_active, is_deleted)
SELECT id as category_id,
  'BAT-10KWH-002',
  'Lithium Ion Battery 10kWh',
  'BYD',
  'Large capacity lithium ion battery for extended backup',
  '{"capacity": "10kWh", "voltage": "48V", "chemistry": "LiFePO4", "cycles": "8000", "warranty": "10 years"}'::jsonb,
  480000,
  10,
  TRUE,
  FALSE
FROM public.categories WHERE slug = 'batteries' LIMIT 1
ON CONFLICT DO NOTHING;

-- Products - VED
INSERT INTO public.products (category_id, sku, name, brand, description, specifications, price, stock_quantity, is_active, is_deleted)
SELECT id as category_id,
  'VED-10KVA-001',
  'Voltage Enhancement Device 10KVA',
  'VED Tech',
  'Automatic voltage regulator for grid stabilization',
  '{"power": "10KVA", "input_voltage": "90-260V", "output_voltage": "220V", "response_time": "50ms"}'::jsonb,
  35000,
  30,
  TRUE,
  FALSE
FROM public.categories WHERE slug = 'ved' LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO public.products (category_id, sku, name, brand, description, specifications, price, stock_quantity, is_active, is_deleted)
SELECT id as category_id,
  'VED-20KVA-002',
  'Voltage Enhancement Device 20KVA',
  'VED Tech',
  'Heavy-duty voltage regulator for commercial use',
  '{"power": "20KVA", "input_voltage": "90-260V", "output_voltage": "220V", "response_time": "50ms"}'::jsonb,
  65000,
  20,
  TRUE,
  FALSE
FROM public.categories WHERE slug = 'ved' LIMIT 1
ON CONFLICT DO NOTHING;
