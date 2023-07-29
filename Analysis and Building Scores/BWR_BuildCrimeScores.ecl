#OPTION('obfuscateOutput', TRUE);

Crime_Rec := RECORD
 STRING2 State;
 DECIMAL5_4   ViolentCrime_Ratio;
 DECIMAL5_4   Homicide_Ratio;
 DECIMAL5_4   Rape_Ratio;
 DECIMAL5_4   AggravatedAssault_Ratio;
 DECIMAL5_4   Robbery_Ratio;    
 DECIMAL5_4   PropertyCrime_Ratio; 
 DECIMAL5_4   Burglary_Ratio;   
 DECIMAL5_4   Larceny_Ratio;    
 DECIMAL5_4   VehicleTheft_Ratio;  
 DECIMAL5_4   AllCrime_Ratio;
END;

DSA := DATASET('~FYP::Main::SPRCT::CrimeRates',Crime_Rec,FLAT);  


Rec := RECORD
 DSA.State;
 DSA.ViolentCrime_Ratio;
 DSA.Homicide_Ratio;
 DSA.Rape_Ratio;
 DSA.AggravatedAssault_Ratio;
 DSA.Robbery_Ratio;    
 DSA.PropertyCrime_Ratio; 
 DSA.Burglary_Ratio;   
 DSA.Larceny_Ratio;    
 DSA.VehicleTheft_Ratio;  
 DSA.AllCrime_Ratio;
 UNSIGNED2 ViolentCrime_Score := 0;
 UNSIGNED2 Homicide_Score := 0;
 UNSIGNED2 Rape_Score := 0;
 UNSIGNED2 AggravatedAssault_Score := 0;
 UNSIGNED2 Robbery_Score := 0;
 UNSIGNED2 PropertyCrime_Score := 0;
 UNSIGNED2 Burglary_Score := 0;
 UNSIGNED2 Larceny_Score := 0;
 UNSIGNED2 VehicleTheft_Score := 0;
 UNSIGNED2 AllCrime_Score := 0;
END;

Tab := TABLE(DSA,Rec);

ViScore := ITERATE(SORT(Tab,-ViolentCrime_Ratio),TRANSFORM(Rec,SELF.ViolentCrime_Score := IF(LEFT.ViolentCrime_Ratio=RIGHT.ViolentCrime_Ratio,LEFT.ViolentCrime_Score,LEFT.ViolentCrime_Score+1),SELF := RIGHT));
//NOT ViScore := ITERATE(SORT(Tab,-ViolentCrime_Ratio),TRANSFORM(Rec,SELF.Violent_Score := IF(LEFT.ViolentCrime_Ratio=RIGHT.ViolentCrime_Ratio,LEFT.Violent_Score,LEFT.Violent_Score+1),SELF := RIGHT));
HoScore := ITERATE(SORT(ViScore,-Homicide_Ratio),TRANSFORM(Rec,SELF.Homicide_Score := IF(LEFT.Homicide_Ratio=RIGHT.Homicide_Ratio,LEFT.Homicide_Score,LEFT.Homicide_Score+1),SELF := RIGHT));
RaScore := ITERATE(SORT(HoScore,-Rape_Ratio),TRANSFORM(Rec,SELF.Rape_Score := IF(LEFT.Rape_Ratio=RIGHT.Rape_Ratio,LEFT.Rape_Score,LEFT.Rape_Score+1),SELF := RIGHT));
AgScore := ITERATE(SORT(RaScore,-AggravatedAssault_Ratio),TRANSFORM(Rec,SELF.AggravatedAssault_Score := IF(LEFT.AggravatedAssault_Ratio=RIGHT.AggravatedAssault_Ratio,LEFT.AggravatedAssault_Score,LEFT.AggravatedAssault_Score+1),SELF := RIGHT));
RoScore := ITERATE(SORT(AgScore,-Robbery_Ratio),TRANSFORM(Rec,SELF.Robbery_Score := IF(LEFT.Robbery_Ratio=RIGHT.Robbery_Ratio,LEFT.Robbery_Score,LEFT.Robbery_Score+1),SELF := RIGHT));
PrScore := ITERATE(SORT(RoScore,-PropertyCrime_Ratio),TRANSFORM(Rec,SELF.PropertyCrime_Score := IF(LEFT.PropertyCrime_Ratio=RIGHT.PropertyCrime_Ratio,LEFT.PropertyCrime_Score,LEFT.PropertyCrime_Score+1),SELF := RIGHT));
BuScore := ITERATE(SORT(PrScore,-Burglary_Ratio),TRANSFORM(Rec,SELF.Burglary_Score := IF(LEFT.Burglary_Ratio=RIGHT.Burglary_Ratio,LEFT.Burglary_Score,LEFT.Burglary_Score+1),SELF := RIGHT));
LaScore := ITERATE(SORT(BuScore,-Larceny_Ratio),TRANSFORM(Rec,SELF.Larceny_Score := IF(LEFT.Larceny_Ratio=RIGHT.Larceny_Ratio,LEFT.Larceny_Score,LEFT.Larceny_Score+1),SELF := RIGHT));
VeScore := ITERATE(SORT(LaScore,-VehicleTheft_Ratio),TRANSFORM(Rec,SELF.VehicleTheft_Score := IF(LEFT.VehicleTheft_Ratio=RIGHT.VehicleTheft_Ratio,LEFT.VehicleTheft_Score,LEFT.VehicleTheft_Score+1),SELF := RIGHT));
AcScore := ITERATE(SORT(VeScore,-AllCrime_Ratio),TRANSFORM(Rec,SELF.AllCrime_Score := IF(LEFT.AllCrime_Ratio=RIGHT.AllCrime_Ratio,LEFT.AllCrime_Score,LEFT.AllCrime_Score+1),SELF := RIGHT));

Sort_AcScore := SORT(AcScore,State);

Final_Rec := RECORD
 Sort_AcScore.State;
 Sort_AcScore.ViolentCrime_Score;
 Sort_AcScore.Homicide_Score;
 Sort_AcScore.Rape_Score;
 Sort_AcScore.AggravatedAssault_Score;
 Sort_AcScore.Robbery_Score;
 Sort_AcScore.PropertyCrime_Score;
 Sort_AcScore.Burglary_Score;
 Sort_AcScore.Larceny_Score;
 Sort_AcScore.VehicleTheft_Score;
 Sort_AcScore.AllCrime_Score;
END;

Final := TABLE(Sort_AcScore,Final_Rec);

OUTPUT(Final,,'~FYP::Main::SPRCT::CrimeScores',NAMED('Crime_Scores'),OVERWRITE);
