create extension if not exists pgcrypto;

create table if not exists public.profile_settings (
  id integer primary key default 1 check (id = 1),
  name text not null default 'M. Akash',
  professional_title text not null default 'ECE Engineer | Electrician | Plumber | Embedded & IoT Developer',
  about text not null default 'I work with real wires, pipes, tools, circuits, sensors and machines while studying Electronics and Communication Engineering.',
  phone text, whatsapp text, email text, location text not null default 'Madurai', github text, linkedin text, resume_url text,
  updated_at timestamptz not null default now()
);
create table if not exists public.work_entries (
  id uuid primary key default gen_random_uuid(), title text not null, category text not null default 'Other', description text not null default '', location text,
  work_date date, status text not null default 'Planning' check (status in ('Planning','Currently Working','Completed','Paused')), tools_used text,
  customer_visible boolean not null default true, created_at timestamptz not null default now()
);
create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(), name text not null, category text not null default 'Other', description text not null default '', problem text,
  solution text, technologies text, github_url text, demo_url text, status text not null default 'Planning', created_at timestamptz not null default now()
);
create table if not exists public.service_requests (
  id uuid primary key default gen_random_uuid(), name text not null, phone text not null, location text not null, service text not null, problem text not null,
  preferred_date date, image_url text, status text not null default 'New' check (status in ('New','Contacted','In Progress','Completed','Cancelled')),
  internal_notes text, created_at timestamptz not null default now()
);
insert into public.profile_settings (id) values (1) on conflict (id) do nothing;

alter table public.profile_settings enable row level security;
alter table public.work_entries enable row level security;
alter table public.projects enable row level security;
alter table public.service_requests enable row level security;

create policy "public can read profile" on public.profile_settings for select to anon, authenticated using (true);
create policy "authenticated can manage profile" on public.profile_settings for all to authenticated using (true) with check (true);
create policy "public can read work" on public.work_entries for select to anon, authenticated using (customer_visible = true or (select auth.uid()) is not null);
create policy "authenticated can manage work" on public.work_entries for all to authenticated using (true) with check (true);
create policy "public can read projects" on public.projects for select to anon, authenticated using (true);
create policy "authenticated can manage projects" on public.projects for all to authenticated using (true) with check (true);
create policy "public can submit requests" on public.service_requests for insert to anon, authenticated with check (true);
create policy "authenticated can manage requests" on public.service_requests for select, update, delete to authenticated using (true) with check (true);

insert into public.work_entries (title, category, description, location, status, tools_used)
select 'Electrical maintenance work', 'Electrical', 'On-site maintenance and fault finding.', 'Madurai', 'Currently Working', 'Tester, hand tools'
where not exists (select 1 from public.work_entries);
insert into public.projects (name, category, description, technologies, status)
select 'ESP Smart Link', 'IoT', 'ESP32/ESP8266-based smart control and automation system.', 'ESP32, Flutter, MQTT', 'Planning'
where not exists (select 1 from public.projects);
