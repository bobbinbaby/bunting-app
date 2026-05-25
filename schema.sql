-- ============================================================
-- BUNTING PREVIEWER — SUPABASE SCHEMA
-- Paste this entire file into Supabase → SQL Editor → Run
-- ============================================================

-- MAKERS table: one row per maker account
create table if not exists makers (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  slug text not null unique,
  business_name text,
  created_at timestamptz default now()
);

-- Slugs must be lowercase alphanumeric + hyphens only
alter table makers add constraint slug_format check (slug ~ '^[a-z0-9-]{3,40}$');

-- FABRICS table: one row per fabric per maker
create table if not exists fabrics (
  id uuid primary key default gen_random_uuid(),
  maker_id uuid not null references makers(id) on delete cascade,
  name text not null default 'Untitled',
  storage_path text not null,
  public_url text not null,
  tags text[] default '{}',
  in_pool boolean default true,
  sort_order integer default 0,
  created_at timestamptz default now()
);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

alter table makers enable row level security;
alter table fabrics enable row level security;

-- Makers can read/write their own row
create policy "makers_self" on makers
  for all using (auth.uid() = id);

-- Anyone can read makers (needed for customer slug lookup)
create policy "makers_public_read" on makers
  for select using (true);

-- Makers can manage their own fabrics
create policy "fabrics_owner" on fabrics
  for all using (auth.uid() = maker_id);

-- Anyone can read fabrics (customers need this)
create policy "fabrics_public_read" on fabrics
  for select using (true);

-- ============================================================
-- STORAGE BUCKET POLICY
-- (Bucket 'fabrics' must already exist and be set to Public)
-- Run these separately if the above succeeds
-- ============================================================

-- Allow authenticated makers to upload to their own folder
create policy "maker_upload" on storage.objects
  for insert with check (
    bucket_id = 'fabrics' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Allow makers to delete their own files
create policy "maker_delete" on storage.objects
  for delete using (
    bucket_id = 'fabrics' and
    auth.uid()::text = (storage.foldername(name))[1]
  );

-- Allow public read of all fabric images
create policy "public_read_fabrics" on storage.objects
  for select using (bucket_id = 'fabrics');
