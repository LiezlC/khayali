<aside>
💡

// Tracker
let
Source = Excel.Workbook(File.Contents("C:\Users\L1020839\Documents\1Current\DataCompare\Comp Tracker\MasterTracker_ Query.xlsx"), null, true)
in
Source

// CompTracker
let
Source = Tracker,
Land_Table = Source{[Item="Land",Kind="Table"]}[Data],
#"Sorted Rows" = Table.Sort(Land_Table,{{"Ag", Order.Ascending}}),
#"Filtered Rows" = Table.SelectRows(#"Sorted Rows", each ([Ag] <> null) and ([Impact_area] <> "Agricultural Land_R")),
#"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"CCN", "Displacement Type", "Phase_Priority", "Amount(MZN)", "HHA_Signed", "HHA_Date", "Submitted_Finance", "Submitted_Date", "PoP (Cash paid)?", "PoP_Date", "Comments", "Ag", "RR"}),
#"Renamed Columns" = Table.RenameColumns(#"Removed Other Columns",{{"Amount(MZN)", "Final"}}),
#"Replaced Value" = Table.ReplaceValue(#"Renamed Columns",null,"",Replacer.ReplaceValue,{"HHA_Date", "PoP_Date"}),
#"Changed Type" = Table.TransformColumnTypes(#"Replaced Value",{{"Phase_Priority", type text}, {"Displacement Type", type text}, {"Ag", type text}, {"CCN", type text}}),
#"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"Phase_Priority", Text.Trim, type text}, {"Displacement Type", Text.Trim, type text}, {"Ag", Text.Trim, type text}, {"CCN", Text.Trim, type text}}),
#"Cleaned Text" = Table.TransformColumns(#"Trimmed Text",{{"Phase_Priority", Text.Clean, type text}, {"Displacement Type", Text.Clean, type text}, {"Ag", Text.Clean, type text}, {"CCN", Text.Clean, type text}}),
#"Merged Columns" = Table.CombineColumns(#"Cleaned Text",{"Ag", "RR"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"Ag"),
#"Trimmed Text1" = Table.TransformColumns(#"Merged Columns",{{"Ag", Text.Trim, type text}})
in
#"Trimmed Text1"

// SDE
let
Source = Excel.Workbook(File.Contents("C:\Users\L1020839\Documents\1Current\DataCompare\AllData\Asset_Import_All.xlsx"), null, true),
AgSum_Table = Source{[Item="AgSum",Kind="Table"]}[Data],
#"Renamed Columns" = Table.RenameColumns(AgSum_Table,{{"Phase_Priority", "Phase"}}),
#"Trimmed Text" = Table.TransformColumns(#"Renamed Columns",{{"Phase", Text.Trim, type text},{"Ag", Text.Trim, type text}}),
#"Sorted Rows" = Table.Sort(#"Trimmed Text",{{"Ag", Order.Ascending}}),
#"Changed Type" = Table.TransformColumnTypes(#"Sorted Rows",{{"CCN", type text}}),
#"Cleaned Text" = Table.TransformColumns(#"Changed Type",{{"CCN",  each Text.PadStart(_,5,"0"), type text}}),
#"Trimmed Text1" = Table.TransformColumns(#"Cleaned Text",{{"Phase", Text.Trim, type text}, {"CCN", Text.Trim, type text}, {"DT_HH", Text.Trim, type text}, {"Ag", Text.Trim, type text}, {"DT", Text.Trim, type text}}),
#"Cleaned Text1" = Table.TransformColumns(#"Trimmed Text1",{{"Phase", Text.Clean, type text}, {"CCN", Text.Clean, type text}, {"DT_HH", Text.Clean, type text}, {"Ag", Text.Clean, type text}, {"DT", Text.Clean, type text}})
in
#"Cleaned Text1"

