-- Criar função segura para verificar se email existe
CREATE OR REPLACE FUNCTION public.email_exists(check_email text)
RETURNS boolean
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 
    FROM public.profiles 
    WHERE email = check_email
  );
END;
$$;