-- Create professors table
CREATE TABLE public.professors (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create courses table (code is optional)
CREATE TABLE public.courses (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  code TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Add course_id and professor_db_id to subjects table
ALTER TABLE public.subjects 
ADD COLUMN course_id UUID REFERENCES public.courses(id),
ADD COLUMN professor_db_id UUID REFERENCES public.professors(id);

-- Enable Row Level Security
ALTER TABLE public.professors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.courses ENABLE ROW LEVEL SECURITY;

-- Create policies for professors
CREATE POLICY "Anyone can view professors" 
ON public.professors 
FOR SELECT 
USING (true);

CREATE POLICY "Authenticated users can manage professors" 
ON public.professors 
FOR ALL 
USING (auth.uid() IS NOT NULL);

-- Create policies for courses
CREATE POLICY "Anyone can view courses" 
ON public.courses 
FOR SELECT 
USING (true);

CREATE POLICY "Authenticated users can manage courses" 
ON public.courses 
FOR ALL 
USING (auth.uid() IS NOT NULL);

-- Add updated_at triggers
CREATE TRIGGER update_professors_updated_at
BEFORE UPDATE ON public.professors
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_courses_updated_at
BEFORE UPDATE ON public.courses
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();