// Pay_Data_Compare
let
Source = CompTracker,
#"Renamed Columns" = Table.RenameColumns(Source,{{"Ag", "[Comp.Ag](http://comp.ag/)"}, {"CCN", "Comp.CCN"}, {"Phase_Priority", "Comp.Phase"}}),
#"Merged Queries1" = Table.NestedJoin(#"Renamed Columns", {"[Comp.Ag](http://comp.ag/)"}, AgSumSDE, {"Ag"}, "Data", JoinKind.FullOuter),
#"Expanded Data" = Table.ExpandTableColumn(#"Merged Queries1", "Data", {"Ag", "CCN", "Phase", "Amount_OR", "Amount_NR"}, {"[Data.Ag](http://data.ag/)", "Data.CCN", "Data.Phase", "Amount_OR", "Amount_NR"}),
#"Replaced Value" = Table.ReplaceValue(#"Expanded Data",null,0,Replacer.ReplaceValue,{"Amount_OR", "Amount_NR", "Final"}),
#"Reordered Columns" = Table.ReorderColumns(#"Replaced Value",{"[Comp.Ag](http://comp.ag/)", "Comp.CCN", "Comp.Phase", "[Data.Ag](http://data.ag/)",  "Data.CCN", "Data.Phase", "Amount_OR", "Amount_NR"}),
#"Grouped Rows" = Table.Group(#"Reordered Columns", {"[Data.Ag](http://data.ag/)", "Data.CCN", "Data.Phase", "[Comp.Ag](http://comp.ag/)", "Comp.CCN", "Comp.Phase", "Final", "HHA_Date", "PoP_Date"}, {{"Amount_OR", each List.Sum([Amount_OR]), type number}, {"Amount_NR", each List.Sum([Amount_NR]), type number}}),
#"Replaced Value1" = Table.ReplaceValue(#"Grouped Rows",null,"",Replacer.ReplaceValue,{"HHA_Date", "PoP_Date","Data.Phase","Data.CCN","[Data.Ag](http://data.ag/)","Comp.Phase","Comp.CCN","[Comp.Ag](http://comp.ag/)"}),
#"Sorted Rows" = Table.Sort(#"Replaced Value1",{{"[Data.Ag](http://data.ag/)", Order.Ascending}, {"[Comp.Ag](http://comp.ag/)", Order.Ascending}})
in
#"Sorted Rows"

// AgSumSDE
let
Source = SDE,
#"Grouped Rows" = Table.Group(Source, {"Phase", "CCN", "Ag", "Amount_OR", "Amount_NR"}, {{"Count", each Table.RowCount(_), Int64.Type}})
in
#"Grouped Rows"

// Data_Pay_Compare
let
Source = AgSumSDE,
#"Grouped Rows" = Table.Group(Source, {"Ag", "CCN", "Phase"}, {{"Amount_OR", each List.Sum([Amount_OR]), type number}, {"Amount_NR", each List.Sum([Amount_NR]), type number}}),
#"Renamed Columns" = Table.RenameColumns(#"Grouped Rows",{{"Ag", "[Data.Ag](http://data.ag/)"}, {"CCN", "Data.CCN"}, {"Phase", "Data.Phase"}}),
#"Merged Queries" = Table.NestedJoin(#"Renamed Columns", {"[Data.Ag](http://data.ag/)"}, CompTracker, {"Ag"}, "Comp", JoinKind.FullOuter),
#"Expanded Data" = Table.ExpandTableColumn(#"Merged Queries", "Comp", {"Phase_Priority", "CCN", "Ag", "Final",  "HHA_Date", "PoP_Date"}, {"Comp.Phase", "Comp.CCN", "[Comp.Ag](http://comp.ag/)",  "Final",  "HHA_Date", "PoP_Date"}),
#"Replaced Value" = Table.ReplaceValue(#"Expanded Data",null,0,Replacer.ReplaceValue,{"Amount_OR", "Amount_NR", "Final"}),
#"Reordered Columns" = Table.ReorderColumns(#"Replaced Value",{"[Comp.Ag](http://comp.ag/)", "Comp.CCN", "Comp.Phase", "[Data.Ag](http://data.ag/)",  "Data.CCN", "Data.Phase", "Amount_OR", "Amount_NR"}),
#"Grouped Rows1" = Table.Group(#"Reordered Columns", {"[Data.Ag](http://data.ag/)", "Data.CCN", "Data.Phase", "[Comp.Ag](http://comp.ag/)", "Comp.CCN", "Comp.Phase", "Final",  "HHA_Date", "PoP_Date"}, {{"Amount_OR", each List.Sum([Amount_OR]), type number}, {"Amount_NR", each List.Sum([Amount_NR]), type number}}),
#"Replaced Value1" = Table.ReplaceValue(#"Grouped Rows1",null,"",Replacer.ReplaceValue,{"HHA_Date", "PoP_Date","Data.Phase","Data.CCN","[Data.Ag](http://data.ag/)","Comp.Phase","Comp.CCN","[Comp.Ag](http://comp.ag/)"}),
#"Sorted Rows" = Table.Sort(#"Replaced Value1",{{"[Comp.Ag](http://comp.ag/)", Order.Ascending}, {"[Data.Ag](http://data.ag/)", Order.Ascending}})
in
#"Sorted Rows"

