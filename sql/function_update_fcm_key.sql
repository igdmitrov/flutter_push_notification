-- function for uploading user's firebase keys
create or replace function update_fcm_key(key text)
returns bool
language plpgsql security definer
as
$$
  begin
    insert into public.firebase_messaging_key(user_id, firebase_key, updated_at)
    values ( auth.uid(), $1, now() )
    on conflict(user_id, firebase_key)
    do
      update
      set updated_at = now()
      where ( public.firebase_messaging_key.user_id = auth.uid() and public.firebase_messaging_key.firebase_key = $1 );

    return true;
  end;
$$;