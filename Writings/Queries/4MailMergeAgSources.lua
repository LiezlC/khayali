// SummaryData
let
    Source = Folder.Files("C:\Users\L1020839\Documents\Agreements\SummaryData")
in
    Source

// Import
let
    Source = SummaryData,
    #"C:\Users\L1020839\Documents\Agreements\SummaryData\_Asset_Import_AgAll xlsx" = Source{[#"Folder Path"="C:\Users\L1020839\Documents\Agreements\SummaryData\",Name="Asset_Import_AgAll.xlsx"]}[Content],
    #"Imported Excel Workbook" = Excel.Workbook(#"C:\Users\L1020839\Documents\Agreements\SummaryData\_Asset_Import_AgAll xlsx")
in
    #"Imported Excel Workbook"

// Asset_Import
let
    Source = Import,
    Asset_Import_Table = Source{[Item="Asset_Import",Kind="Table"]}[Data],
    #"Renamed Columns" = Table.RenameColumns(Asset_Import_Table,{{"Quantity", "Quantidade"}, {"Unit", "Unidade"}, {"Rate", "Taxa"}, {"Amount", "Montante"},{"Classe Do Bem", "ClasseDoBem"}, {"Tipo Do Bem", "TipoDoBem"}}),
    #"Grouped Rows" = Table.Group(#"Renamed Columns", {"Ag", "CCN", "Phase_Priority","DT", "Asset_Class", "ClasseDoBem", "TipoDoBem", "Unidade", "Taxa"}, {{"Quantidade", each List.Sum([Quantidade]), type number}, {"Montante", each List.Sum([Montante]), type number}})
in
    #"Grouped Rows"

// HH_Ent
let
    Source = Import,
    HH_Ent_Table = Source{[Item="HH_Ent",Kind="Table"]}[Data],
    #"Replaced Value" = Table.ReplaceValue(HH_Ent_Table,"Economical","Económica",Replacer.ReplaceText,{"DT"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Physical","Física",Replacer.ReplaceText,{"DT"})
in
    #"Replaced Value1"

// fields
let
    Source = Excel.CurrentWorkbook(){[Name="Append1"]}[Content]
in
    Source

// HHs
let
    Source = fields,
    #"Filtered Rows1" = Table.SelectRows(Source, each ([Tables] = "HHs")),
    #"Transposed Table" = Table.Transpose(#"Filtered Rows1"),
    #"Promoted Headers" = Table.PromoteHeaders(#"Transposed Table", [PromoteAllScalars=true]),
    #"Filtered Rows" = Table.SelectRows(#"Promoted Headers", each ([Ag] <> "HHs")),
    #"Appended Query" = Table.Combine({#"Filtered Rows", HH_Ent}),
    #"Filtered Rows2" = Table.SelectRows(#"Appended Query", each ([Ag] <> null))
in
    #"Filtered Rows2"

// Cash
let
    Source = fields,
    #"Filtered Rows" = Table.SelectRows(Source, each ([Tables] = "Cash")),
    #"Transposed Table" = Table.Transpose(#"Filtered Rows"),
    #"Promoted Headers" = Table.PromoteHeaders(#"Transposed Table", [PromoteAllScalars=true]),
    #"Filtered Rows1" = Table.SelectRows(#"Promoted Headers", each ([Ag] <> "Cash")),
    #"Appended Query" = Table.Combine({#"Filtered Rows1", Asset_Import}),
    #"Replaced Value" = Table.ReplaceValue(#"Appended Query","sqm","m2",Replacer.ReplaceText,{"Unidade"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","unit","No.",Replacer.ReplaceText,{"Unidade"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","Land","1Land",Replacer.ReplaceText,{"Asset_Class"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","Crops","2Crops",Replacer.ReplaceText,{"Asset_Class"}),
    #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3","Tree","3Tree",Replacer.ReplaceText,{"Asset_Class"}),
    #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","Structure","4Structure",Replacer.ReplaceText,{"Asset_Class"}),
    #"Replaced Value6" = Table.ReplaceValue(#"Replaced Value5","TA","5TA",Replacer.ReplaceText,{"Asset_Class"}),
    #"Filtered Rows2" = Table.SelectRows(#"Replaced Value6", each [Asset_Class] <> "Residence" and [Asset_Class] <> "Grave"),
    #"Sorted Rows" = Table.Sort(#"Filtered Rows2",{{"Ag", Order.Ascending}, {"Asset_Class", Order.Ascending}}),
    #"Merged Queries" = Table.NestedJoin(#"Sorted Rows", {"Ag"}, HHs, {"Ag"}, "HHs", JoinKind.Inner),
    #"Filtered Rows3" = Table.SelectRows(#"Merged Queries", each ([ClasseDoBem] <> null)),
    #"Reordered Columns" = Table.ReorderColumns(#"Filtered Rows3",{"Ag", "CCN", "Phase_Priority", "ClasseDoBem", "TipoDoBem", "Unidade", "Quantidade", "Taxa", "Montante", "DT", "Asset_Class", "HHs"})
