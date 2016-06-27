;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; AGENTS ARE DEFINED

breed [Governments Government]
breed [Individuals Individual]

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; VARIABLES ARE DEFINED

turtles-own [
  CountryCode
  TimeHorizon
  ExpectedBAUemission
  CCawareness
  CCawarenessDueToDisaster
  PersonalMitigation
  EnforcedMitigation
  Mitigation  
  EmissionList
  Emission 
]

Governments-own [
  MitigationPolicy
  DemocraticValue
]

globals [
  GHG
  CumulativeGHG
  InitBAUemission
  BAUemission
  MitigationGoal
  MitigationGoalPreferences
  NegotiationCooperatorsList
  CumGHG
  Impact
  OpinionDifference
  ChanceForSucces
  InternationalPreferenceList
  ReductionPolicy
  ClimateDisasterYearList
  LocalityOfClimateDisasterList
  ClimateDisasterMemoryCounter
  NegotiationList
  MitigationByIndividuals
  MitigationByGovernments
  EnforcedMitigationByIndividuals
  EnforcedMitigationByGovernments
  TotalEnforcedMitigation
  TotalMitigation
  BottomUpMitigationRatio
  CumulativeGHGreduction
  AnualGHGreduction
  AgreementEffect
  TotalAgreementEffect
  ClimateDisasterEffect
  TotalClimateDisasterEffect  
]

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; SETUP
      
