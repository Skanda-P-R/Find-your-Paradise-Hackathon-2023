#OPTION('obfuscateOutput', TRUE);

IMPORT $,STD;

Public  := $.File_PublicSchools.File;
Private := $.File_PrivateSchools.File;

Comb_Rec := RECORD 
    UNSIGNED RecID;
    BOOLEAN Public; 
    STRING X;
    STRING Y;
    STRING FID;        
    STRING DISTRICTID; 
    STRING OBJECTID;
    STRING NCESID;
    STRING NAME;
    STRING ADDRESS;
    STRING CITY;
    STRING STATE;
    STRING ZIP;
    STRING ZIP4;
    STRING TELEPHONE;
    STRING TYPE;
    STRING STATUS;
    STRING POPULATION;
    STRING COUNTY;
    STRING COUNTYFIPS;
    STRING COUNTRY;
    STRING LATITUDE;
    STRING LONGITUDE;
    STRING NAICS_CODE;
    STRING NAICS_DESC;
    STRING SOURCE;
    STRING SOURCEDATE;
    STRING VAL_METHOD;
    STRING VAL_DATE;
    STRING WEBSITE;
    STRING LEVEL;
    STRING ENROLLMENT;  
    STRING START_GRAD;
    STRING END_GRADE;
    STRING FT_TEACHER;  
    STRING SHELTER_ID;
END;

adding_public_details := PROJECT(Public,TRANSFORM(Comb_Rec,SELF.RecID := 0,SELF.fid := 'PUBLIC',SELF.LEVEL := LEFT.LEVEL_,SELF.Public := TRUE,SELF := LEFT));
adding_private_details := PROJECT(Private,TRANSFORM(Comb_Rec,SELF.RecID := 0,SELF.DISTRICTID := 'PRIVATE',SELF.LEVEL := LEFT.LEVEL_,SELF.Public := FALSE,SELF := LEFT));
seqofall             := PROJECT(adding_public_details+adding_private_details,TRANSFORM(Comb_Rec,SELF.RecID := COUNTER,SELF := LEFT));
out                  := OUTPUT(seqofall,,'~FYP::Main::SPRCT::AllUSSchools',OVERWRITE);
temp                 := DATASET('~FYP::Main::SPRCT::AllUSSchools',Comb_Rec,THOR);

bestrecord := STD.DataPatterns.BestRecordStructure(temp);
BestRecOut := OUTPUT(bestrecord,ALL);

SEQUENTIAL(out,BestRecOut);


