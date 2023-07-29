EXPORT File_Crimes := MODULE

 EXPORT Layout := RECORD
  UNSIGNED2 year;
  STRING2   state_abbr;
  STRING20  state_name;
  UNSIGNED5 population;
  UNSIGNED4 violent_crime;
  UNSIGNED3 homicide;
  UNSIGNED3 rape_legacy;
  UNSIGNED3 rape_revised;
  UNSIGNED3 robbery;
  UNSIGNED4 aggravated_assault;
  UNSIGNED4 property_crime;
  UNSIGNED4 burglary;
  UNSIGNED4 larceny;
  UNSIGNED4 motor_vehicle_theft;
  STRING577 caveats;
 END;

EXPORT File := DATASET('~fyp::main::input::estimated_crimes_1979_2020',Layout,CSV(HEADING(1)));

END;