#OPTION('obfuscateOutput', TRUE);

IMPORT $;
CrimeDSA    := $.File_Composite.CrimeScoreDSA;
EducationDSA       := $.File_Composite.EducationScoreDSA;
MortalityDSA   := $.File_Composite.MortalityScoreDSA;
WeatherDSA  := $.File_Composite.WeatherScoreDSA;
Combine_Layout := $.File_Composite.Layout;

Combine_Layout Total_Score(Combine_Layout Le) := TRANSFORM
 SELF.Paradise_Score := Le.ViolentCrime_Score+Le.Homicide_Score+Le.Rape_Score+Le.AggravatedAssault_Score+Le.Robbery_Score+Le.PropertyCrime_Score+Le.Burglary_Score+Le.Larceny_Score+Le.VehicleTheft_Score+Le.AllCrime_Score+Le.Public_School_Score+Le.Private_School_Score+Le.Enrollment_Teacher_Score+Le.MortalityScore+Le.Weather_Event_Score+Le.Weather_Injury_Score+Le.Weather_Death_Score;
 SELF := Le;
END;                    

//Adding State Names
Crime := PROJECT(CrimeDSA,TRANSFORM(Combine_Layout,SELF.StateName := $.DCT.MapST2Name(LEFT.State),SELF := LEFT,SELF := []));

Crime_Education := JOIN(Crime,EducationDSA,LEFT.State = Right.State,TRANSFORM(Combine_Layout,
                             SELF.Public_Count := RIGHT.Public_Count,
                             SELF.Private_Count    := RIGHT.Private_Count,
                             SELF.Avg_Enrollment_Teacher_Ratio   := RIGHT.Avg_Enrollment_Teacher_Ratio,
                             SELF.Public_School_Score := RIGHT.Public_School_Score,
                             SELF.Private_School_Score := RIGHT.Private_School_Score,
                             SELF.Enrollment_Teacher_Score := RIGHT.Enrollment_Teacher_Score,
                             SELF := LEFT),LOOKUP);

Crime_Education_Mortality := JOIN(Crime_Education,MortalityDSA,LEFT.State = Right.State,TRANSFORM(Combine_Layout,
                                 SELF.Average_Mortality := RIGHT.Average_Mortality,
                                 SELF.Max_Mortality := RIGHT.Max_Mortality,
                                 SELF.Min_Mortality := RIGHT.Min_Mortality,
                                 SELF.MortalityScore := RIGHT.MortalityScore,
                                 SELF := LEFT),LOOKUP);

AllDSA := JOIN(Crime_Education_Mortality,WeatherDSA,LEFT.State = Right.State,TRANSFORM(Combine_Layout,
                    SELF.Weather_Event_Sum := RIGHT.Weather_Event_Sum,
                    SELF.Weather_Injury_Sum := RIGHT.Weather_Injury_Sum,
                    SELF.Weather_Death_Sum := RIGHT.Weather_Death_Sum,
                    SELF.Weather_Event_Score := RIGHT.Weather_Event_Score,
                    SELF.Weather_Injury_Score := RIGHT.Weather_Injury_Score,
                    SELF.Weather_Death_Score := RIGHT.Weather_Death_Score,
                    SELF := LEFT),LOOKUP);
                    

Paradise := PROJECT(AllDSA,Total_Score(LEFT));

Final := SORT(Paradise,Paradise_Score);

OUTPUT(Final,,'~FYP::Main::SPRCT::ParadiseScores',NAMED('Final_Paradise_Scores'),OVERWRITE);
 