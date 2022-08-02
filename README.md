# Flutter + Supabase + Firebase: Push Notification

Part I: Create ChatApp
Youtube:

[![How to make it](https://img.youtube.com/vi/Ll60tsXyazM/0.jpg)](https://www.youtube.com/watch?v=Ll60tsXyazM)

Part II: Push notifications
Youtube:

[![How to make it](https://img.youtube.com/vi/cxELXfRAkNA/0.jpg)](https://www.youtube.com/watch?v=cxELXfRAkNA)


SQL Functions:

Function to upload user's firebase keys:
```
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
```

Function to submit push notifications
```
create or replace function public.send_push_notification(receiver_user_id uuid, title text, message text)
returns bigint
language plpgsql security definer
as
$$
  declare
    payload text;
    receiver_fcm_token text;
    request_id bigint;
  begin
    select firebase_key
    from public.firebase_messaging_key
    where user_id = $1
    order by updated_at desc
    limit 1
    into receiver_fcm_token;

    if receiver_fcm_token is null
    then return null;
    end if;

    payload := '{
      "token": "'||receiver_fcm_token||'",
      "title": "'||$2||'",
      "message": "'||$3||'"
    }';

    select
      net.http_post(
        url := 'https://us-central1-test-app-71821.cloudfunctions.net/sendPushNotify',
        body := payload::jsonb
      )
    into request_id;

    return request_id;
  end;
$$;
```

Function to trigger a new message:
```
create or replace function message_trigger_func()
returns trigger
language plpgsql security definer
as
$$
  begin
    PERFORM public.send_push_notification(NEW.user_to, 'My title', NEW.content);
    return NEW;
  end;
$$;
```