// Compare
let
Source = Table.Combine({Pay_Data_Compare, Data_Pay_Compare}),
#"Removed Duplicates" = Table.Distinct(Source),
#"Rounded Up" = Table.TransformColumns(#"Removed Duplicates",{{"Final", Number.RoundUp, Int64.Type}, {"Amount_OR", Number.RoundUp, Int64.Type}, {"Amount_NR", Number.RoundUp, Int64.Type}}),
#"Added Custom" = Table.AddColumn(#"Rounded Up", "Ag", each if [[Comp.Ag](http://comp.ag/)] = null or [[Comp.Ag](http://comp.ag/)] = "" or [[Comp.Ag](http://comp.ag/)] = [[Data.Ag](http://data.ag/)] then [[Data.Ag](http://data.ag/)] else if [[Data.Ag](http://data.ag/)] = null or [[Data.Ag](http://data.ag/)] = "" then [[Comp.Ag](http://comp.ag/)] else [[Comp.Ag](http://comp.ag/)]&":"&[[Data.Ag](http://data.ag/)], type text),
#"Sorted Rows1" = Table.Sort(#"Added Custom",{{"Ag", Order.Ascending}}),
#"Added Custom1" = Table.AddColumn(#"Sorted Rows1", "CCN", each if [Comp.CCN] = null or [Comp.CCN] = [Data.CCN] or [Comp.CCN] = "" then [Data.CCN] else if [Data.CCN] = null or [Data.CCN] = "" then [Comp.CCN] else [Comp.CCN]&":"&[Data.CCN], type text),
#"Added Custom2" = Table.AddColumn(#"Added Custom1", "Phase_Priority", each if [Comp.Phase] = null or [Comp.Phase] = [Data.Phase] or [Comp.Phase] = "" then [Data.Phase] else if [Data.Phase] = null or [Data.Phase] = "" then [Comp.Phase] else [Comp.Phase]&":"&[Data.Phase], type text),
#"Added Custom3" = Table.AddColumn(#"Added Custom2", "Change_OR", each Number.Abs([Amount_OR]-[Final])),
#"Added Custom4" = Table.AddColumn(#"Added Custom3", "Change_NR", each Number.Abs([Amount_NR]-[Final])),
#"Changed Type1" = Table.TransformColumnTypes(#"Added Custom4",{{"Ag", type text}, {"CCN", type text}, {"Phase_Priority", type text}}),
#"Cleaned Text" = Table.TransformColumns(#"Changed Type1",{{"Ag", Text.Clean, type text}, {"CCN", Text.Clean, type text}, {"Phase_Priority", Text.Clean, type text}}),
#"Trimmed Text" = Table.TransformColumns(#"Cleaned Text",{{"Ag", Text.Trim, type text}, {"CCN", Text.Trim, type text}, {"Phase_Priority", Text.Trim, type text}}),
#"Removed Duplicates1" = Table.Distinct(#"Trimmed Text"),
#"Replaced Value1" = Table.ReplaceValue(#"Removed Duplicates1",null,"",Replacer.ReplaceValue,{"Ag", "CCN", "Phase_Priority", "HHA_Date", "PoP_Date","Comp.CCN", "Data.CCN"}),
#"Added Custom7" = Table.AddColumn(#"Replaced Value1", "MatchDetail", each if [Comp.CCN] = "" then "NoComp"

