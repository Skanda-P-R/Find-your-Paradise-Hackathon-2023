EXPORT File_Composite := MODULE
//Crime
 EXPORT CrimeScore_Rec := RECORD
  STRING2   State;
  UNSIGNED2 ViolentCrime_Score;
  UNSIGNED2 Homicide_Score;
  UNSIGNED2 Rape_Score;
  UNSIGNED2 AggravatedAssault_Score;
  UNSIGNED2 Robbery_Score;
  UNSIGNED2 PropertyCrime_Score;
  UNSIGNED2 Burglary_Score;
  UNSIGNED2 Larceny_Score;
  UNSIGNED2 VehicleTheft_Score;
  UNSIGNED2 AllCrime_Score;
 END;
 
 EXPORT CrimeScoreDSA := DATASET('~FYP::Main::SPRCT::CrimeScores',CrimeScore_Rec,FLAT);

//Education
 EXPORT EducationScore_Rec := RECORD
  STRING2   State;
  INTEGER8  Public_Count;
  INTEGER8  Private_Count;
  REAL8     Avg_Enrollment_Teacher_Ratio;
  UNSIGNED2 Public_School_Score;
  UNSIGNED2 Private_School_Score;
  UNSIGNED2 Enrollment_Teacher_Score;
 END;

 EXPORT EducationScoreDSA := DATASET('~FYP::Main::SPRCT::EducationScores',EducationScore_Rec,FLAT);
 
 //Health
 EXPORT MortalityScore_Rec := RECORD
  STRING2    State;
  DECIMAL5_2 Average_Mortality;
  DECIMAL5_2 Max_Mortality;
  DECIMAL5_2 Min_Mortality;
  UNSIGNED2  MortalityScore;
 END;

 EXPORT MortalityScoreDSA := DATASET('~~FYP::Main::SPRCT::MortalityScores',MortalityScore_Rec,FLAT);
 
//Weather
 EXPORT WeatherScore_Rec := RECORD
  STRING2   State;
  UNSIGNED2 Weather_Event_Sum;
  UNSIGNED2 Weather_Injury_Sum;
  UNSIGNED2 Weather_Death_Sum;
  UNSIGNED1 Weather_Event_Score;
  UNSIGNED1 Weather_Injury_Score;
  UNSIGNED1 Weather_Death_Score;
 END;
 
 EXPORT WeatherScoreDSA := DATASET('~FYP::Main::SPRCT::WeatherScores',WeatherScore_Rec,FLAT);
 
EXPORT Layout := RECORD
  STRING2  State;
  STRING20 StateName;
  UNSIGNED2 Paradise_Score;
  UNSIGNED2 ViolentCrime_Score;
  UNSIGNED2 Homicide_Score;
  UNSIGNED2 Rape_Score;
  UNSIGNED2 AggravatedAssault_Score;
  UNSIGNED2 Robbery_Score;
  UNSIGNED2 PropertyCrime_Score;
  UNSIGNED2 Burglary_Score;
  UNSIGNED2 Larceny_Score;
  UNSIGNED2 VehicleTheft_Score;
  UNSIGNED2 AllCrime_Score;
  INTEGER8  Public_Count;
  INTEGER8  Private_Count;
  REAL8     Avg_Enrollment_Teacher_Ratio;
  UNSIGNED2 Public_School_Score;
  UNSIGNED2 Private_School_Score;
  UNSIGNED2 Enrollment_Teacher_Score;
  DECIMAL5_2 Average_Mortality;
  DECIMAL5_2 Max_Mortality;
  DECIMAL5_2 Min_Mortality;
  UNSIGNED2  MortalityScore;
  UNSIGNED2 Weather_Event_Sum;
  UNSIGNED2 Weather_Injury_Sum;
  UNSIGNED2 Weather_Death_Sum;
  UNSIGNED1 Weather_Event_Score;
  UNSIGNED1 Weather_Injury_Score;
  UNSIGNED1 Weather_Death_Score;
 END;
 EXPORT File    := DATASET('~FYP::Main::SPRCT::ParadiseScores',Layout,THOR);
 EXPORT IDX     := INDEX(File,{Paradise_Score},{File},'~FYP::Main::SPRCT::ParadiseIndex');
 EXPORT BLD_IDX := BUILD(IDX,OVERWRITE);
END;

