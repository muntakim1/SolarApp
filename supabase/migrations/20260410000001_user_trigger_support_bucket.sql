-- ─── Auto-create public.users row on auth signup ──────────────────────────────

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.users (id, full_name, email, phone, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'phone', ''),
    'customer'
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ─── Allow users to insert their own row (upsert from app if trigger missed) ──

CREATE POLICY "Users can insert own record"
  ON users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- ─── Support Attachments Storage Bucket ───────────────────────────────────────

INSERT INTO storage.buckets (id, name, public)
VALUES ('support-attachments', 'support-attachments', false)
ON CONFLICT DO NOTHING;

CREATE POLICY "Users can upload their own ticket attachments"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'support-attachments'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Users can read their own ticket attachments"
  ON storage.objects FOR SELECT
  USING (
    bucket_id = 'support-attachments'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );
