IMPORT Visualizer;
HealthDS   := $.File_Composite.MortalityScoreDSA;


state := TABLE(HealthDS, {state, Mortalityscore}, FEW);
OUTPUT(state, NAMED('state_mort'));
Visualizer.Choropleth.USStates('Demo', , 'state_mort', , , DATASET([{'paletteID', 'Purples'}], Visualizer.KeyValueDef));