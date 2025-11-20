-- Adicionar colunas demográficas à tabela students
ALTER TABLE public.students
ADD COLUMN sexo text,
ADD COLUMN renda_media numeric,
ADD COLUMN raca text;

-- Comentários para documentação
COMMENT ON COLUMN public.students.sexo IS 'Sexo do aluno (Masculino, Feminino, Outro, Prefiro não informar)';
COMMENT ON COLUMN public.students.renda_media IS 'Renda média familiar mensal em reais';
COMMENT ON COLUMN public.students.raca IS 'Raça/Etnia do aluno (Branca, Preta, Parda, Amarela, Indígena, Prefiro não informar)';