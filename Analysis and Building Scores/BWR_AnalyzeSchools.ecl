#OPTION('obfuscateOutput', TRUE);

IMPORT $,STD;
Schools := $.File_AllSchools.File;

Rec := RECORD
 Schools.RecID;
 Schools.Public;
 Schools.State;
 Schools.Level;
 Schools.Enrollment;
 Schools.ft_teacher;
 EnrollTeachRatio := ROUND(Schools.Enrollment/Schools.ft_teacher);
END;

Edu_Tab   := TABLE(Schools,Rec);
Clean_Edu_Tab := Edu_Tab(EnrollTeachRatio > 1,Enrollment >= 20);

Edu_Rec := RECORD
 Clean_Edu_Tab.State;
 State_Count     := COUNT(GROUP);
 Public_Count    := COUNT(GROUP,Clean_Edu_Tab.Public=TRUE);
 Private_Count   := COUNT(GROUP,Clean_Edu_Tab.Public=FALSE);
 DECIMAL5_2 Private_Public_Ratio   := 0;
 Avg_Enrollment_Teacher_Ratio := ROUND(AVE(GROUP,Clean_Edu_Tab.EnrollTeachRatio),2);
END;

Edu_Cnt := TABLE(Clean_Edu_Tab,Edu_Rec,State);
Edu := PROJECT(Edu_Cnt,TRANSFORM(RECORDOF(Edu_Cnt),SELF.Private_Public_Ratio := (LEFT.Private_Count/LEFT.Public_Count) * 100,SELF := LEFT));
Final := SORT(Edu,State);
OUTPUT(Final,,'~FYP::Main::SPRCT::EducationSummary',NAMED('Education_Ratios'),OVERWRITE);