in
    #"Reordered Columns"

// Kind
let
    Source = fields,
    #"Filtered Rows" = Table.SelectRows(Source, each ([Tables] = "InKind") and ([Fields] <> "CCN" and [Fields] <> "DT" and [Fields] <> "Phase_Priority")),
    #"Transposed Table" = Table.Transpose(#"Filtered Rows"),
    #"Promoted Headers" = Table.PromoteHeaders(#"Transposed Table", [PromoteAllScalars=true]),
    #"Filtered Rows1" = Table.SelectRows(#"Promoted Headers", each ([Ag] <> "InKind")),
    #"Appended Query" = Table.Combine({#"Filtered Rows1", InKind}),
    #"Replaced Value" = Table.ReplaceValue(#"Appended Query","Não","Não / Hapana",Replacer.ReplaceText,{"Agriculture restoration", "Alternative livelihoods", "Fisheries material assistance", "Fisheries restoration", "In kind business", "In kind communities", "In kind grave", "In kind replacement land", "In kind residential", "In kind tree saplings", "In kind vulnerable", "Preferred employment", "Skills Development", "Transitional allowance (food coupon)"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Sim","Sim / Ndio",Replacer.ReplaceText,{"Agriculture restoration", "Alternative livelihoods", "Fisheries material assistance", "Fisheries restoration", "In kind business", "In kind communities", "In kind grave", "In kind replacement land", "In kind residential", "In kind tree saplings", "In kind vulnerable", "Preferred employment", "Skills Development", "Transitional allowance (food coupon)"}),
    #"Merged Queries" = Table.NestedJoin(#"Replaced Value1", {"Ag"}, HHs, {"Ag"}, "HHs", JoinKind.Inner),
    #"Removed Errors" = Table.RemoveRowsWithErrors(#"Merged Queries", {"CCN", "Phase_Priority"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Errors",{"Ag", "CCN", "Phase_Priority", "DT", "Árvore", "Total Perdido", "Total Substituído", "Campas", "Classe Do Bem", "HHs", "Agriculture restoration", "Alternative livelihoods", "Fisheries material assistance", "Fisheries restoration", "In kind business", "In kind communities", "In kind grave", "In kind replacement land", "In kind residential", "In kind tree saplings", "In kind vulnerable", "Preferred employment", "Skills Development", "Transitional allowance (food coupon)"}),
    #"Removed Columns" = Table.RemoveColumns(#"Reordered Columns",{"HHs", "Classe Do Bem"})
in
    #"Removed Columns"

// InKind
let
    Source = Import,
    InKind_Table = Source{[Item="InKind",Kind="Table"]}[Data],
    #"Replaced Value" = Table.ReplaceValue(InKind_Table,"Economical","Económica",Replacer.ReplaceText,{"DT"})
in
    #"Replaced Value"



    // FRN
let
    Source = Folder.Files("C:\Users\L1020839\Documents\1Current\FRN\Fcsv")
in
    Source