else if [Data.CCN] = "" then "NoData"
else if Number.Abs([Final]-[Amount_NR]) <100 then "MatchFinalNR"
else if Number.Abs([Final]-[Amount_OR]) <100 then "MatchFinalOR"
else "NoRateMatch"),
#"Added Custom8" = Table.AddColumn(#"Added Custom7", "MatchStatus",
each if Text.Contains([MatchDetail],"Final") then "AmountsMatch"
else if [MatchDetail]="NoData" or [MatchDetail] = "NoComp" then [MatchDetail]
else  "MisMatch"),
#"Added Custom5" = Table.AddColumn(#"Added Custom8", "Signed",
each if [HHA_Date] is null or [HHA_Date] = "" then
if [PoP_Date] is null or [PoP_Date] = "" then "NoHHA"
else "Signed"
else "Signed"),
#"Added Custom6" = Table.AddColumn(#"Added Custom5", "CompStatus", each if [PoP_Date] is null or [PoP_Date] = ""
then [Signed]
else "Paid"),
#"Removed Other Columns1" = Table.SelectColumns(#"Added Custom6",{"Final", "HHA_Date", "PoP_Date", "Amount_OR", "Amount_NR", "Ag", "CCN", "Phase_Priority", "MatchDetail", "MatchStatus", "CompStatus"}),
#"Sorted Rows" = Table.Sort(#"Removed Other Columns1",{{"Ag", Order.Ascending}}),
#"Reordered Columns" = Table.ReorderColumns(#"Sorted Rows",{"Ag", "CCN", "Phase_Priority", "Amount_OR", "Amount_NR", "Final", "HHA_Date", "PoP_Date", "MatchStatus", "MatchDetail", "CompStatus"}),
#"Changed Type" = Table.TransformColumnTypes(#"Reordered Columns",{{"HHA_Date", type date}, {"PoP_Date", type date}, {"CompStatus", type text}, {"MatchDetail", type text}, {"MatchStatus", type text}, {"Ag", type text}, {"CCN", type text}, {"Phase_Priority", type text}}),
#"Added Custom9" = Table.AddColumn(#"Changed Type", "Impact", each if Text.Contains([Phase_Priority],"P4") then "RAL" else "DUAT"),
#"Sorted Rows2" = Table.Sort(#"Added Custom9",{{"Ag", Order.Ascending}}),
#"Added Custom10" = Table.AddColumn(#"Sorted Rows2", "OR-Final", each [Amount_OR]-[Final]),
#"Added Custom11" = Table.AddColumn(#"Added Custom10", "NR-Final", each [Amount_NR]-[Final]),
#"Changed Type2" = Table.TransformColumnTypes(#"Added Custom11",{{"NR-Final", type number}, {"OR-Final", type number}}),
#"Sorted Rows3" = Table.Sort(#"Changed Type2",{{"Ag", Order.Ascending}})
in
#"Sorted Rows3"

// CompTrackerCombined
let
Source = CompTracker,
#"Changed Type" = Table.TransformColumnTypes(Source,{{"PoP_Date", type text}, {"HHA_Date", type text}}),
#"Grouped Rows" = Table.Group(#"Changed Type", {"CCN", "Ag", "Phase_Priority"}, {{"Finals", each List.Sum([Final]), type nullable number}, {"HHA_Dates", each Text.Combine(List.Sort([HHA_Date],Order.Ascending),";"), type nullable text}, {"PoP_Dates", each Text.Combine(List.Sort([PoP_Date],Order.Ascending),";"), type nullable text}})
in
#"Grouped Rows"

