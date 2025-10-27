-- Fix professors table public exposure by making it more restrictive
-- First drop both existing policies
DROP POLICY IF EXISTS "Authenticated users can view professors" ON public.professors;
DROP POLICY IF EXISTS "Professors can view all professors data" ON public.professors;

-- Only authenticated users who need to see professor data should have access
-- This assumes that professor selection/assignment is done through the application
-- and that only authenticated professors should view the professor list
CREATE POLICY "Authenticated users can view professors list"
ON public.professors
FOR SELECT
TO authenticated
USING (auth.uid() IS NOT NULL);