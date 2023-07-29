#OPTION('obfuscateOutput', TRUE);

Rec := RECORD
  STRING2 State;
  DECIMAL5_2 Average_Mortality;
  DECIMAL5_2 Max_Mortality;
  DECIMAL5_2 Min_Mortality;
END; 

DSA := DATASET('~FYP::Main::SPRCT::Mortality',Rec,FLAT);
 
Mor_Rec := RECORD
 DSA.State;
 DSA.Average_Mortality;
 DSA.Max_Mortality;
 DSA.Min_Mortality;
 UNSIGNED2 MortalityScore := 0;
END;

Tabl := TABLE(DSA,Mor_Rec);

Score := ITERATE(SORT(Tabl,-Average_Mortality),TRANSFORM(Mor_Rec,SELF.MortalityScore := IF(LEFT.Average_Mortality=RIGHT.Average_Mortality,LEFT.MortalityScore,LEFT.MortalityScore+1),SELF := RIGHT));
//NOT MortalityScore := ITERATE(TempTbl,TRANSFORM(RankTbl,SELF.MortalityScore := IF(LEFT.sumcum=RIGHT.sumcum,LEFT.MortalityScore,LEFT.MortalityScore+1),SELF := RIGHT));

Sort_Score := SORT(Score,State);
OUTPUT(Sort_Score,,'~FYP::Main::SPRCT::MortalityScores',NAMED('Mortality_Scores'),OVERWRITE);