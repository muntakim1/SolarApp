INSERT INTO storage.buckets (id, name, public) VALUES ('product-images', 'product-images', true) ON CONFLICT DO NOTHING;

CREATE POLICY "Public Read Access" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'product-images');

CREATE POLICY "Managers can insert images" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'product-images' AND public.is_manager());

CREATE POLICY "Managers can update images" 
ON storage.objects FOR UPDATE 
USING (bucket_id = 'product-images' AND public.is_manager());

CREATE POLICY "Managers can delete images" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'product-images' AND public.is_manager());
