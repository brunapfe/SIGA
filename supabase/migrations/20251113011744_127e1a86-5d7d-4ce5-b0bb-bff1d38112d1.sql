-- Add fields to courses table
ALTER TABLE public.courses 
ADD COLUMN total_semesters integer NOT NULL DEFAULT 8,
ADD COLUMN start_date date NOT NULL DEFAULT CURRENT_DATE;

-- Make course code required (NOT NULL)
UPDATE public.courses SET code = 'CURSO-' || SUBSTRING(id::text, 1, 8) WHERE code IS NULL;
ALTER TABLE public.courses ALTER COLUMN code SET NOT NULL;

-- Drop the old RLS policy first (before dropping the column it depends on)
DROP POLICY IF EXISTS "Professors can manage students in their subjects" ON public.students;

-- Change students table to link to courses instead of subjects
-- First, add the new course_id column
ALTER TABLE public.students ADD COLUMN course_id uuid;

-- Update existing students to link to their subject's course
UPDATE public.students 
SET course_id = (
  SELECT course_id 
  FROM public.subjects 
  WHERE subjects.id = students.subject_id
);

-- Make course_id NOT NULL after populating it
ALTER TABLE public.students ALTER COLUMN course_id SET NOT NULL;

-- Add foreign key constraint
ALTER TABLE public.students 
ADD CONSTRAINT students_course_id_fkey 
FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;

-- Now drop the old subject_id constraint and column
ALTER TABLE public.students DROP CONSTRAINT IF EXISTS students_subject_id_fkey;
ALTER TABLE public.students DROP COLUMN subject_id;

-- Create new RLS policy for students to check course ownership
CREATE POLICY "Professors can manage students in their courses" 
ON public.students 
FOR ALL 
USING (
  EXISTS (
    SELECT 1
    FROM public.subjects
    WHERE subjects.course_id = students.course_id 
    AND subjects.professor_id = auth.uid()
  )
);