// CompSummary
let
    Source = FRN,
    #"C:\Users\L1020839\Documents\1Current\FRN\Fcsv\_res_fish_compensation_summary csv" = Source{[#"Folder Path"="C:\Users\L1020839\Documents\1Current\FRN\Fcsv\",Name="res_fish_compensation_summary.csv"]}[Content],
    #"Imported CSV" = Csv.Document(#"C:\Users\L1020839\Documents\1Current\FRN\Fcsv\_res_fish_compensation_summary csv",[Delimiter=",", Columns=30, Encoding=1252, QuoteStyle=QuoteStyle.Csv]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars=true]),
    #"Sorted Rows" = Table.Sort(#"Promoted Headers",{{"document_number", Order.Descending}}),
    #"Cleaned Text" = Table.TransformColumns(#"Sorted Rows",{{"registration_number", each Text.PadStart(_,4,"0"), type text},{"document_number", each Text.PadStart(_,4,"0"), type text}})
in
    #"Cleaned Text"

// CompDetail
let
    Source = FRN,
    #"C:\Users\L1020839\Documents\1Current\FRN\Fcsv\_res_fish_compensation_detail csv" = Source{[#"Folder Path"="C:\Users\L1020839\Documents\1Current\FRN\Fcsv\",Name="res_fish_compensation_detail.csv"]}[Content],
    #"Imported CSV" = Csv.Document(#"C:\Users\L1020839\Documents\1Current\FRN\Fcsv\_res_fish_compensation_detail csv",[Delimiter=",", Encoding=1252, QuoteStyle=QuoteStyle.Csv]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars=true]),
    #"Sorted Rows" = Table.Sort(#"Promoted Headers",{{"document_number", Order.Ascending}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Sorted Rows",{{"registration_number", type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Changed Type",{{"registration_number", each Text.PadStart(_,4,"0"), type text},{"document_number", each Text.PadStart(_,4,"0"), type text}}),
    #"Sorted Rows1" = Table.Sort(#"Cleaned Text",{{"document_number", Order.Descending}}),
    #"Inserted Merged Column" = Table.AddColumn(#"Sorted Rows1", "Merged", each Text.Combine({[base], [activity], [vessel_class]}, "|"), type text)
in
    #"Inserted Merged Column"

