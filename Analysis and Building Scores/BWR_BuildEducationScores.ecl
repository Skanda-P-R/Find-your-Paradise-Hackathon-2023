#OPTION('obfuscateOutput', TRUE);

IMPORT $;

School_Rec := RECORD
  STRING2  State;
  INTEGER8 State_Count;
  INTEGER8 Public_Count;
  INTEGER8 Private_Count;
  DECIMAL5_2 Private_Public_Ratio;
  REAL8    Avg_Enrollment_Teacher_Ratio;
 END;
 
School_DSA := DATASET('~FYP::Main::SPRCT::EducationSummary',School_Rec,THOR);

//OUTPUT(School_DSA,NAMED('Input_Data'));

Tab_Rec := RECORD
 School_DSA.State;
 School_DSA.Public_Count;
 School_DSA.Private_Count;
 School_DSA.Avg_Enrollment_Teacher_Ratio;
 UNSIGNED2 Public_School_Score := 0;
 UNSIGNED2 Private_School_Score := 0;
 UNSIGNED2 Enrollment_Teacher_Score := 0;
END;

Tab := TABLE(School_DSA,Tab_Rec);

EnrollmentTeacherScore  := ITERATE(SORT(Tab,-Avg_Enrollment_Teacher_Ratio),TRANSFORM(Tab_Rec,SELF.Enrollment_Teacher_Score := IF(LEFT.Avg_Enrollment_Teacher_Ratio=RIGHT.Avg_Enrollment_Teacher_Ratio,LEFT.Enrollment_Teacher_Score,LEFT.Enrollment_Teacher_Score+1),SELF := RIGHT));
//NOT EnrollmentTeacherScore  := ITERATE(Tab,TRANSFORM(RankTbl,SELF.Enrollment_Teacher_Score := IF(LEFT.Avg_Enrollment_Teacher_Ratio=RIGHT.Avg_Enrollment_Teacher_Ratio,LEFT.Enrollment_Teacher_Score,LEFT.Enrollment_Teacher_Score+1),SELF := RIGHT));
PublicSchoolScore := ITERATE(SORT(EnrollmentTeacherScore,-Public_Count),TRANSFORM(Tab_Rec,SELF.Public_School_Score := IF(LEFT.Public_Count=RIGHT.Public_Count,LEFT.Public_School_Score,LEFT.Public_School_Score+1),SELF := RIGHT));
PrivateSchoolScore := ITERATE(SORT(PublicSchoolScore,-Private_Count),TRANSFORM(Tab_Rec,SELF.Private_School_Score := IF(LEFT.Private_Count=RIGHT.Private_Count,LEFT.Private_School_Score,LEFT.Private_School_Score+1),SELF := RIGHT));
Final := SORT(PrivateSchoolScore,State);

OUTPUT(Final,,'~FYP::Main::SPRCT::EducationScores',NAMED('Education_Scores'),OVERWRITE);