// Compare_NoData
let
Source = Compare,
#"Filtered Rows" = Table.SelectRows(Source, each ([MatchStatus] = "NoData")),
#"Sorted Rows" = Table.Sort(#"Filtered Rows",{{"Ag", Order.Ascending}})
in
#"Sorted Rows"

// Compare_NoComp
let
Source = Compare,
#"Filtered Rows" = Table.SelectRows(Source, each ([MatchStatus] = "NoComp")),
#"Sorted Rows" = Table.Sort(#"Filtered Rows",{{"Ag", Order.Ascending}})
in
#"Sorted Rows"

// NoCompData
let
Source = Compare_NoComp,
#"Removed Columns" = Table.RemoveColumns(Source,{"Final", "HHA_Date", "PoP_Date", "MatchStatus", "MatchDetail", "Impact", "OR-Final", "NR-Final"}),
#"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Phase_Priority", "Data.Phase"}, {"Ag", "[Data.Ag](http://data.ag/)"}}),
#"Merged Queries" = Table.NestedJoin(#"Renamed Columns", {"CCN"}, Compare_NoData, {"CCN"}, "Comp", JoinKind.Inner),
#"Expanded Comp" = Table.ExpandTableColumn(#"Merged Queries", "Comp", {"Ag", "CCN", "Phase_Priority", "Final", "CompStatus"}, {"[Comp.Ag](http://comp.ag/)", "Comp.CCN", "Comp.Phase", "Final", "Comp.Status"}),
#"Added Custom" = Table.AddColumn(#"Expanded Comp", "Final-OR", each Number.Abs([Final]-[Amount_OR])),
#"Added Custom1" = Table.AddColumn(#"Added Custom", "Final-NR", each Number.Abs([Final]-[Amount_NR])),
#"Added Custom2" = Table.AddColumn(#"Added Custom1", "CheckPhase", each if[#"Final-OR"]=0 or [#"Final-NR"]=0 then "CheckPhaseMatch" else "NoMatch")
in
#"Added Custom2"

// PhaseCheck
let
Source = NoCompData,
#"Sorted Rows" = Table.Sort(Source,{{"CCN", Order.Ascending}}),
#"Filtered Rows1" = Table.SelectRows(#"Sorted Rows", each ([CheckPhase] = "CheckPhaseMatch")),
#"Sorted Rows1" = Table.Sort(#"Filtered Rows1",{{"[Data.Ag](http://data.ag/)", Order.Ascending}}),
#"Merged Columns" = Table.CombineColumns(#"Sorted Rows1",{"CheckPhase", "CompStatus"},Combiner.CombineTextByDelimiter("_", QuoteStyle.None),"Status"),
#"Replaced Value" = Table.ReplaceValue(#"Merged Columns","Match","",Replacer.ReplaceText,{"Status"})
in
#"Replaced Value"

// Status
let
Source = Compare,
#"Replaced Value" = Table.ReplaceValue(Source,"Amounts","",Replacer.ReplaceText,{"MatchStatus"}),
#"Merged Columns" = Table.CombineColumns(#"Replaced Value",{"MatchStatus", "CompStatus"},Combiner.CombineTextByDelimiter("_", QuoteStyle.None),"Status"),
#"Removed Other Columns" = Table.SelectColumns(#"Merged Columns",{"Ag", "CCN", "Phase_Priority", "Status", "Impact"}),
#"Merged Queries" = Table.NestedJoin(#"Removed Other Columns", {"Ag"}, PhaseCheck, {"[Data.Ag](http://data.ag/)"}, "PhaseCheck", JoinKind.LeftOuter),
#"Expanded PhaseCheck" = Table.ExpandTableColumn(#"Merged Queries", "PhaseCheck", {"CheckPhase"}, {"CheckPhase"}),
#"Merged Columns1" = Table.CombineColumns(Table.TransformColumnTypes(#"Expanded PhaseCheck", {{"CheckPhase", type text}}, "en-US"),{"Status", "CheckPhase"},Combiner.CombineTextByDelimiter(" ", QuoteStyle.None),"Status"),
#"Trimmed Text" = Table.TransformColumns(#"Merged Columns1",{{"Status", Text.Trim, type text}}),
#"Merged Queries1" = Table.NestedJoin(#"Trimmed Text", {"Ag"}, PhaseCheck, {"[Data.Ag](http://data.ag/)"}, "PhaseCheck", JoinKind.LeftOuter),
#"Expanded PhaseCheck1" = Table.ExpandTableColumn(#"Merged Queries1", "PhaseCheck", {"Status"}, {"PhaseCheck.Status"}),
#"Added Custom" = Table.AddColumn(#"Expanded PhaseCheck1", "Custom", each if[PhaseCheck.Status] is null then [Status] else [PhaseCheck.Status]),
#"Removed Columns" = Table.RemoveColumns(#"Added Custom",{"Status", "PhaseCheck.Status"}),
#"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Custom", "Status"}}),
#"Sorted Rows" = Table.Sort(#"Renamed Columns",{{"Ag", Order.Ascending}})
in
#"Sorted Rows"

