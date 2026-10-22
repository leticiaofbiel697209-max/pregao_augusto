-- PregãoOS: esquema inicial de domínio. Aplicar somente em branch de desenvolvimento.
-- A autorização do operador especial deve ser conferida no servidor em cada comando.

create extension if not exists pgcrypto;

create table if not exists organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  procurement_rules_version text,
  created_at timestamptz not null default now()
);

create table if not exists profiles (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete restrict,
  auth_user_id text not null unique,
  display_name text not null,
  email text not null,
  role text not null check (role in ('system_admin','pregoeiro','fornecedor')),
  can_trigger_2m boolean not null default false,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (organization_id, email)
);

-- Um único perfil especial ativo por OS; outros perfis continuam com can_trigger_2m=false.
create unique index if not exists one_timer_operator_per_organization
  on profiles (organization_id) where can_trigger_2m and active;

create table if not exists procurement_processes (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete restrict,
  code text not null,
  title text not null,
  description text,
  status text not null default 'draft' check (status in ('draft','published','receiving_proposals','in_session','document_review','result','closed','suspended','canceled')),
  rules jsonb not null default '{}'::jsonb,
  session_starts_at timestamptz,
  session_ends_at timestamptz,
  timer_duration_seconds integer not null default 600 check (timer_duration_seconds > 0),
  notice_duration_seconds integer not null default 120 check (notice_duration_seconds = 120),
  timer_started_at timestamptz,
  notice_visible_at timestamptz,
  created_by uuid references profiles(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (organization_id, code)
);

create table if not exists proposals (
  id uuid primary key default gen_random_uuid(),
  process_id uuid not null references procurement_processes(id) on delete restrict,
  supplier_profile_id uuid not null references profiles(id) on delete restrict,
  status text not null default 'submitted' check (status in ('draft','submitted','withdrawn','under_review','accepted','rejected')),
  amount numeric(14,2) check (amount is null or amount >= 0),
  proposal_data jsonb not null default '{}'::jsonb,
  submitted_at timestamptz,
  created_at timestamptz not null default now(),
  unique (process_id, supplier_profile_id)
);

create table if not exists checklist_requirements (
  id uuid primary key default gen_random_uuid(),
  process_id uuid not null references procurement_processes(id) on delete cascade,
  name text not null,
  description text,
  required boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists submitted_documents (
  id uuid primary key default gen_random_uuid(),
  process_id uuid not null references procurement_processes(id) on delete restrict,
  supplier_profile_id uuid not null references profiles(id) on delete restrict,
  requirement_id uuid references checklist_requirements(id) on delete set null,
  object_key text not null,
  original_filename text not null,
  content_type text not null,
  size_bytes bigint not null check (size_bytes > 0),
  review_status text not null default 'pending' check (review_status in ('pending','accepted','correction_requested','rejected')),
  review_note text,
  reviewed_by uuid references profiles(id) on delete set null,
  reviewed_at timestamptz,
  uploaded_at timestamptz not null default now()
);

create table if not exists process_messages (
  id uuid primary key default gen_random_uuid(),
  process_id uuid not null references procurement_processes(id) on delete restrict,
  sender_profile_id uuid not null references profiles(id) on delete restrict,
  recipient_profile_id uuid references profiles(id) on delete restrict,
  audience text not null check (audience in ('all','private')),
  body text not null check (char_length(body) between 1 and 5000),
  created_at timestamptz not null default now(),
  check ((audience = 'all' and recipient_profile_id is null) or (audience = 'private' and recipient_profile_id is not null))
);

create table if not exists timer_events (
  id uuid primary key default gen_random_uuid(),
  process_id uuid not null references procurement_processes(id) on delete restrict,
  actor_profile_id uuid not null references profiles(id) on delete restrict,
  event_type text not null check (event_type in ('timer_started','two_minute_notice_triggered','timer_paused','timer_resumed','timer_ended')),
  event_at timestamptz not null default now(),
  metadata jsonb not null default '{}'::jsonb
);

create table if not exists audit_events (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references organizations(id) on delete restrict,
  actor_profile_id uuid references profiles(id) on delete set null,
  process_id uuid references procurement_processes(id) on delete set null,
  action text not null,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index if not exists process_messages_timeline on process_messages (process_id, created_at);
create index if not exists submitted_documents_review on submitted_documents (process_id, supplier_profile_id, review_status);
create index if not exists timer_events_timeline on timer_events (process_id, event_at);
create index if not exists audit_events_timeline on audit_events (organization_id, created_at desc);

