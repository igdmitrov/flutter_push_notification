-- holds users firebase keys
create table if not exists public.firebase_messaging_key(
  user_id uuid references auth.users (id) not null,
  firebase_key text not null,
  updated_at timestamptz default now() not null,
  primary key(user_id, firebase_key)
);
alter table public.firebase_messaging_key enable row level security;

create policy "Users can insert their own firebase key."
  on firebase_messaging_key for insert
  with check ( auth.uid() = firebase_messaging_key.user_id );

create policy "All users can view firebase key"
  on firebase_messaging_key for select
  using ( auth.uid() = firebase_messaging_key.user_id );

create policy "Users can update their own firebase key."
  on firebase_messaging_key for update using (
    auth.uid() = firebase_messaging_key.user_id
  );

create policy "Users can delete their own firebase key." 
  on firebase_messaging_key for
    delete using (
      false
    );