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
