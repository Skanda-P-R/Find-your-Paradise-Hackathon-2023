#OPTION('obfuscateOutput', TRUE);

IMPORT $,STD;
Crime    := $.File_Crimes.File;
Crime_Rec := $.File_Crimes.Layout;

Rec := RECORD
  Crime.state_abbr;
  Population_Avg := ROUND(AVE(GROUP,Crime.population));
  ViolentCrime_Avg := ROUND(AVE(GROUP,Crime.violent_crime));
  Homicide_Avg := ROUND(AVE(GROUP,Crime.homicide));
  Rape_Avg := ROUND(AVE(GROUP,Crime.rape_legacy));
  Robbery_Avg := ROUND(AVE(GROUP,Crime.Robbery));
  AggravatedAssault_Avg := ROUND(AVE(GROUP,Crime.aggravated_assault));
  PropertyCrime_Avg := ROUND(AVE(GROUP,Crime.property_crime));
  Burglary_Avg := ROUND(AVE(GROUP,Crime.burglary));
  Larceny_Avg := ROUND(AVE(GROUP,Crime.larceny));
  VehicleTheft_Avg := ROUND(AVE(GROUP,Crime.motor_vehicle_theft));
END;

Tab := TABLE(Crime(state_abbr <> ' '),Rec,State_abbr);
OUTPUT(SORT(Tab,state_abbr),NAMED('Average_Crimes'));


Ratios_Rec := RECORD
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

Ratios_Rec Calc_Ratios(Tab Le) := TRANSFORM
 SELF.State             := Le.State_Abbr;
 SELF.ViolentCrime_Ratio := (Le.ViolentCrime_Avg/Le.Population_Avg)*100;
 SELF.Homicide_Ratio       := (Le.Homicide_Avg/Le.Population_Avg)*100;
 SELF.Rape_Ratio           := (Le.Rape_Avg/Le.Population_Avg)*100;
 SELF.AggravatedAssault_Ratio    := (Le.AggravatedAssault_Avg/Le.Population_Avg*100);
 SELF.Robbery_Ratio        := (Le.Robbery_Avg/Le.Population_Avg)*100;
 SELF.PropertyCrime_Ratio     := (Le.PropertyCrime_Avg/Le.Population_Avg)*100;
 SELF.Burglary_Ratio       := (Le.Burglary_Avg/Le.Population_Avg)*100;
 SELF.Larceny_Ratio        := (Le.Larceny_Avg/Le.Population_Avg)*100;
 SELF.VehicleTheft_Ratio      := (Le.VehicleTheft_Avg/Le.Population_Avg)*100;
 SELF.AllCrime_Ratio       := (((Le.ViolentCrime_Avg+Le.Robbery_Avg+Le.PropertyCrime_Avg+Le.Burglary_Avg+Le.Larceny_Avg+Le.VehicleTheft_Avg+Le.AggravatedAssault_Avg+Le.Rape_Avg+Le.Homicide_Avg)/9)/Le.Population_Avg)*100;
END;

Final_Ratios := PROJECT(Tab,Calc_Ratios(LEFT));
OUTPUT(Final_Ratios,,'~FYP::Main::SPRCT::CrimeRates',NAMED('CrimeRatiosByPopulation'),OVERWRITE);