// MergeData
let
    Source = CompDetail,
    #"Removed Other Columns" = Table.SelectColumns(Source,{"objectid", "agreement_status", "document_number", "phase", "base", "residence_village", "activity", "vessel_class", "name", "ccn", "registration_number", "id_number", "id_type", "percent_impact", "multiplier", "ma_amount", "ts_amount"}),
    #"Merged Queries" = Table.NestedJoin(#"Removed Other Columns", {"registration_number"}, CompSummary, {"registration_number"}, "CompSummary", JoinKind.LeftOuter),
    #"Replaced Value0" = Table.ReplaceValue(#"Merged Queries","Ã","a",Replacer.ReplaceText,{"name"}),
    #"Replaced Value10" = Table.ReplaceValue(#"Replaced Value0","¡","",Replacer.ReplaceText,{"name"}),
    #"Replaced Value20" = Table.ReplaceValue(#"Replaced Value10","º","",Replacer.ReplaceText,{"name"}),
    #"Replaced Value30" = Table.ReplaceValue(#"Replaced Value20","§","",Replacer.ReplaceText,{"name"}),
    #"Expanded CompSummary" = Table.ExpandTableColumn(#"Replaced Value30", "CompSummary", {"ma_amount_by_voucher", "ma_amount_in_cash", "ts_daily_rate", "ma_amount_applied", "ma_minimum_cash_value", "ma_amount_below_threshold", "ll_eligibility"}, {"ma_amount_by_voucher", "ma_amount_in_cash", "ts_daily_rate", "ma_amount_applied", "ma_minimum_cash_value", "ma_amount_below_threshold", "ll_eligibility"}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Expanded CompSummary", "activity", "impact"),
    #"Replaced Value" = Table.ReplaceValue(#"Duplicated Column","Owner","1.Vessel_Ownership",Replacer.ReplaceValue,{"activity"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Fishes_without_boat","3.Activity",Replacer.ReplaceText,{"activity"}),
    #"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","Specialized_Crew","3.Activity",Replacer.ReplaceText,{"activity"}),
    #"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","Crew","3.Activity",Replacer.ReplaceText,{"activity"}),
    #"Replaced Value4" = Table.ReplaceValue(#"Replaced Value3","Collector","3.Activity",Replacer.ReplaceText,{"activity"}),
    #"Replaced Value5" = Table.ReplaceValue(#"Replaced Value4","Gear_Owner","2.Gear_Owner",Replacer.ReplaceText,{"activity"}),
    #"Duplicated Column1" = Table.DuplicateColumn(#"Replaced Value5", "activity", "activity - Copy"),
    #"Replaced Value6" = Table.ReplaceValue(#"Duplicated Column1","1.Vessel_Ownership","Propriedade de Embarcacoes / Umiliki wa Vyombo",Replacer.ReplaceText,{"activity - Copy"}),
    #"Replaced Value7" = Table.ReplaceValue(#"Replaced Value6","2.Gear_Owner","Propriedade de Artes / Umiliki ya Sanaa",Replacer.ReplaceText,{"activity - Copy"}),
    #"Replaced Value8" = Table.ReplaceValue(#"Replaced Value7","3.Activity","Actividade / Shughuli",Replacer.ReplaceText,{"activity - Copy"}),
    #"Renamed Columns" = Table.RenameColumns(#"Replaced Value8",{{"activity - Copy", "Income"}}),
    #"Sorted Rows" = Table.Sort(#"Renamed Columns",{{"base", Order.Ascending}, {"document_number", Order.Ascending}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Sorted Rows",{{"multiplier", type number}, {"ma_amount", type number}, {"ts_amount", type number}, {"ma_amount_applied", type number}, {"ma_amount_below_threshold", type number}, {"ma_amount_by_voucher", type number}, {"ma_amount_in_cash", type number}, {"ts_daily_rate", type number}, {"ma_minimum_cash_value", type number}}),
    #"Cleaned Text" = Table.TransformColumns(#"Changed Type",{{"ccn", each Text.PadStart(_,5,"0"), type text}}),
    #"Replaced Value12" = Table.ReplaceValue(#"Cleaned Text","No_Vessel","Recolha",Replacer.ReplaceValue,{"vessel_class"}),
    #"Replaced Value13" = Table.ReplaceValue(#"Replaced Value12","Fisher_No_Vessel","Pesca Ambulante",Replacer.ReplaceText,{"vessel_class"}),
    #"Replaced Value14" = Table.ReplaceValue(#"Replaced Value13","Canoe","Canoa (vela / remo)",Replacer.ReplaceText,{"vessel_class"}),
    #"Replaced Value15" = Table.ReplaceValue(#"Replaced Value14","Planked","Lancha (vela / remo)",Replacer.ReplaceText,{"vessel_class"}),
    #"Replaced Value16" = Table.ReplaceValue(#"Replaced Value15","Motorized_Day_Seine","Lancha (rede de cerco com embarcacao motorizada)",Replacer.ReplaceText,{"vessel_class"}),
    #"Replaced Value17" = Table.ReplaceValue(#"Replaced Value16","Motorized_Night","Lancha (rede de cerco noturna com embarcacao motorizada)",Replacer.ReplaceText,{"vessel_class"}),
    #"Replaced Value18" = Table.ReplaceValue(#"Replaced Value17","Motorized","Lancha (motorizada)",Replacer.ReplaceText,{"vessel_class"}),
    #"Replaced Value19" = Table.ReplaceValue(#"Replaced Value18","Collector","Colector",Replacer.ReplaceText,{"impact"}),
    #"Replaced Value21" = Table.ReplaceValue(#"Replaced Value19","Fishes_without_boat","Pescadores sem barco",Replacer.ReplaceText,{"impact"}),
    #"Replaced Value22" = Table.ReplaceValue(#"Replaced Value21","Specialized_Crew","Tripulant especializado",Replacer.ReplaceText,{"impact"}),
    #"Replaced Value23" = Table.ReplaceValue(#"Replaced Value22","Crew","Tripulante",Replacer.ReplaceText,{"impact"}),
    #"Merged Columns" = Table.CombineColumns(#"Replaced Value23",{"impact", "vessel_class"},Combiner.CombineTextByDelimiter(" - ", QuoteStyle.None),"Detail"),
    #"Removed Other Columns1" = Table.SelectColumns(#"Merged Columns",{"agreement_status", "document_number", "phase", "base", "residence_village", "activity", "Detail", "name", "ccn", "registration_number", "id_number", "percent_impact", "multiplier", "ma_amount", "ts_amount", "ma_amount_by_voucher", "ma_amount_in_cash", "ts_daily_rate", "ma_amount_applied", "ma_minimum_cash_value", "ma_amount_below_threshold", "ll_eligibility", "Income"}),
    #"Replaced Value9" = Table.ReplaceValue(#"Removed Other Columns1","Yes","Sim / Ndio",Replacer.ReplaceText,{"ll_eligibility"}),
    #"Replaced Value24" = Table.ReplaceValue(#"Replaced Value9","Owner - ","",Replacer.ReplaceText,{"Detail"}),
    #"Replaced Value25" = Table.ReplaceValue(#"Replaced Value24","Gear_","",Replacer.ReplaceText,{"Detail"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Replaced Value25",{"agreement_status", "document_number", "name", "id_number", "ccn", "phase", "base", "residence_village", "activity", "Income", "Detail", "percent_impact", "multiplier", "ma_amount", "ma_minimum_cash_value", "ma_amount_below_threshold", "ma_amount_applied", "ma_amount_in_cash", "ma_amount_by_voucher", "ll_eligibility", "ts_daily_rate"}),
    #"Replaced Value11" = Table.ReplaceValue(#"Reordered Columns","0None","None",Replacer.ReplaceText,{"ccn"})
