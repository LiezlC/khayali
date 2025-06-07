<aside>
💡

// Tracker
let
Source = Excel.Workbook(File.Contents("C:\Users\L1020839\Documents\1Current\DataCompare\Comp Tracker\Merged_master_file_IV.xlsx"), null, true),
#"All CCNs Impacted_Sheet" = Source{[Item="Master_Data",Kind="Table"]}[Data],
#"Renamed Columns1" = Table.RenameColumns(#"All CCNs Impacted_Sheet",{{"HHA Signed (yes-no)", "HHA Signed"}}),
#"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns1",{{"HHA Date", type text}, {"Submitted for Payment", type text}, {"PoP Date", type text}}),
#"Replaced Value2" = Table.ReplaceValue(#"Changed Type1","Yes","",Replacer.ReplaceText,{"Submitted for Payment"}),
#"Replaced Value" = Table.ReplaceValue(#"Replaced Value2","N/A","",Replacer.ReplaceText,{"HHA Date", "PoP Date", "Submitted for Payment"}),
#"Changed Type" = Table.TransformColumnTypes(#"Replaced Value",{{"Period", type text}, {"Impact_area", type text}, {"Type of Impact", type text}, {"Code#", type text}, {"Ag", type text}, {"Full Name (as per ID)", type text}, {"Displacement Type", type text}, {"Displacement Type  per Agreement", type text}, {"Village (Census)", type text}, {"Location Status", type text}, {"Current Location-Residence", type text}, {"Phase_Priority", type text}, {"Phase_Priority - SDE/Notes", type text}, {"Claim Type", type text}, {"CCNs Fixed or New Survey", type text}, {"Compensation Status", type text}, {"Approval Status", type text}, {"Doc Type", type text}, {"ID (Yes/No)", type text}, {"ID No", type text}, {"NUIT", type text}, {"Proof of Residence?#(lf)(Yes/No)", type text}, {"Bank Account? (Yes/No)", type text}, {"HHA Signed", type text}, {"Submitted to Finance(yes-no)", type text}, {"PoP (Cash paid)?", type text}, {"Comments", type text}, {"Comments Category", type text}, {"Intervals_Duration", type text}, {"Duration between Submission & Payment (DAYS)", type number}, {"Duration between Signature and Payment (Months)", type number}, {"Duration between Signature and Payment (DAYS)", type number}, {"Duration between signature and today", type number}, {"Fisheries Voucher amount", type number}, {"Final cash compensation in the HHA (MZN)", type number}, {"HHA Date", type date}, {"Submitted for Payment", type date}, {"PoP Date", type date}, {"HHA Plan Date", type date}}),
#"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"Code#", Text.Trim, type text}, {"Phase_Priority", Text.Trim, type text}}),
#"Renamed Columns" = Table.RenameColumns(#"Trimmed Text",{{"Code#", "Code"}}),
#"Replaced Value1" = Table.ReplaceValue(#"Renamed Columns","178","R0178",Replacer.ReplaceValue,{"Code"}),
#"Cleaned Text" = Table.TransformColumns(#"Replaced Value1",{{"Code", each Text.PadStart(_,5,"0"), type text}}),
#"Added Custom" = Table.AddColumn(#"Cleaned Text", "AgCheck", each [Code]&"|"&[Phase_Priority]),
#"Added Custom1" = Table.AddColumn(#"Added Custom", "Custom", each [AgCheck]=[Ag]),
#"Renamed Columns0" = Table.RenameColumns(#"Added Custom1",{{"Final cash compensation in the HHA (MZN)", "Amount(MZN)"}, {"HHA Signed", "HHA_Signed"}, {"HHA Date", "HHA_Date"}, {"Submitted to Finance(yes-no)", "Submitted_Finance"}, {"Submitted for Payment", "Submitted_Date"}, {"PoP Date", "PoP_Date"}})
in
#"Renamed Columns0"

