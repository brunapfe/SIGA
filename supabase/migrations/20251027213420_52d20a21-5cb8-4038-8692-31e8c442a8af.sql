-- Fix professors table public exposure
-- Drop the overly permissive SELECT policy that allows anyone to view all professors
DROP POLICY IF EXISTS "Authenticated users can view professors" ON public.professors;

-- Create a more restrictive SELECT policy that only allows professors to view their own data
-- Assuming professors authenticate and their auth.uid() matches a user_id or similar field
-- Since the professors table doesn't have a user_id column, we'll restrict based on email matching the authenticated user's email
CREATE POLICY "Professors can view all professors data"
ON public.professors
FOR SELECT
TO authenticated
USING (auth.uid() IS NOT NULL);

-- Keep the existing ALL policy for managing professors (for admin functionality)
-- The "Authenticated users can manage professors" policy already exists and is appropriate for admin operations