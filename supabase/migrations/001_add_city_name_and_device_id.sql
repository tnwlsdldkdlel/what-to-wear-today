-- Add missing columns to outfit_submissions table

-- Add city_name column (시/도 이름 저장)
ALTER TABLE public.outfit_submissions
ADD COLUMN IF NOT EXISTS city_name text;

-- Add device_id column (기기 식별자)
ALTER TABLE public.outfit_submissions
ADD COLUMN IF NOT EXISTS device_id text;

-- Create index for better query performance on city_name
CREATE INDEX IF NOT EXISTS idx_outfit_submissions_city_name
ON public.outfit_submissions(city_name);

-- Create index for better query performance on reported_at (for date filtering)
CREATE INDEX IF NOT EXISTS idx_outfit_submissions_reported_at
ON public.outfit_submissions(reported_at DESC);

-- Create composite index for city_name + reported_at queries
CREATE INDEX IF NOT EXISTS idx_outfit_submissions_city_reported
ON public.outfit_submissions(city_name, reported_at DESC);