in
    #"Replaced Value11"

// MergeDataFiltered
let
    Source = MergeData,
    #"Merged Queries" = Table.NestedJoin(Source, {"registration_number"}, filter, {"Filter_RN"}, "filter", JoinKind.RightOuter),
    #"Reordered Columns" = Table.ReorderColumns(#"Merged Queries",{"agreement_status", "document_number", "name", "id_number", "ccn", "phase", "base", "residence_village", "activity", "Income", "Detail", "percent_impact", "multiplier", "ma_amount", "ts_daily_rate", "ll_eligibility", "ma_minimum_cash_value", "ma_amount_below_threshold", "ma_amount_applied", "ma_amount_in_cash", "ma_amount_by_voucher"}),
    #"Removed Columns" = Table.RemoveColumns(#"Reordered Columns",{"filter"}),
    #"Sorted Rows" = Table.Sort(#"Removed Columns",{{"document_number", Order.Ascending}, {"activity", Order.Ascending}}),
    #"Filtered Rows" = Table.SelectRows(#"Sorted Rows", each ([document_number] <> null)),
    #"Reordered Columns1" = Table.ReorderColumns(#"Filtered Rows",{"agreement_status", "document_number", "name", "id_number", "ccn", "phase", "base", "residence_village", "activity", "registration_number", "Income", "Detail", "percent_impact", "multiplier", "ma_amount", "ts_amount", "ts_daily_rate", "ll_eligibility", "ma_minimum_cash_value", "ma_amount_below_threshold", "ma_amount_applied", "ma_amount_in_cash", "ma_amount_by_voucher"})
in
    #"Reordered Columns1"

// filter
let
    Source = Excel.CurrentWorkbook(){[Name="Table1"]}[Content],
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Filter_RN", type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Changed Type",{{"Filter_RN", each Text.PadStart(_,4,"0"), type text}}),
    #"Sorted Rows" = Table.Sort(#"Cleaned Text",{{"Filter_RN", Order.Ascending}})
in
    #"Sorted Rows"

// Registration
let
    Source = FRN,
    #"C:\Users\L1020839\Documents\1Current\FRN\Fcsv\_res_fish_fisher_registration csv" = Source{[#"Folder Path"="C:\Users\L1020839\Documents\1Current\FRN\Fcsv\",Name="res_fish_fisher_registration.csv"]}[Content],
    #"Imported CSV" = Csv.Document(#"C:\Users\L1020839\Documents\1Current\FRN\Fcsv\_res_fish_fisher_registration csv",[Delimiter=",", Columns=16, Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Imported CSV", [PromoteAllScalars=true]),
    #"Replaced Value" = Table.ReplaceValue(#"Promoted Headers",".0","",Replacer.ReplaceText,{"registration_number"}),
    #"Cleaned Text" = Table.TransformColumns(#"Replaced Value",{{"registration_number", each Text.PadStart(_,4,"0"), type text}}),
    #"Cleaned Text1" = Table.TransformColumns(#"Cleaned Text",{{"objectid", each Text.PadStart(_,4,"0"), type text}})