// Land
let
Source = Tracker,
#"Renamed Columns" = Table.RenameColumns(Source,{{"Code", "CCN"}}),
#"Filtered Rows2" = Table.SelectRows(#"Renamed Columns", each ([Type of Impact] = "Agricultural Land" or [Type of Impact] = "CCN" or [Type of Impact] = "RAL" or [Type of Impact] = "SR")),
#"Filtered Rows" = Table.SelectRows(#"Filtered Rows2", each ([CCN] <> null and [CCN] <> 0)),
#"Replaced Value1" = Table.ReplaceValue(#"Filtered Rows",null,0,Replacer.ReplaceValue,{"Amount(MZN)"}),
#"Rounded Up" = Table.TransformColumns(#"Replaced Value1",{{"Amount(MZN)", Number.RoundUp, Int64.Type}}),
#"Filtered Rows1" = Table.SelectRows(#"Rounded Up", each [Ag] <> "RN0|"),
#"Sorted Rows" = Table.Sort(#"Filtered Rows1",{{"Ag", Order.Ascending}}),
#"Removed Columns" = Table.RemoveColumns(#"Sorted Rows",{"Ag", "Custom"}),
#"Renamed Columns1" = Table.RenameColumns(#"Removed Columns",{{"AgCheck", "Ag"}}),
#"Added Custom" = Table.AddColumn(#"Renamed Columns1", "RR", each if Text.Contains([Impact_area],"_R") = true or [#"Amount(MZN)"]= 250000 then "_R" else ""),
#"Sorted Rows1" = Table.Sort(#"Added Custom",{{"Ag", Order.Ascending}}),
#"Capitalized Each Word" = Table.TransformColumns(#"Sorted Rows1",{{"HHA_Signed", Text.Proper, type text}, {"Submitted_Finance", Text.Proper, type text}, {"PoP (Cash paid)?", Text.Proper, type text}}),
#"Added Custom1" = Table.AddColumn(#"Capitalized Each Word", "HHA_Check", each if[HHA_Signed]="Yes" then [HHA_Date] <> null else if [HHA_Signed]="No" then [HHA_Date] = null else "Check"),
#"Added Custom2" = Table.AddColumn(#"Added Custom1", "CheckSubmit", each if [Submitted_Finance]="Yes" then [Submitted_Date]<> null else if [Submitted_Finance]="No" then [Submitted_Date]= null else "Check"),
#"Added Custom3" = Table.AddColumn(#"Added Custom2", "PoP_Check", each if [#"PoP (Cash paid)?"]="Yes" then [PoP_Date] <> null else if [#"PoP (Cash paid)?"]="No" then [PoP_Date]= null else "Check"),
#"Inserted Merged Column" = Table.AddColumn(#"Added Custom3", "CheckDates", each Text.Combine({Text.From([HHA_Check], "en-US"), Text.From([CheckSubmit], "en-US"), Text.From([PoP_Check], "en-US")}, ";"), type text)
in
#"Inserted Merged Column"

// DuplicateAgID
let
Source = Tracker,
#"Filtered Rows" = Table.SelectRows(Source, each ([Phase_Priority] <> null)),
#"Kept Duplicates" = let columnNames = {"Ag"}, addCount = Table.Group(#"Filtered Rows", columnNames, {{"Count", Table.RowCount, type number}}), selectDuplicates = Table.SelectRows(addCount, each [Count] > 1), removeCount = Table.RemoveColumns(selectDuplicates, "Count") in Table.Join(#"Filtered Rows", columnNames, removeCount, columnNames, JoinKind.Inner)
in
#"Kept Duplicates"

// DuplicateAmount
let
Source = DuplicateAgID,
#"Kept Duplicates" = let columnNames = {"Ag", "Amount(MZN)"}, addCount = Table.Group(Source, columnNames, {{"Count", Table.RowCount, type number}}), selectDuplicates = Table.SelectRows(addCount, each [Count] > 1), removeCount = Table.RemoveColumns(selectDuplicates, "Count") in Table.Join(Source, columnNames, removeCount, columnNames, JoinKind.Inner),
#"Sorted Rows" = Table.Sort(#"Kept Duplicates",{{"Ag", Order.Ascending}}),
#"Filtered Rows" = Table.SelectRows(#"Sorted Rows", each ([#"Amount(MZN)"] <> ""))
in
#"Filtered Rows"

// DupDifferentAmounts
let
Source = DuplicateAgID,
#"Merged Queries" = Table.NestedJoin(Source, {"Ag"}, DuplicateAmount, {"Ag"}, "DuplicateAmount", JoinKind.LeftAnti),
#"Sorted Rows" = Table.Sort(#"Merged Queries",{{"Ag", Order.Ascending}})
in
#"Sorted Rows"

