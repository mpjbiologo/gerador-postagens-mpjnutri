-- Gerador de Postagens MPJ Nutri — estrutura inicial Supabase
-- Execute este arquivo no SQL Editor do seu projeto Supabase.
-- Todas as tabelas e objetos são isolados pelo usuário autenticado.

create extension if not exists pgcrypto;

create table if not exists public.mpjnutri_projects (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  local_id text not null,
  name text not null default 'Projeto sem título',
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (owner_id, local_id)
);

create index if not exists mpjnutri_projects_owner_updated_idx
  on public.mpjnutri_projects (owner_id, updated_at desc);

create table if not exists public.mpjnutri_editorial_plan (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  local_id text not null,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (owner_id, local_id)
);

create index if not exists mpjnutri_editorial_plan_owner_updated_idx
  on public.mpjnutri_editorial_plan (owner_id, updated_at desc);

-- Marcadores de exclusão sincronizados entre dispositivos.
create table if not exists public.mpjnutri_sync_tombstones (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  record_type text not null check (record_type in ('project','calendar')),
  local_id text not null,
  deleted_at timestamptz not null default now(),
  unique (owner_id, record_type, local_id)
);

create index if not exists mpjnutri_sync_tombstones_owner_idx
  on public.mpjnutri_sync_tombstones (owner_id, deleted_at desc);

alter table public.mpjnutri_projects enable row level security;
alter table public.mpjnutri_editorial_plan enable row level security;
alter table public.mpjnutri_sync_tombstones enable row level security;

drop policy if exists "Users manage their own projects" on public.mpjnutri_projects;
create policy "Users manage their own projects"
  on public.mpjnutri_projects
  for all
  to authenticated
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

drop policy if exists "Users manage their own editorial plan" on public.mpjnutri_editorial_plan;
create policy "Users manage their own editorial plan"
  on public.mpjnutri_editorial_plan
  for all
  to authenticated
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

drop policy if exists "Users manage their own sync tombstones" on public.mpjnutri_sync_tombstones;
create policy "Users manage their own sync tombstones"
  on public.mpjnutri_sync_tombstones
  for all
  to authenticated
  using (auth.uid() = owner_id)
  with check (auth.uid() = owner_id);

-- Bucket privado para imagens e vídeos vinculados aos projetos.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'mpjnutri-assets',
  'mpjnutri-assets',
  false,
  52428800,
  array['image/jpeg','image/png','image/webp','image/gif','video/mp4','video/webm','video/quicktime']
)
on conflict (id) do update
set public = false,
    file_size_limit = 52428800,
    allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Users read their own MPJ assets" on storage.objects;
create policy "Users read their own MPJ assets"
  on storage.objects for select
  to authenticated
  using (bucket_id = 'mpjnutri-assets' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Users upload their own MPJ assets" on storage.objects;
create policy "Users upload their own MPJ assets"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'mpjnutri-assets' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Users update their own MPJ assets" on storage.objects;
create policy "Users update their own MPJ assets"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'mpjnutri-assets' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'mpjnutri-assets' and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Users delete their own MPJ assets" on storage.objects;
create policy "Users delete their own MPJ assets"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'mpjnutri-assets' and (storage.foldername(name))[1] = auth.uid()::text);
