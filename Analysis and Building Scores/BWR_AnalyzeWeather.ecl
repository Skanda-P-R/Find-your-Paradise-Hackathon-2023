#OPTION('obfuscateOutput', TRUE);

IMPORT $,STD;
Weath    := $.File_Weather.File;
WeathRec := $.File_Weather.Layout;
St_FIPS   := $.File_StateFIPS.File;

New_WeathRec := RECORD
 UNSIGNED4 Rec_ID;
 STRING2   State;
 WeathRec;
END;

Add_Rec := PROJECT(Weath,TRANSFORM(New_WeathRec,SELF.Rec_ID := COUNTER,SELF.State := '',SELF := LEFT));

Join_State := JOIN(Add_Rec((INTEGER)State_FIPS BETWEEN 1 AND 80),St_FIPS,LEFT.State_Fips=RIGHT.StateCode,TRANSFORM(New_WeathRec,SELF.State := RIGHT.State,SELF := LEFT),LOOKUP,LEFT OUTER);

Weath_Event := RECORD
 Join_State.State;
 Join_State.Event_Type;
 Event_Cnt := COUNT(GROUP);
 Injury := SUM(GROUP,Join_State.injuries_direct)+SUM(GROUP,Join_State.injuries_indirect);
 Deaths := SUM(GROUP,Join_State.deaths_direct)+SUM(GROUP,Join_State.deaths_indirect);   
END; 

Event_Tab := TABLE(Join_State,Weath_Event,State,Event_Type);

Severity_Rec := RECORD
RECORDOF(Event_Tab);
UNSIGNED1 Severity_Code;
END;

Build_Severity_1 := PROJECT(Event_Tab,TRANSFORM(Severity_Rec,SELF.Severity_Code := $.DCT.MapCodeToType(TRIM(LEFT.event_type,LEFT,RIGHT)),SELF := LEFT));


Build_Severity_2 := PROJECT(Build_Severity_1,TRANSFORM(Severity_Rec,SELF.Severity_Code := CASE(LEFT.Event_Type,'Astronomical Low Tide'=> 6,'Tropical Depression' => 4,'Extreme Cold/Wind Chill' => 1,LEFT.Severity_Code),SELF := LEFT));

OUTPUT(Build_Severity_2,NAMED('Severity_Codes'));

Weather_Cnt := RECORD
 Build_Severity_2.State;
 Build_Severity_2.Severity_Code;
 Severity_Count := COUNT(GROUP);
 Injury_Count := SUM(GROUP,Build_Severity_2.Injury);
 Death_Count := SUM(GROUP,Build_Severity_2.Deaths);
END;

Weather_Cnt_Tab := TABLE(Build_Severity_2,Weather_Cnt,State,Severity_Code);
WeatherTab_Sort := SORT(Weather_Cnt_Tab,State);
OUTPUT(WeatherTab_Sort,NAMED('Severity_Count'));

Sum_Severity_Rec := RECORD
 WeatherTab_Sort.State;
 //WeatherTab_Sort.Severity_Code;
 UNSIGNED2 Weather_Event_Sum := SUM(GROUP,WeatherTab_Sort.Severity_Count);
 UNSIGNED2 Weather_Injury_Sum := SUM(GROUP,WeatherTab_Sort.Injury_Count);
 UNSIGNED2 Weather_Death_Sum := SUM(GROUP,WeatherTab_Sort.Death_Count);
END;

Final_Tab := TABLE(WeatherTab_Sort,Sum_Severity_Rec,State);
Final_Tab_Sort:= SORT(Final_Tab,State);


OUTPUT(Final_Tab_Sort,,'~FYP::Main::SPRCT::WeatherStats',NAMED('Weather_Events'),OVERWRITE);