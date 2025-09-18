-- Fix security issue: Restrict professor data access to authenticated users only
DROP POLICY IF EXISTS "Anyone can view professors" ON professors;

-- Create new policy that requires authentication
CREATE POLICY "Authenticated users can view professors" 
ON professors 
FOR SELECT 
TO authenticated
USING (true);

-- Keep the existing policy for managing professors (CREATE, UPDATE, DELETE)
-- This already requires authentication: "Authenticated users can manage professors"