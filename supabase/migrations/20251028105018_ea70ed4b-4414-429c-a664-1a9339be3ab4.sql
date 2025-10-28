-- Drop the insecure policy that applies to public role
DROP POLICY IF EXISTS "Authenticated users can manage professors" ON public.professors;

-- Drop the duplicate SELECT policy
DROP POLICY IF EXISTS "Authenticated users can view professors list" ON public.professors;

-- Create new secure policies that only apply to authenticated role
CREATE POLICY "Authenticated users can view professors"
ON public.professors
FOR SELECT
TO authenticated
USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can manage professors"
ON public.professors
FOR ALL
TO authenticated
USING (auth.uid() IS NOT NULL);