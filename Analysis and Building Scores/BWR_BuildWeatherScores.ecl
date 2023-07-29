 #OPTION('obfuscateOutput', TRUE);
 
 WeatherEvent_Rec := RECORD
  STRING2 State;
  UNSIGNED2 Weather_Event_Sum;
  UNSIGNED2 Weather_Injury_Sum;
  UNSIGNED2 Weather_Death_Sum;
 END;
 
 WeatherEvent_DSA := DATASET('~FYP::Main::SPRCT::WeatherStats',WeatherEvent_Rec,FLAT);


Tab_Rec := RECORD
 WeatherEvent_DSA.State;
 WeatherEvent_DSA.Weather_Event_Sum;
 WeatherEvent_DSA.Weather_Injury_Sum;
 WeatherEvent_DSA.Weather_Death_Sum;
 UNSIGNED1 Weather_Event_Score := 0;
 UNSIGNED1 Weather_Injury_Score := 0;
 UNSIGNED1 Weather_Death_Score := 0;
END;

Tab := TABLE(WeatherEvent_DSA,Tab_Rec);

EventScore := ITERATE(SORT(Tab,-Weather_Event_Sum),TRANSFORM(Tab_Rec,SELF.Weather_Event_Score := IF(LEFT.Weather_Event_Sum=RIGHT.Weather_Event_Sum,LEFT.Weather_Event_Score,LEFT.Weather_Event_Score+1),SELF := RIGHT));
//NOT EventScore := ITERATE(Tab,TRANSFORM(Tab_Rec,SELF.Event_Score := IF(LEFT.Event_Sum=RIGHT.Event_Sum,LEFT.Event_Score,LEFT.Event_Score+1),SELF := RIGHT));
InjuryScore := ITERATE(SORT(EventScore,-Weather_Injury_Sum),TRANSFORM(Tab_Rec,SELF.Weather_Injury_Score := IF(LEFT.Weather_Injury_Sum=RIGHT.Weather_Injury_Sum,LEFT.Weather_Injury_Score,LEFT.Weather_Injury_Score+1),SELF := RIGHT));
Final := ITERATE(SORT(InjuryScore,-Weather_Death_Sum),TRANSFORM(Tab_Rec,SELF.Weather_Death_Score := IF(LEFT.Weather_Death_Sum=RIGHT.Weather_Death_Sum,LEFT.Weather_Death_Score,LEFT.Weather_Death_Score+1),SELF := RIGHT));

OUTPUT(SORT(Final,State),,'~FYP::Main::SPRCT::WeatherScores',NAMED('Weather_Severity_Scores'),OVERWRITE);