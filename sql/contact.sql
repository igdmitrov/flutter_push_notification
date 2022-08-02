create table public.contact (
  id uuid references auth.users not null,
  username text unique,

  primary key (id),
  unique(username),
  constraint username_length check (char_length(username) >= 3)
);

alter table public.contact enable row level security;

create policy "Users can insert their own records."
  on contact for insert
  with check ( auth.uid() = contact.id );

create policy "Users can view only their records." 
  on contact for select
  using ( true );

create policy "Users can update their records."
  on contact for update using (
    false
  );

create policy "Users can not delete their records." 
  on contact for
    delete using (
      false
    );