// RevRepAg_R
let
Source = Tracker,
#"Filtered Rows1" = Table.SelectRows(Source, each ([Impact_area] = "Agricultural Land_R")),
#"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows1",{"Impact_area", "Type of Impact", "Code", "Ag", "Phase_Priority", "Amount(MZN)", "HHA_Signed", "HHA_Date", "Submitted_Finance", "Submitted_Date", "PoP (Cash paid)?", "PoP_Date"}),
#"Duplicated Column" = Table.DuplicateColumn(#"Removed Other Columns", "Ag", "AgRAL"),
#"Replaced Value" = Table.ReplaceValue(#"Duplicated Column","_R","",Replacer.ReplaceText,{"AgRAL"})
in
#"Replaced Value"

// RAL_Not_R
let
Source = Tracker,
#"Filtered Rows" = Table.SelectRows(Source, each ([Type of Impact] = "RAL") and ([Impact_area] <> "Agricultural Land_R")),
#"Sorted Rows" = Table.Sort(#"Filtered Rows",{{"Ag", Order.Ascending}})
in
#"Sorted Rows"

// RevRep_El
let
Source = RAL_Not_R,
#"Removed Other Columns" = Table.SelectColumns(Source,{"Impact_area", "Type of Impact", "Code", "Ag", "Phase_Priority", "Amount(MZN)", "HHA_Signed", "HHA_Date", "Submitted_Finance", "Submitted_Date", "PoP (Cash paid)?", "PoP_Date"}),
#"Filtered Rows1" = Table.SelectRows(#"Removed Other Columns", each ([HHA_Signed] = "Yes") or ([HHA_Date] <> null)),
#"Filtered Rows2" = Table.SelectRows(#"Filtered Rows1", each [PoP_Date] = null or [#"PoP (Cash paid)?"] = "No"),
#"Merged Queries" = Table.NestedJoin(#"Filtered Rows2", {"Code"}, AwaitPoP, {"Código RAL "}, "AwaitPoP", JoinKind.LeftOuter),
#"Expanded AwaitPoP" = Table.ExpandTableColumn(#"Merged Queries", "AwaitPoP", {"Count", "#s", "Amount"}, {"AwaitPoP.Count", "AwaitPoP.#s", "AwaitPoP.Amount"})
in
#"Expanded AwaitPoP"

// PrePOP
let
Source = Excel.Workbook(File.Contents("C:\Users\L1020839\Documents\1Current\DataCompare\Comp Tracker\RAL HHAs Impacting Quitunda HH Plots update_13122024.xlsx"), null, true),
Table2_Table = Source{[Item="Table2",Kind="Table"]}[Data],
#"Changed Type" = Table.TransformColumnTypes(Table2_Table,{{"Código RAL ", type text}, {"#", type text}, {"Data de Assinatura do Acordo", type date}})
in
#"Changed Type"

// AwaitPoP
let
Source = PrePOP,
#"Grouped Rows" = Table.Group(Source, {"Código RAL "}, {{"Count", each Table.RowCount(_), Int64.Type}, {"#s", each Text.Combine(List.Sort([#"#"],Order.Ascending),";"), type text}, {"Amount", each List.Sum([#"Valor do acordo (MZN)"]), type number}}),
#"Replaced Value" = Table.ReplaceValue(#"Grouped Rows","R","",Replacer.ReplaceText,{"Código RAL "})
in
#"Replaced Value"