to setup
  clear-all
  reset-ticks

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; GOVERNMENTS AND INDIVIDUALS ARE CREATED AND ATTRIBUTES ARE DISTRIBUTED

    if Distribution = "Random" [
      set TimeHorizonInd1 random 100 set TimehorizonGov1 random 100 set DemocraticValue1 precision (random-float 1) 2
      set TimeHorizonInd2 random 100 set TimehorizonGov2 random 100 set DemocraticValue2 precision (random-float 1) 2
      set TimeHorizonInd3 random 100 set TimehorizonGov3 random 100 set DemocraticValue3 precision (random-float 1) 2
      set TimeHorizonInd4 random 100 set TimehorizonGov4 random 100 set DemocraticValue4 precision (random-float 1) 2
      set TimeHorizonInd5 random 100 set TimehorizonGov5 random 100 set DemocraticValue5 precision (random-float 1) 2
      set TimeHorizonInd6 random 100 set TimehorizonGov6 random 100 set DemocraticValue6 precision (random-float 1) 2
      set TimeHorizonInd7 random 100 set TimehorizonGov7 random 100 set DemocraticValue7 precision (random-float 1) 2
      set TimeHorizonInd8 random 100 set TimehorizonGov8 random 100 set DemocraticValue8 precision (random-float 1) 2
      set TimeHorizonInd9 random 100 set TimehorizonGov9 random 100 set DemocraticValue9 precision (random-float 1) 2
      set TimeHorizonInd10 random 100 set TimehorizonGov10 random 100 set DemocraticValue10 precision (random-float 1) 2]
    
    if Distribution = "Automatic" [
      set TimeHorizonInd1 5 set TimehorizonGov1 16 set DemocraticValue1 0.6
      set TimeHorizonInd2 30 set TimehorizonGov2 5 set DemocraticValue2 0.2
      set TimeHorizonInd3 28 set TimehorizonGov3 30 set DemocraticValue3 0.7
      set TimeHorizonInd4 15 set TimehorizonGov4 12 set DemocraticValue4 0.2
      set TimeHorizonInd5 9 set TimehorizonGov5 19 set DemocraticValue5 0.3
      set TimeHorizonInd6 0 set TimehorizonGov6 0 set DemocraticValue6 0
      set TimeHorizonInd7 0 set TimehorizonGov7 0 set DemocraticValue7 0
      set TimeHorizonInd8 0 set TimehorizonGov8 0 set DemocraticValue8 0
      set TimeHorizonInd9 0 set TimehorizonGov9 0 set DemocraticValue9 0
      set TimeHorizonInd10 0 set TimehorizonGov10 0 set DemocraticValue10 0
      
      set #IndividualsPerGovernment 100
      set #Governments 5]

  create-Individuals (#IndividualsPerGovernment * #Governments) [
    ask Individuals [set CountryCode ceiling ((who + 1) * #Governments / (#IndividualsPerGovernment * #Governments)) ] ; Agents are divided over the different Governments by a CountryCode 
    
    if VisualRepresentation = True [
    set color white
    set shape "circle"
    set size .4
    set xcor random-normal (min-pxcor + (max-pxcor - min-pxcor - 4) / #Governments * CountryCode) 1; Agents are located beneath the Governments with some spread
    set ycor random-normal -5 1]
     
    ask Individuals with [CountryCode = 1] [set TimeHorizon random-normal TimeHorizonInd1 SDTimeHorizonDistribution; Agents are given a TimeHorizon, normally distributed
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd1 SDTimeHorizonDistribution]]; If the normal distribution causes a TimeHorizon to fall outside the boundaries of 0 and 100, it tries again
    ask Individuals with [CountryCode = 2] [set TimeHorizon random-normal TimeHorizonInd2 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd2 SDTimeHorizonDistribution]]
    ask Individuals with [CountryCode = 3] [set TimeHorizon random-normal TimeHorizonInd3 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd3 SDTimeHorizonDistribution]]
    ask Individuals with [CountryCode = 4] [set TimeHorizon random-normal TimeHorizonInd4 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd4 SDTimeHorizonDistribution]]
    ask Individuals with [CountryCode = 5] [set TimeHorizon random-normal TimeHorizonInd5 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd5 SDTimeHorizonDistribution]]
    ask Individuals with [CountryCode = 6] [set TimeHorizon random-normal TimeHorizonInd6 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd6 SDTimeHorizonDistribution]]
    ask Individuals with [CountryCode = 7] [set TimeHorizon random-normal TimeHorizonInd7 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd7 SDTimeHorizonDistribution]]
    ask Individuals with [CountryCode = 8] [set TimeHorizon random-normal TimeHorizonInd8 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd8 SDTimeHorizonDistribution]]
    ask Individuals with [CountryCode = 9] [set TimeHorizon random-normal TimeHorizonInd9 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd9 SDTimeHorizonDistribution]]
    ask Individuals with [CountryCode = 10] [set TimeHorizon random-normal TimeHorizonInd10 SDTimeHorizonDistribution
    while [(TimeHorizon > AmountOfYears) or (TimeHorizon < 0)]  [set TimeHorizon random-normal TimeHorizonInd10 SDTimeHorizonDistribution]]
    
    set EmissionList (list)   
  ]
      
  create-Governments #Governments[
    ask Governments [set CountryCode who - (#IndividualsPerGovernment * #Governments) + 1]; Governments are given a CountryCode as well, to link them to their Individuals 
    
    if VisualRepresentation = True [
    set color white
    set shape "orbit 6"
    set size 1
    set xcor min-pxcor + (max-pxcor - min-pxcor - 4) / #Governments * CountryCode
    set ycor random-normal 8 2
    ask Governments [create-links-with other Governments]]; Links between Governments are made to illustrate that they participate in international Negotiations
    
    let i  1
    while [i <= #Governments] [
      ask Governments with [CountryCode = i] [create-links-with Individuals with [CountryCode = i]]
      set i i + 1]   
      
    ask Governments with [CountryCode = 1] [set TimeHorizon TimeHorizonGov1 set DemocraticValue DemocraticValue1]; Governments are given a TimeHorizon and a democratic value
    ask Governments with [CountryCode = 2] [set TimeHorizon TimeHorizonGov2 set DemocraticValue DemocraticValue2]
    ask Governments with [CountryCode = 3] [set TimeHorizon TimeHorizonGov3 set DemocraticValue DemocraticValue3]
    ask Governments with [CountryCode = 4] [set TimeHorizon TimeHorizonGov4 set DemocraticValue DemocraticValue4]
    ask Governments with [CountryCode = 5] [set TimeHorizon TimeHorizonGov5 set DemocraticValue DemocraticValue5]
    ask Governments with [CountryCode = 6] [set TimeHorizon TimeHorizonGov6 set DemocraticValue DemocraticValue6]
    ask Governments with [CountryCode = 7] [set TimeHorizon TimeHorizonGov7 set DemocraticValue DemocraticValue7]
    ask Governments with [CountryCode = 8] [set TimeHorizon TimeHorizonGov8 set DemocraticValue DemocraticValue8]
    ask Governments with [CountryCode = 9] [set TimeHorizon TimeHorizonGov9 set DemocraticValue DemocraticValue9]
    ask Governments with [CountryCode = 10] [set TimeHorizon TimeHorizonGov10 set DemocraticValue DemocraticValue10]
    
    set EmissionList (list) 
    ]

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; LISTS ARE INITIALISED
   
    set ClimateDisasterYearList (list)
    set LocalityOfClimateDisasterList (list)
    set MitigationGoalPreferences (list)
    set NegotiationCooperatorsList (list)
    set NegotiationList (list)
    set InternationalPreferenceList (list)

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; THE CLIMATE CHANGE IMPACT GRAPH IS CONSTRUCTED
    
    DetermineInitBAUemission
    DetermineImpactGraph
    
end

to DetermineInitBAUemission
  ask Individuals [set InitBAUemission (InitBAUemission + 100)]; Nog beginmitigatie in verwerken
  ask Governments [set InitBAUemission (InitBAUemission + ((#IndividualsPerGovernment / RatioIndividualEmissionNationalEmission) * 100))]
end 

to DetermineImpactGraph
  set CumGHG 0
  while [CumGHG < (InitBAUemission * ImpactFactor / 1000)] [
    set CumGHG (CumGHG + 1)
    set Impact (0 - ((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission * ImpactFactor / 1000)))) + (((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission * ImpactFactor / 1000)) * ExpFactor ^ CumGHG))
    update-plots] 
end
  
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; THE STEPS THAT ARE EXECUTED EVERY TICK

to go
  tick
  DetermineBAUemission
  DetermineExpectedBAUemission
  DetermineCCawareness
  DetermineClimateDisaster
  DetermineMitigationPolicy
  ExecuteNegotiations
  DetermineEmission
  EmitGHG
  DetermineCumulativeGHGreduction
  DetermineAnualGHGreduction
  DetermineAgreementEffect
  DetermineClimateDisasterEffect
end

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; GOVERNMENTS AND INDIVIDUALS DETERMINE CLIMATE CHANGE AWARENESS

to DetermineBAUemission
  set BAUemission 0
  ask Individuals [set BAUemission (BAUemission + ((AmountOfYears - ticks) * (1 - CCawareness - ReductionPolicy)))]
  ask Governments [set BAUemission (BAUemission + ((#IndividualsPerGovernment / RatioIndividualEmissionNationalEmission) * (AmountOfYears - ticks)) * (1 - MitigationPolicy - ReductionPolicy))]
  set BAUemission BAUemission + CumulativeGHG
end   

to DetermineExpectedBAUemission
  ask turtles [ifelse ((AmountOfYears - ticks) > TimeHorizon)
  [set ExpectedBAUemission (random-normal BAUemission (PredictionError * BAUemission)) * (TimeHorizon / (AmountOfYears - ticks))]
  [set ExpectedBAUemission (BAUemission)]]
end

to DetermineCCawareness
  ask turtles [
    set CCawareness (0 - ((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission * ImpactFactor / 1000)))) + (((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission * ImpactFactor / 1000)) * ExpFactor ^ (ExpectedBAUemission / 1000)))    
    if CCawareness > 1 [set CCawareness 1] 
  ]
end

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; CLIMATE DISASTERS

to DetermineClimateDisaster
  if ClimateDisasters = True [    
    if BaseChanceOfClimateDisaster + (EffectOfClimateChangeOnClimateDisasters * (0 - ((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission * ImpactFactor / 1000)))) + 
    (((1 - 0) / (-1 + ExpFactor ^ (InitBAUemission * ImpactFactor / 1000)) * ExpFactor ^ (CumulativeGHG / 1000)))) > random-float 1 [
      let l 1
      while [l <= #Governments] [
        set LocalityOfClimateDisasterList lput l LocalityOfClimateDisasterList
        set l l + 1
      ]
      set ClimateDisasterMemoryCounter ClimateDisasterMemory
      set LocalityOfClimateDisasterList sublist (shuffle LocalityOfClimateDisasterList) 0 random #Governments
      set ClimateDisasterYearList lput (ticks + 2000) ClimateDisasterYearList
      set ClimateDisasterYearList lput LocalityOfClimateDisasterList ClimateDisasterYearList
    ]
    ask turtles [if member? Countrycode LocalityOfClimateDisasterList [set CCawarenessDueToDisaster (InitialSeverityOfClimateDisaster / ClimateDisasterMemory * ClimateDisasterMemoryCounter)]]

 
  if  ClimateDisasterMemoryCounter > 0 [
    ask turtles [
      ifelse ClimateDisasterIncreaseMitigation = True [
        set CCawareness CCawareness + CCawarenessDueToDisaster
        if CCawareness > 1 [set CCawareness 1]]
      [set CCawareness CCawareness - CCawarenessDueToDisaster
        if CCawareness < 0 [set CCawareness 0]]]
    set ClimateDisasterMemoryCounter ClimateDisasterMemoryCounter - 1
  ]
  ]

end

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; GOVERNMENTS DETERMINE NATIONAL MITIGATION POLICY AND BARGAINING POSITION

to DetermineMitigationPolicy
  let j  1
  while [j <= #Governments] [
    ask Governments with [CountryCode = j] [set MitigationPolicy (((mean [CCawareness] of Individuals with [CountryCode = j]) * DemocraticValue) + (CCawareness * (1 - DemocraticValue)))]
    set j j + 1
  ]
end

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; INTERNATIONAL NEGOTIATIONS ON CLIMATE CHANGE RESPONSE

to ExecuteNegotiations
  if InternationalNegotiations = True [
    if (ticks mod YearsbetweenInternationalNegotiations) = 0 [
    ifelse StochasticDeterministicNegotiations = "GameTheory" [
    set NegotiationCooperatorsList (list)
    set MitigationGoal mean [MitigationPolicy] of Governments
    ask Governments [ ; Round 1
      ifelse MitigationPolicy >= MitigationGoal 
      [set MitigationGoalPreferences lput MitigationPolicy MitigationGoalPreferences]
      [set MitigationGoalPreferences lput 0 MitigationGoalPreferences]
    ]
    set MitigationGoal mean MitigationGoalPreferences
    set MitigationGoalPreferences (list)
    ask Governments [ ; Round 2
      ifelse MitigationPolicy >= MitigationGoal 
      [set MitigationGoalPreferences lput MitigationPolicy MitigationGoalPreferences
       set NegotiationCooperatorsList lput CountryCode NegotiationCooperatorsList]
      [set MitigationGoalPreferences lput 0 MitigationGoalPreferences]
    ]
    set MitigationGoal mean MitigationGoalPreferences
    if GameTheory = "Prisoners" [; Round 3, if the negotiations allow for free-rider behaviour
      set NegotiationCooperatorsList (list)
      ask Governments [ 
        if MitigationPolicy >= MitigationGoal 
        [set NegotiationCooperatorsList lput CountryCode NegotiationCooperatorsList]
      ]
    ]
    ask Governments [ifelse member? Countrycode NegotiationCooperatorsList 
    [set EnforcedMitigation (MitigationGoal * MitigationEnforcementFactor * EffectInternationalPolicyOnNationalPolicy)]
    [set EnforcedMitigation 0]]
    ask Individuals [ifelse member? Countrycode NegotiationCooperatorsList 
    [set EnforcedMitigation (MitigationGoal * MitigationEnforcementFactor * EffectInternationalPolicyOnIndividuals)]
    [set EnforcedMitigation 0]]
    
    set NegotiationList lput (ticks + 2000) NegotiationList
    set NegotiationList lput NegotiationCooperatorsList NegotiationList
  ]
  [ask Governments [
    set InternationalPreferenceList lput MitigationPolicy InternationalPreferenceList
    if length InternationalPreferenceList > #Governments [
    set InternationalPreferenceList remove-item 0 InternationalPreferenceList] 
    set OpinionDifference ((max InternationalPreferenceList) - (min InternationalPreferenceList))
    set ChanceForSucces mean InternationalPreferenceList - (OpinionDifference * ImportanceOpinionDifference)
    if ChanceForSucces > (random-float 1 / ChanceForSuccesfulNegotiations) [
      set EnforcedMitigation (ChanceForSucces * MitigationEnforcementFactor)
      set NegotiationList lput (ticks + 2000) NegotiationList]]
  ]
  ]
  ]
end

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; GOVERNMENTS AND INDIVIDUALS DETERMINE GHG EMISSION LEVELS

to DetermineEmission
  set MitigationByIndividuals 0
  set EnforcedMitigationByIndividuals 0
  set TotalEnforcedMitigation 0
  set TotalMitigation 0
  ask Individuals [
    set PersonalMitigation CCawareness
    set MitigationByIndividuals MitigationByIndividuals + PersonalMitigation
    set EnforcedMitigationByIndividuals EnforcedMitigationByIndividuals + EnforcedMitigation
    set Mitigation (PersonalMitigation + EnforcedMitigation)
    set TotalMitigation TotalMitigation + Mitigation
    set EmissionList lput (max list 0 (1 - Mitigation)) EmissionList
    if length EmissionList > EmissionMemory [set EmissionList remove-item 0 EmissionList]]
  set MitigationByGovernments 0
  set EnforcedMitigationByGovernments 0
  ask Governments [
    set PersonalMitigation MitigationPolicy
    set MitigationByGovernments MitigationByGovernments + (PersonalMitigation * #IndividualsPerGovernment / RatioIndividualEmissionNationalEmission)
    set EnforcedMitigationByGovernments EnforcedMitigationByGovernments + (EnforcedMitigation * #IndividualsPerGovernment / RatioIndividualEmissionNationalEmission)
    set Mitigation (PersonalMitigation + EnforcedMitigation)
    set EmissionList lput (max list 0 (1 - Mitigation)) EmissionList
    if length EmissionList > EmissionMemory [set EmissionList remove-item 0 EmissionList]]  
  ask Individuals [set Emission mean EmissionList]
  ask Governments [set Emission (mean EmissionList * #IndividualsPerGovernment / RatioIndividualEmissionNationalEmission)]
  set TotalEnforcedMitigation (EnforcedMitigationByIndividuals + EnforcedMitigationByGovernments)
  set TotalMitigation (MitigationByIndividuals + EnforcedMitigationByIndividuals + MitigationByGovernments + EnforcedMitigationByGovernments)
  set BottomUpMitigationRatio (MitigationByIndividuals / TotalMitigation)
end 

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; GOVERNMENTS AND INDIVIDUALS EMIT GHG
   
to EmitGHG
  set GHG 0
  ask turtles [
    set GHG GHG + Emission
    set CumulativeGHG (CumulativeGHG + Emission)]
end

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
; CALCULATING OUTPUT INDICATORS

to DetermineCumulativeGHGreduction
  set CumulativeGHGreduction ((1 - cumulativeghg / (InitBAUemission * ticks / AmountOfYears)) * 100)
end

to DetermineAnualGHGreduction
  set AnualGHGreduction ((1 - (ghg / ((InitBAUemission * AmountOfYears / 100) / AmountOfYears))) * 100)
end

to DetermineAgreementEffect
  set AgreementEffect (MitigationGoal * length NegotiationCooperatorsList / #Governments)
  set TotalAgreementEffect TotalAgreementEffect + AgreementEffect
end

to DetermineClimateDisasterEffect
  set ClimateDisasterEffect ((InitialSeverityOfClimateDisaster / ClimateDisasterMemory * ClimateDisasterMemoryCounter) * length LocalityOfClimateDisasterList / #Governments)
  set TotalClimateDisasterEffect TotalClimateDisasterEffect + ClimateDisasterEffect
end
@#$#@#$#@
GRAPHICS-WINDOW
1270
60
1515
306
16
16
6.52
1
10
1
1
1
0
0
0
1
-16
16
-16
16
0
0
1
ticks
30.0

BUTTON
15
55
78
88
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
15
150
190
183
#IndividualsPerGovernment
#IndividualsPerGovernment
1
100
100
1
1
NIL
HORIZONTAL

SLIDER
111
248
203
281
TimeHorizonInd1
TimeHorizonInd1
0
100
5
1
1
NIL
HORIZONTAL

SLIDER
111
283
203
316
TimeHorizonInd2
TimeHorizonInd2
0
100
30
1
1
NIL
HORIZONTAL

SLIDER
111
318
203
351
TimeHorizonInd3
TimeHorizonInd3
0
100
28
1
1
NIL
HORIZONTAL

SLIDER
111
353
203
386
TimeHorizonInd4
TimeHorizonInd4
0
100
15
1
1
NIL
HORIZONTAL

TEXTBOX
25
695
490
941
Explanations *\n1. Time horizon of governments on climate change impact [Years]\n2. Average Time Horizon of Citizens on Climate Change Impact [Years]\n3. Democratic Value of governments, indicating the weight that individuals have in expressing their political preference [Factor 0-1]\n4. Standard deviation of time horizon distribution among citizens [Years]\n5. The emission of an agent is determined by taking the average of it's last two years and it's newly determined prefered emission. The reason is that emissionlevels cannot change immediatly. The emission memory determines the amount of years it takes into account to determine it's emission [Years]\n
11
94.0
1

BUTTON
80
55
145
88
NIL
go\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
15
185
190
218
#Governments
#Governments
1
10
5
1
1
NIL
HORIZONTAL

SLIDER
111
388
203
421
TimeHorizonInd5
TimeHorizonInd5
0
100
9
1
1
NIL
HORIZONTAL

SLIDER
111
423
203
456
TimeHorizonInd6
TimeHorizonInd6
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
111
458
203
491
TimeHorizonInd7
TimeHorizonInd7
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
111
493
203
526
TimeHorizonInd8
TimeHorizonInd8
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
111
528
203
561
TimeHorizonInd9
TimeHorizonInd9
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
111
564
203
597
TimeHorizonInd10
TimeHorizonInd10
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
15
20
187
53
AmountOfYears
AmountOfYears
1
100
100
1
1
NIL
HORIZONTAL

BUTTON
145
55
210
88
go
while [ticks < AmountOfYears] [go]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
220
55
285
100
Year
ticks + 2000
17
1
11

PLOT
930
175
1130
325
Cumulative GHG
Time
Cumulative GHG
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks cumulativeghg"
"pen-1" 1.0 0 -7500403 true "" "plotxy ticks ((InitBAUemission * AmountOfYears / 100) * ticks / AmountOfYears)"

PLOT
727
177
927
327
GHG
Time
GHG
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "if ticks > 1 [plot GHG]"
"pen-1" 1.0 0 -7500403 true "" "if ticks > 1 [plot (InitBAUemission * AmountOfYears / 100) / AmountOfYears]"

MONITOR
1135
75
1215
120
GHG reduction
AnualGHGreduction
0
1
11

MONITOR
1135
25
1215
70
cGHG reduction
CumulativeGHGreduction
0
1
11

SLIDER
310
285
485
318
YearsBetweenInternationalNegotiations
YearsBetweenInternationalNegotiations
1
100
10
1
1
NIL
HORIZONTAL

SLIDER
310
615
485
648
RatioIndividualEmissionNationalEmission
RatioIndividualEmissionNationalEmission
0.01
1
0.4
.01
1
NIL
HORIZONTAL

PLOT
310
20
580
190
Climate Change Impact as a function of Cumulative GHG
Expected Cumulative GhG (/1000)
Climate Change Impact
0.0
1.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy cumghg impact"

SLIDER
585
20
677
53
ExpFactor
ExpFactor
1.01
2
1.02
.01
1
NIL
HORIZONTAL

SLIDER
584
58
676
91
ImpactFactor
ImpactFactor
0.1
2
1
.1
1
NIL
HORIZONTAL

TEXTBOX
314
211
481
239
International negotiations on Climate Change\n
11
94.0
1

SLIDER
310
401
485
434
EffectInternationalPolicyOnIndividuals
EffectInternationalPolicyOnIndividuals
0
1
1
0.01
1
NIL
HORIZONTAL

SLIDER
310
436
485
469
EffectInternationalPolicyOnNationalPolicy
EffectInternationalPolicyOnNationalPolicy
0
1
1
0.01
1
NIL
HORIZONTAL

SLIDER
505
285
680
318
BaseChanceOfClimateDisaster
BaseChanceOfClimateDisaster
0
1
0
.01
1
NIL
HORIZONTAL

SLIDER
505
355
680
388
InitialSeverityOfClimateDisaster
InitialSeverityOfClimateDisaster
0
1
0.1
.05
1
NIL
HORIZONTAL

MONITOR
725
760
792
805
CCawInd1
mean [CCawareness] of Individuals with [countrycode = 1]
2
1
11

MONITOR
800
760
867
805
CCawInd2
mean [CCawareness] of Individuals with [countrycode = 2]
2
1
11

MONITOR
875
760
945
805
CCawInd3
mean [CCawareness] of Individuals with [countrycode = 3]
2
1
11

MONITOR
950
760
1017
805
CCawInd4
mean [CCawareness] of Individuals with [countrycode = 4]
2
1
11

MONITOR
1025
761
1092
806
CCawInd5
mean [CCawareness] of Individuals with [countrycode = 5]
2
1
11

MONITOR
1100
761
1167
806
CCawInd6
mean [CCawareness] of Individuals with [countrycode = 6]
2
1
11

MONITOR
1172
761
1239
806
CCawInd7
mean [CCawareness] of Individuals with [countrycode = 7]
17
1
11

MONITOR
1244
761
1311
806
CCawInd8
mean [CCawareness] of Individuals with [countrycode = 8]
2
1
11

MONITOR
1318
761
1385
806
CCawInd9
mean [CCawareness] of Individuals with [countrycode = 9]
2
1
11

MONITOR
1392
761
1462
806
CCawInd10
mean [CCawareness] of Individuals with [countrycode = 10]
2
1
11

SLIDER
15
615
202
648
SDTimeHorizonDistribution
SDTimeHorizonDistribution
0
20
0
1
1
NIL
HORIZONTAL

SLIDER
15
248
107
281
TimeHorizonGov1
TimeHorizonGov1
0
100
16
1
1
NIL
HORIZONTAL

SLIDER
15
283
107
316
TimeHorizonGov2
TimeHorizonGov2
0
100
5
1
1
NIL
HORIZONTAL

SLIDER
15
318
107
351
TimeHorizonGov3
TimeHorizonGov3
0
100
30
1
1
NIL
HORIZONTAL

SLIDER
15
353
107
386
TimeHorizonGov4
TimeHorizonGov4
0
100
12
1
1
NIL
HORIZONTAL

SLIDER
15
388
107
421
TimeHorizonGov5
TimeHorizonGov5
0
100
19
1
1
NIL
HORIZONTAL

SLIDER
15
423
107
456
TimeHorizonGov6
TimeHorizonGov6
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
15
458
107
491
TimeHorizonGov7
TimeHorizonGov7
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
15
493
107
526
TimeHorizonGov8
TimeHorizonGov8
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
15
528
107
561
TimeHorizonGov9
TimeHorizonGov9
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
16
564
108
597
TimeHorizonGov10
TimeHorizonGov10
0
100
0
1
1
NIL
HORIZONTAL

SLIDER
205
248
297
281
DemocraticValue1
DemocraticValue1
0
1
0.6
.01
1
NIL
HORIZONTAL

SLIDER
205
283
297
316
DemocraticValue2
DemocraticValue2
0
1
0.2
.01
1
NIL
HORIZONTAL

SLIDER
205
318
297
351
DemocraticValue3
DemocraticValue3
0
1
0.7
.01
1
NIL
HORIZONTAL

SLIDER
205
353
297
386
DemocraticValue4
DemocraticValue4
0
1
0.2
.01
1
NIL
HORIZONTAL

SLIDER
205
388
297
421
DemocraticValue5
DemocraticValue5
0
1
0.3
.01
1
NIL
HORIZONTAL

SLIDER
205
423
297
456
DemocraticValue6
DemocraticValue6
0
1
0
.01
1
NIL
HORIZONTAL

SLIDER
205
458
297
491
DemocraticValue7
DemocraticValue7
0
1
0
.01
1
NIL
HORIZONTAL

SLIDER
205
493
297
526
DemocraticValue8
DemocraticValue8
0
1
0
.01
1
NIL
HORIZONTAL

SLIDER
205
528
297
561
DemocraticValue9
DemocraticValue9
0
1
0
.01
1
NIL
HORIZONTAL

SLIDER
205
563
297
596
DemocraticValue10
DemocraticValue10
0
1
0
.01
1
NIL
HORIZONTAL

TEXTBOX
61
228
76
246
1*
11
94.0
1

TEXTBOX
155
228
170
246
2*
11
94.0
1

TEXTBOX
251
228
266
246
3*
11
94.0
1

TEXTBOX
20
654
35
672
4*
11
94.0
1

TEXTBOX
20
130
170
148
Agent settings\n
11
94.0
1

SLIDER
205
615
297
648
EmissionMemory
EmissionMemory
2
10
3
1
1
NIL
HORIZONTAL

TEXTBOX
211
654
231
672
5*
11
94.0
1

SLIDER
505
390
680
423
ClimateDisasterMemory
ClimateDisasterMemory
0
20
3
1
1
NIL
HORIZONTAL

TEXTBOX
508
211
658
229
Climate Disasters
11
94.0
1

SWITCH
505
250
680
283
ClimateDisasters
ClimateDisasters
1
1
-1000

CHOOSER
310
320
485
365
GameTheory
GameTheory
"Cooperative" "Prisoners"
0

SLIDER
310
366
485
399
MitigationEnforcementFactor
MitigationEnforcementFactor
0
1
1
.1
1
NIL
HORIZONTAL

MONITOR
1535
700
1615
745
Enforced Mitigation Agreement
Mitigationgoal * MitigationEnforcementFactor
2
1
11

MONITOR
725
810
795
855
CCawGov1
mean [CCawareness] of governments with [countrycode = 1]
2
1
11

MONITOR
800
810
870
855
CCawGov2
mean [CCawareness] of governments with [countrycode = 2]
2
1
11

MONITOR
875
810
945
855
CCawGov3
mean [CCawareness] of governments with [countrycode = 3]
2
1
11

MONITOR
950
810
1020
855
CCawGov4
mean [CCawareness] of governments with [countrycode = 4]
2
1
11

MONITOR
1025
811
1095
856
CCawGov5
mean [CCawareness] of governments with [countrycode = 5]
2
1
11

SWITCH
310
250
485
283
InternationalNegotiations
InternationalNegotiations
0
1
-1000

MONITOR
1535
650
1615
695
NIL
ClimateDisasterMemoryCounter
17
1
11

MONITOR
725
650
1530
695
NIL
ClimateDisasterYearList
17
1
11

MONITOR
725
698
1531
743
NIL
NegotiationList
17
1
11

MONITOR
1100
811
1167
856
CCawGov6
mean [CCawareness] of governments with [countrycode = 6]
2
1
11

MONITOR
1172
811
1239
856
CCawGov7
mean [CCawareness] of governments with [countrycode = 7]
2
1
11

MONITOR
1244
811
1312
856
CCawGov8
mean [CCawareness] of governments with [countrycode = 8]
2
1
11

MONITOR
1318
811
1388
856
CCawGov9
mean [CCawareness] of governments with [countrycode = 9]
2
1
11

MONITOR
1393
811
1462
856
CCawGov10
mean [CCawareness] of governments with [countrycode = 10]
2
1
11

PLOT
725
330
925
480
Voluntary Mitigation
Time
Total GHG emissions reduction
0.0
100.0
0.0
10.0
true
true
"" ""
PENS
"Ind" 1.0 0 -16777216 true "" "if ticks > 1 [plot MitigationByIndividuals]"
"Gov" 1.0 0 -7500403 true "" "if ticks > 1 [plot MitigationByGovernments]"
"Enf" 1.0 0 -14454117 true "" "if ticks > 1 [plot TotalEnforcedMitigation]"
"Total" 1.0 0 -2674135 true "" "if ticks > 1 [plot TotalMitigation]"

PLOT
1135
325
1335
475
Bottom Up Mitigation
time
NIL
0.0
100.0
0.0
1.0
true
true
"" ""
PENS
"IncEnf" 1.0 0 -16777216 true "" "if ticks > 1 [plot BottomUpMitigationRatio]"
"ExlEnf" 1.0 0 -7500403 true "" "if ticks > 1 [plot MitigationByIndividuals / MitigationByGovernments]"

PLOT
929
328
1129
478
Enforced Mitigation
Time
Total GHG emissions reduction
0.0
100.0
0.0
10.0
true
true
"" ""
PENS
"Ind" 1.0 0 -16777216 true "" "if ticks > 1 [plot EnforcedMitigationByIndividuals]"
"Gov" 1.0 0 -7500403 true "" "if ticks > 1 [plot EnforcedMitigationByGovernments]"
"Total" 1.0 0 -2674135 true "" "if ticks > 1 [plot TotalEnforcedMitigation]"

SWITCH
1271
22
1496
55
VisualRepresentation
VisualRepresentation
0
1
-1000

SWITCH
506
426
681
459
ClimateDisasterIncreaseMitigation
ClimateDisasterIncreaseMitigation
0
1
-1000

CHOOSER
505
615
680
660
StochasticDeterministicNegotiations
StochasticDeterministicNegotiations
"GameTheory" "Putnam"
0

SLIDER
505
660
680
693
ImportanceOpinionDifference
ImportanceOpinionDifference
0
1
0.15
.01
1
NIL
HORIZONTAL

SLIDER
505
695
680
728
ChanceForSuccesfulNegotiations
ChanceForSuccesfulNegotiations
1
4
1
1
1
NIL
HORIZONTAL

SLIDER
505
750
680
783
PredictionError
PredictionError
0
1
0
.01
1
NIL
HORIZONTAL

SLIDER
505
320
680
353
EffectOfClimateChangeOnClimateDisasters
EffectOfClimateChangeOnClimateDisasters
0
1
0.5
.1
1
NIL
HORIZONTAL

CHOOSER
195
150
287
195
Distribution
Distribution
"Manual" "Automatic" "Random"
1

PLOT
930
20
1130
170
CumulativeGHGreduction
NIL
NIL
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks CumulativeGHGreduction"

PLOT
726
22
926
172
Anual GHG Reduction
NIL
NIL
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks AnualGHGreduction"

TEXTBOX
695
15
710
896
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
11
0.0
1

TEXTBOX
510
585
660
603
Alternative model structures
11
94.0
1

PLOT
725
485
925
635
Climate Disaster Effect
NIL
NIL
0.0
100.0
0.0
0.1
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks ClimateDisasterEffect"

PLOT
930
485
1130
635
Agreement Effect
NIL
NIL
0.0
100.0
0.0
1.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks AgreementEffect"

PLOT
1135
485
1335
635
Total Climate Disaster Effect
NIL
NIL
0.0
100.0
0.0
3.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks TotalClimateDisasterEffect"

PLOT
1340
485
1540
635
Total Agreement Effect
NIL
NIL
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy ticks TotalAgreementEffect"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

orbit 6
true
0
Circle -7500403 true true 116 11 67
Circle -7500403 true true 26 176 67
Circle -7500403 true true 206 176 67
Circle -7500403 false true 45 45 210
Circle -7500403 true true 26 58 67
Circle -7500403 true true 206 58 67
Circle -7500403 true true 116 221 67

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="100" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>ghg</metric>
    <enumeratedValueSet variable="MitigationEnforcementFactor">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision10">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision3">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EffectInternationalPolicyOnNationalPolicy">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision8">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue3">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue9">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry7">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry5">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ClimateDisasters">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ChanceOfClimateDisaster">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue1">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry2">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#governments">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue7">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue2">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry9">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="AmountOfYears">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ClimateDisasterMemory">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue10">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="SDVisionDistribution">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ImpactFactor">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision6">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EmissionMemory">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue6">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision5">
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="RatioLocalEmissionNationalEmission">
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="InitialSeverityOfClimateDisaster">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry3">
      <value value="70"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision9">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="GameTheory">
      <value value="&quot;Cooperative&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry10">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="ExpFactor">
      <value value="1.14"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue8">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue4">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision7">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision2">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="EffectInternationalPolicyOnIndividuals">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry1">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="YearsBetweenInternationalNegotiations">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry8">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="#persons">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry4">
      <value value="65"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision4">
      <value value="40"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="DemocraticValue5">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="VisionCountry6">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Vision1">
      <value value="15"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
1
@#$#@#$#@