// SDEStat
let
Source = SDE,
#"Grouped Rows" = Table.Group(Source, {"Phase", "CCN", "Ag"}, {{"Count", each Table.RowCount(_), Int64.Type}, {"status0", each Text.Combine(List.Sort([status0],Order.Ascending),";"), type text}})
in
#"Grouped Rows"

// StatCheck
let
Source = AgSumSDE,
#"Filtered Rows" = Table.SelectRows(Source, each ([Count] = 2)),
#"Merged Queries" = Table.NestedJoin(#"Filtered Rows", {"Ag"}, SDEStat, {"Ag"}, "SDEStat", JoinKind.LeftOuter),
#"Expanded SDEStat" = Table.ExpandTableColumn(#"Merged Queries", "SDEStat", {"Phase", "CCN", "Ag", "status0", "Count"}, {"SDEStat.Phase", "SDEStat.CCN", "[SDEStat.Ag](http://sdestat.ag/)", "SDEStat.status0", "SDEStat.Count"})
in
#"Expanded SDEStat"

// SDEStatCheck
let
Source = SDEStat,
#"Merged Queries" = Table.NestedJoin(Source, {"Ag"}, Status, {"Ag"}, "Status.1", JoinKind.FullOuter),
#"Expanded Status.1" = Table.ExpandTableColumn(#"Merged Queries", "Status.1", {"Ag", "Status"}, {"[Status.1.Ag](http://status.1.ag/)", "Status.1.Status"}),
#"Added Custom" = Table.AddColumn(#"Expanded Status.1", "Custom", each [status0]=[Status.1.Status]),
#"Added Custom1" = Table.AddColumn(#"Added Custom", "Custom.1", each [Ag] is null or [[Status.1.Ag](http://status.1.ag/)] is null or [Custom] = false),
#"Merged Queries1" = Table.NestedJoin(#"Added Custom1", {"[Status.1.Ag](http://status.1.ag/)"}, Compare, {"Ag"}, "Compare", JoinKind.LeftOuter),
#"Expanded Compare" = Table.ExpandTableColumn(#"Merged Queries1", "Compare", {"Amount_OR", "Amount_NR", "Final", "HHA_Date", "PoP_Date", "MatchStatus", "MatchDetail", "CompStatus", "Impact", "OR-Final", "NR-Final"}, {"Amount_OR", "Amount_NR", "Final", "HHA_Date", "PoP_Date", "MatchStatus", "MatchDetail", "CompStatus", "Impact", "OR-Final", "NR-Final"}),
#"Filtered Rows" = Table.SelectRows(#"Expanded Compare", each ([Custom] = false) and ([status0] <> "Inital Load" and [status0] <> "Initial Load") and ([Status.1.Status] <> "Match_Paid")),
#"Sorted Rows" = Table.Sort(#"Filtered Rows",{{"status0", Order.Descending}})
in
#"Sorted Rows"

</aside>