// RevRep_ElAg_R
let
Source = RAL_Not_R,
#"Removed Other Columns" = Table.SelectColumns(Source,{"Impact_area", "Type of Impact", "Code", "Ag", "Phase_Priority", "Amount(MZN)", "HHA_Signed", "HHA_Date", "Submitted_Finance", "Submitted_Date", "PoP (Cash paid)?", "PoP_Date"}),
#"Merged Queries" = Table.NestedJoin(#"Removed Other Columns", {"Ag"}, RevRepAg_R, {"AgRAL"}, "RalR", JoinKind.LeftOuter),
#"Expanded RalR" = Table.ExpandTableColumn(#"Merged Queries", "RalR", {"Ag", "Amount(MZN)", "HHA_Signed", "HHA_Date", "Submitted_Finance", "Submitted_Date", "PoP (Cash paid)?", "PoP_Date"}, {"[RalR.Ag](http://ralr.ag/)", "RalR.Amount(MZN)", "RalR.HHA_Signed", "RalR.HHA_Date", "RalR.Submitted_Finance", "RalR.Submitted_Date", "RalR.PoP (Cash paid)?", "RalR.PoP_Date"}),
#"Merged Queries1" = Table.NestedJoin(#"Expanded RalR", {"Ag"}, RevRep_El, {"Ag"}, "RevRel", JoinKind.LeftOuter),
#"Expanded RevRel" = Table.ExpandTableColumn(#"Merged Queries1", "RevRel", {"Ag", "AwaitPoP.Count"}, {"[RevRel.Ag](http://revrel.ag/)", "RevRel.AwaitPoP.Count"}),
#"Filtered Rows2" = Table.SelectRows(#"Expanded RevRel", each ([RevRel.AwaitPoP.Count] = null)),
#"Removed Columns" = Table.RemoveColumns(#"Filtered Rows2",{"RevRel.AwaitPoP.Count"}),
#"Inserted Merged Column" = Table.AddColumn(#"Removed Columns", "RRR", each Text.Combine({[[RalR.Ag](http://ralr.ag/)], [[RevRel.Ag](http://revrel.ag/)]}, ";"), type text),
#"Cleaned Text" = Table.TransformColumns(#"Inserted Merged Column",{{"RRR", each Text.TrimStart(_,";"), type text}}),
#"Filtered Rows1" = Table.SelectRows(#"Cleaned Text", each ([RRR] <> "")),
#"Renamed Columns" = Table.RenameColumns(#"Filtered Rows1",{{"[RalR.Ag](http://ralr.ag/)", "RevRep.Ag_R"}, {"[RevRel.Ag](http://revrel.ag/)", "[Eligible.Ag](http://eligible.ag/)"}}),
#"Added Custom" = Table.AddColumn(#"Renamed Columns", "RevRelStatus", each if Text.Contains([RRR],";") then "Eligible&RepAg" else if [[Eligible.Ag](http://eligible.ag/)] is null then "RepAg_NotEligible" else if [RevRep.Ag_R] is null then "Eligible_NoRepAg" else "NA"),
#"Changed Type" = Table.TransformColumnTypes(#"Added Custom",{{"HHA_Date", type date}, {"Submitted_Date", type date}, {"PoP_Date", type date}, {"RalR.HHA_Date", type date}, {"RalR.Submitted_Date", type date}, {"RalR.PoP_Date", type date}})
in
#"Changed Type"

// PrePOP_AmountCheck
let
Source = RevRep_El,
#"Filtered Rows" = Table.SelectRows(Source, each ([AwaitPoP.Count] <> null)),
#"Sorted Rows" = Table.Sort(#"Filtered Rows",{{"Ag", Order.Ascending}}),
#"Merged Queries1" = Table.NestedJoin(#"Sorted Rows", {"Code", "HHA_Date"}, PrePOP, {"Código RAL ", "Data de Assinatura do Acordo"}, "PrePOP", JoinKind.LeftOuter),
#"Expanded PrePOP" = Table.ExpandTableColumn(#"Merged Queries1", "PrePOP", {"#", "Valor do acordo (MZN)"}, {"PrePOP.#", "PrePOP.Valor do acordo (MZN)"}),
#"Added Custom" = Table.AddColumn(#"Expanded PrePOP", "AmountCheck", each [#"Amount(MZN)"]=[#"PrePOP.Valor do acordo (MZN)"])
in
#"Added Custom"

// CheckDates
let
Source = Land,
#"Removed Other Columns" = Table.SelectColumns(Source,{"CCN", "HHA_Signed", "HHA_Date", "Submitted_Finance", "Submitted_Date", "PoP (Cash paid)?", "PoP_Date", "Ag", "HHA_Check", "CheckSubmit", "PoP_Check", "CheckDates"}),
#"Reordered Columns" = Table.ReorderColumns(#"Removed Other Columns",{"CCN", "Ag", "HHA_Signed", "HHA_Date", "Submitted_Finance", "Submitted_Date", "PoP (Cash paid)?", "HHA_Check", "CheckSubmit", "PoP_Check", "CheckDates"}),
#"Filtered Rows" = Table.SelectRows(#"Reordered Columns", each ([CheckDates] <> "true;true;true"))
in
#"Filtered Rows"

</aside>