in
    #"Cleaned Text1"

// RegistrationDup
let
    Source = Registration,
    #"Kept Duplicates" = let columnNames = {"base", "activity", "vessel_class", "name", "registration_number"}, addCount = Table.Group(Source, columnNames, {{"Count", Table.RowCount, type number}}), selectDuplicates = Table.SelectRows(addCount, each [Count] > 1), removeCount = Table.RemoveColumns(selectDuplicates, "Count") in Table.Join(Source, columnNames, removeCount, columnNames, JoinKind.Inner),
    #"Sorted Rows" = Table.Sort(#"Kept Duplicates",{{"registration_number", Order.Ascending}, {"activity", Order.Ascending}})
in
    #"Sorted Rows"

// RegistrationDate
let
    Source = Registration,
    #"Filtered Rows" = Table.SelectRows(Source, each ([created_date] = "None"))
in
    #"Filtered Rows"


    // HH_SP
let
    Source = Excel.CurrentWorkbook(){[Name="Table1"]}[Content],
    #"Removed Columns" = Table.RemoveColumns(Source,{"Full Name", "Comments"}),
    #"Added Custom" = Table.AddColumn(#"Removed Columns", "DP", each "Económica / Kiuchumi"),
    #"Changed Type2" = Table.TransformColumnTypes(#"Added Custom",{{"BSP", type text}, {"CCN", type text}, {"Name as per ID", type text}, {"ID_Type", type text}, {"ID_Number", type text}, {"Contact_Number", type text}, {"Locality", type text}, {"Settlement", type text}, {"Production Zone", type text}, {"DP", type text}}),
    #"Added Custom1" = Table.AddColumn(#"Changed Type2", "Phase_Priority", each "P6_0_0"),
    #"Merged Queries" = Table.NestedJoin(#"Added Custom1", {"CCN"}, CashSP, {"CCN"}, "CashSP", JoinKind.LeftOuter),
    #"Expanded CashSP" = Table.ExpandTableColumn(#"Merged Queries", "CashSP", {"Area", "Prep", "Fixed", "UOP", "YL", "LBO", "Total"}, {"Area", "Prep", "Fixed", "UOP", "YL", "LBO", "Total"}),
    #"Grouped Rows" = Table.Group(#"Expanded CashSP", {"BSP"}, {{"Count", each _, type table [BSP=nullable text, CCN=nullable text, Name as per ID=nullable text, ID_Type=nullable text, ID_Number=nullable text, Contact_Number=nullable text, Locality=nullable text, Settlement=nullable text, Production Zone=nullable text, DP=nullable text, Phase_Priority=text, Area=nullable number, Prep=nullable number, Fixed=nullable number, UOP=nullable number, LBO=nullable number, Total=nullable number]}}),
    #"Added Custom2" = Table.AddColumn(#"Grouped Rows", "Custom", each Table.AddIndexColumn([Count],"Index",1)),
    #"Removed Other Columns1" = Table.SelectColumns(#"Added Custom2",{"Custom"}),
    #"Expanded Custom" = Table.ExpandTableColumn(#"Removed Other Columns1", "Custom", {"BSP", "CCN", "Name as per ID", "ID_Type", "ID_Number", "Contact_Number", "Locality", "Settlement", "Production Zone", "DP", "Phase_Priority", "Area", "Prep", "Fixed", "UOP", "YL", "LBO", "Total", "Index"}, {"BSP", "CCN", "Name as per ID", "ID_Type", "ID_Number", "Contact_Number", "Locality", "Settlement", "Production Zone", "DP", "Phase_Priority", "Area", "Prep", "Fixed", "UOP", "YL", "LBO", "Total", "Index"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Expanded Custom",{{"Index", type text}}),
    #"Cleaned Text1" = Table.TransformColumns(#"Changed Type1",{{"Index", each Text.PadStart(_,2,"0"), type text}}),
    #"Duplicated Column" = Table.DuplicateColumn(#"Cleaned Text1", "BSP", "BSP - Copy"),
    #"Merged Columns" = Table.CombineColumns(#"Duplicated Column",{"BSP - Copy", "Index"},Combiner.CombineTextByDelimiter("_", QuoteStyle.None),"SP_ID"),
    #"Reordered Columns" = Table.ReorderColumns(#"Merged Columns",{"BSP", "CCN", "Name as per ID", "ID_Type", "ID_Number", "Contact_Number", "Locality", "Settlement", "Production Zone", "DP", "Phase_Priority", "SP_ID", "Area", "Prep", "Fixed", "UOP", "LBO", "Total"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Reordered Columns",{{"Total", type number}, {"LBO", type number}, {"UOP", type number}, {"YL", type number}, {"Fixed", type number}, {"Prep", type number}, {"Area", type number}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Name as per ID", "FullName"}})
