-- À coller dans Supabase > SQL Editor > Run
create table public.fiches (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  nom text not null check (char_length(nom) <= 120),
  localite text not null check (char_length(localite) <= 120),
  date_contribution date,
  secteur text,
  titre text not null check (char_length(titre) <= 200),
  frequence text,
  difficulte text,
  delai text,
  n0 smallint not null default 0 check (n0 between 0 and 5),
  n1 smallint not null default 0 check (n1 between 0 and 5),
  n2 smallint not null default 0 check (n2 between 0 and 5),
  n3 smallint not null default 0 check (n3 between 0 and 5),
  n4 smallint not null default 0 check (n4 between 0 and 5),
  score_total smallint generated always as (n0 + n1 + n2 + n3 + n4) stored,
  reponses jsonb not null default '{}'
);
create index on public.fiches (score_total desc);

alter table public.fiches enable row level security;

-- Tout le monde peut envoyer une fiche, personne (sauf l'admin connecté) ne peut les lire
create policy "envoi public" on public.fiches for insert to anon with check (true);
create policy "lecture admin" on public.fiches for select to authenticated using (true);
grant insert on public.fiches to anon;
grant select on public.fiches to authenticated;
