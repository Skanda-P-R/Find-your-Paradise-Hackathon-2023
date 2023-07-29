EXPORT File_Mortality := MODULE
EXPORT Layout := RECORD
    STRING42 Location;
    STRING5 FIPS;
    STRING65 Category;
    REAL4 Mortality_Rate__1980_;
    REAL4 Mortality_Rate__1980___Min_;
    REAL4 Mortality_Rate__1980___Max_;
    REAL4 Mortality_Rate__1985_;
    REAL4 Mortality_Rate__1985___Min_;
    REAL4 Mortality_Rate__1985___Max_;
    REAL4 Mortality_Rate__1990_;
    REAL4 Mortality_Rate__1990___Min_;
    REAL4 Mortality_Rate__1990___Max_;
    REAL4 Mortality_Rate__1995_;
    REAL4 Mortality_Rate__1995___Min_;
    REAL4 Mortality_Rate__1995___Max_;
    REAL4 Mortality_Rate__2000_;
    REAL4 Mortality_Rate__2000___Min_;
    REAL4 Mortality_Rate__2000___Max_;
    REAL4 Mortality_Rate__2005_;
    REAL4 Mortality_Rate__2005___Min_;
    REAL4 Mortality_Rate__2005___Max_;
    REAL4 Mortality_Rate__2010_;
    REAL4 Mortality_Rate__2010___Min_;
    REAL4 Mortality_Rate__2010___Max_;
    REAL4 Mortality_Rate__2014_;
    REAL4 Mortality_Rate__2014___Min_;
    REAL4 Mortality_Rate__2014___Max_;
    REAL4 Change_in_Mortality_Rate__1980_2014;
    REAL4 Change_in_Mortality_Rate__1980_2014__Min_;
    REAL4 Change_in_Mortality_Rate__1980_2014__Max_;
END;

EXPORT File := DATASET('~fyp::main::input::mortalitybyuscounty',layout,CSV(HEADING(1)));

END;