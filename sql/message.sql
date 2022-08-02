create table public.message (
  id uuid default gen_random_uuid() primary key not null,
  content text check (char_length(content) > 0) not null,
  mark_as_read boolean default true not null, 
  user_from uuid references auth.users not null,
  user_to uuid references auth.users not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.message enable row level security;

alter publication supabase_realtime add table public.message;

create policy "Users can insert their own messages."
  on message for insert
  with check ( auth.uid() = message.user_from );

create policy "Users can view only their messages" 
  on message for select
  using ( auth.uid() = message.user_from or auth.uid() = message.user_to );

create policy "Users can update their messages."
  on message for update using (
    auth.uid() = message.user_to
  );

create policy "Users can not delete their messages." 
  on message for
    delete using (
      false
    );