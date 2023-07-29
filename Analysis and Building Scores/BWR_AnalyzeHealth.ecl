#OPTION('obfuscateOutput', TRUE);

IMPORT $,STD;
Life    := $.File_Mortality.File;
State_FIPS  := $.File_StateFIPS.File;

Life_Rec := RECORD
 STRING2 State;
 $.File_Mortality.Layout;
END;

Life_Rec Add_State(Life Lef,State_FIPS Rig) := TRANSFORM
 SELF.State := Rig.State;
 SELF       := Lef;
END; 

AddStateDS := JOIN(Life,State_FIPS,LEFT.FIPS = RIGHT.StateCode+RIGHT.FIPS,Add_State(LEFT,RIGHT),LEFT OUTER,LOOKUP);

OUTPUT(AddStateDS(State <> ' '),NAMED('States_Added'));


CTRec := RECORD
 AddStateDS.State;
 DECIMAL5_2 Average_Mortality := ROUND(AVE(GROUP,AddStateDS.Change_in_Mortality_Rate__1980_2014),2);
 DECIMAL5_2 Max_Mortality := ROUND(AVE(GROUP,AddStateDS.Change_in_Mortality_Rate__1980_2014__Max_),2);
 DECIMAL5_2 Min_Mortality := ROUND(AVE(GROUP,AddStateDS.Change_in_Mortality_Rate__1980_2014__Min_),2);
END;

Tab := TABLE(AddStateDS,CTRec,State);
LifeSum := SORT(Tab,State);
OUTPUT(LifeSum(State <> ' '),,'~FYP::Main::SPRCT::Mortality',NAMED('Mortality_Averages'),OVERWRITE);