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