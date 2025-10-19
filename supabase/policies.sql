-- Outfit submissions table
create table if not exists public.outfit_submissions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  latitude double precision not null,
  longitude double precision not null,
  top text not null,
  bottom text not null,
  outerwear text,
  shoes text not null,
  accessories text[],
  reported_at timestamptz not null default timezone('utc', now()),
  is_just_right boolean not null default false
);

alter table public.outfit_submissions enable row level security;

drop policy if exists "Users can insert their outfit submissions" on public.outfit_submissions;
create policy "Users can insert their outfit submissions"
  on public.outfit_submissions
  for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users read aggregated data" on public.outfit_submissions;
create policy "Users read aggregated data"
  on public.outfit_submissions
  for select
  using (true);

-- Enable realtime broadcasts for live updates (optional)
alter publication supabase_realtime add table public.outfit_submissions;

-- Device tokens table for local notifications
create table if not exists public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  device_id text unique not null,
  is_enabled boolean not null default false,
  notification_hour int not null default 8,
  notification_minute int not null default 0,
  platform text,
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

alter table public.device_tokens enable row level security;

drop policy if exists "Users can manage their device tokens" on public.device_tokens;
create policy "Users can manage their device tokens"
  on public.device_tokens
  for all
  using (true)
  with check (true);

-- Auto-update updated_at timestamp
create or replace function public.update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$ language plpgsql;

drop trigger if exists update_device_tokens_updated_at on public.device_tokens;
create trigger update_device_tokens_updated_at
  before update on public.device_tokens
  for each row
  execute function public.update_updated_at_column();
