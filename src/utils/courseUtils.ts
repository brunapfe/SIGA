export const calculateCurrentSemester = (startDate: string, totalSemesters: number): number => {
  const start = new Date(startDate);
  const now = new Date();
  
  // Calculate months difference
  const monthsDiff = (now.getFullYear() - start.getFullYear()) * 12 + 
                     (now.getMonth() - start.getMonth());
  
  // Each semester is 6 months
  const semestersPassed = Math.floor(monthsDiff / 6) + 1;
  
  // Return current semester, capped at total semesters
  return Math.min(semestersPassed, totalSemesters);
};