in
    #"Renamed Columns"

// CashSP
let
    Source = Excel.CurrentWorkbook(){[Name="Table2"]}[Content],
    #"Added Prefix" = Table.TransformColumns(Source, {{"Phase_Priority", each "S" & _, type text}}),
    #"Rounded Up" = Table.TransformColumns(#"Added Prefix",{{"Length", Number.RoundUp, Int64.Type}, {"Width", Number.RoundUp, Int64.Type}}),
    #"Removed Other Columns" = Table.SelectColumns(#"Rounded Up",{"CCN", "Quantity", "Length", "Width", "Year of Stop Production"}),
    #"Inserted Multiplication" = Table.AddColumn(#"Removed Other Columns", "Area", each List.Product({[Length], [Width]}), Int64.Type),
    #"Added Custom" = Table.AddColumn(#"Inserted Multiplication", "Custom", each 0),
    #"Merged Queries" = Table.NestedJoin(#"Added Custom", {"Custom"}, constants, {"Custom"}, "constants", JoinKind.LeftOuter),
    #"Expanded constants" = Table.ExpandTableColumn(#"Merged Queries", "constants", {"prep", "fixed", "uop", "lbo", "YN"}, {"prep", "fixed", "uop", "lbo", "YN"}),
    #"Removed Columns1" = Table.RemoveColumns(#"Expanded constants",{"Custom"}),
    #"Inserted Multiplication1" = Table.AddColumn(#"Removed Columns1", "Prep", each List.Product({[#"Area"], [prep]}), type number),
    #"Inserted Multiplication2" = Table.AddColumn(#"Inserted Multiplication1", "Fixed", each List.Product({[Quantity], [fixed]}), type number),
    #"Inserted Multiplication3" = Table.AddColumn(#"Inserted Multiplication2", "UOP", each List.Product({[Area], [uop]}), type number),
    #"Rounded Up1" = Table.TransformColumns(#"Inserted Multiplication3",{{"UOP", Number.RoundUp, Int64.Type}}),
    #"Inserted Multiplication4" = Table.AddColumn(#"Rounded Up1", "Lbo", each List.Product({[lbo], [UOP]}), type number),
    #"Rounded Up2" = Table.TransformColumns(#"Inserted Multiplication4",{{"Lbo", Number.RoundUp, Int64.Type}}),
    #"Inserted Subtraction" = Table.AddColumn(#"Rounded Up2", "YL", each [YN] - [Year of Stop Production], type number),
    #"Inserted Multiplication5" = Table.AddColumn(#"Inserted Subtraction", "LBO", each [YL] * [Lbo], type number),
    #"Removed Other Columns1" = Table.SelectColumns(#"Inserted Multiplication5",{"CCN", "Area", "Prep", "Fixed", "UOP", "YL", "LBO"}),
    #"Inserted Sum" = Table.AddColumn(#"Removed Other Columns1", "Total", each List.Sum({[Prep], [Fixed], [UOP], [LBO]}), type number),
    #"Changed Type" = Table.TransformColumnTypes(#"Inserted Sum",{{"CCN", type text}}),
    #"Cleaned Text" = Table.TransformColumns(#"Changed Type",{{"CCN", each Text.PadStart(_,5,"0"), type text}})
in
    #"Cleaned Text"

// constants
let
    Source = Excel.CurrentWorkbook(){[Name="Table3"]}[Content],
    #"Added Custom" = Table.AddColumn(Source, "Custom", each 0)
in
    #"Added Custom"