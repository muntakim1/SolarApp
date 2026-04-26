-- Enable Realtime for core tables
BEGIN;
  -- Remove tables if they were already there (to avoid errors)
  -- But we can't easily remove specific tables from a publication if they don't exist.
  -- The safest way is to check and add.
  
  -- Supabase usually has a publication named 'supabase_realtime'
  -- If it doesn't exist, this might fail, so we should be careful.
  
  ALTER PUBLICATION supabase_realtime ADD TABLE orders;
  ALTER PUBLICATION supabase_realtime ADD TABLE surveys;
  ALTER PUBLICATION supabase_realtime ADD TABLE support_tickets;
COMMIT;
