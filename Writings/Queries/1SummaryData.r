<aside>
💡

// SummaryTestData
let
Source = Folder.Files("C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData"),
#"Sorted Rows1" = Table.Sort(Source,{{"Name", Order.Ascending}})
in
#"Sorted Rows1"

// SummaryTestData (2)
let
Source = SummaryTestData
in
Source

// Graves
let
Source = TreesGravesBusinesses,
#"Filtered Rows" = Table.SelectRows(Source, each ([Classe Do Bem] = "Sepulturas"))
in
#"Filtered Rows"

// Saplings
let
Source = TreesGravesBusinesses,
#"Filtered Rows" = Table.SelectRows(Source, each ([Classe Do Bem] = "Árvores"))
in
#"Filtered Rows"

// TreesGravesBusinesses
let
Source = Excel.CurrentWorkbook(){[Name="Asset_Import"]}[Content],
#"Filtered Rows" = Table.SelectRows(Source, each ([Asset_Class] = "Business" or [Asset_Class] = "Grave" or [Asset_Class] = "Tree")),
#"Grouped Rows" = Table.Group(#"Filtered Rows", {"Ag", "CCN", "Phase_Priority",  "Asset_Class", "Classe Do Bem", "Tipo Do Bem"}, {{"Quantidade", each List.Sum([Quantity]), type number}}),
#"Added Custom" = Table.AddColumn(#"Grouped Rows", "Saplings", each if[Asset_Class]="Tree" then [Quantidade] * 2 else 0),
#"Sorted Rows" = Table.Sort(#"Added Custom",{{"Ag", Order.Ascending}}),
#"Filtered Rows1" = Table.SelectRows(#"Sorted Rows", each ([Phase_Priority] <> "P5_0_0"))
in
#"Filtered Rows1"

// Kind
let
Source = Excel.CurrentWorkbook(){[Name="EntCat"]}[Content],
#"Filtered Rows" = Table.SelectRows(Source, each ([Category] <> "Cash"))
in
#"Filtered Rows"

// InKind
let
Source = Excel.CurrentWorkbook(){[Name="HH_Ent"]}[Content],
#"Removed Other Columns" = Table.SelectColumns(Source,{"Ag", "CCN", "Phase_Priority", "DT"}),
#"Merged Queries0" = Table.NestedJoin(#"Removed Other Columns", {"Ag"}, Kind, {"Ag"}, "KindAll", JoinKind.FullOuter),
#"Expanded KindAll" = Table.ExpandTableColumn(#"Merged Queries0", "KindAll", {"CT"}, {"CT"}),
#"Grouped Rows" = Table.Group(#"Expanded KindAll", {"Ag", "CCN", "Phase_Priority", "DT", "CT"}, {{"Count", each Table.RowCount(_), type number}}),
#"Sorted Rows1" = Table.Sort(#"Grouped Rows",{{"CT", Order.Ascending}}),
#"Removed Columns" = Table.RemoveColumns(#"Sorted Rows1",{"Count"}),
#"Added Conditional Column" = Table.AddColumn(#"Removed Columns", "Count", each if Text.StartsWith([Phase_Priority], "P5") then "Não" else "Sim"),
#"Replaced Value2" = Table.ReplaceValue(#"Added Conditional Column",null,"",Replacer.ReplaceValue,{"CT"}),
#"Pivoted Column" = Table.Pivot(#"Replaced Value2", List.Distinct(#"Replaced Value2"[CT]), "CT", "Count"),
#"Filtered Rows" = Table.SelectRows(#"Pivoted Column", each ([Ag] <> null)),
#"Changed Type" = Table.TransformColumnTypes(#"Filtered Rows",{{"Ag", type text}, {"CCN", type text}, {"Phase_Priority", type text}, {"DT", type text}, {"Agriculture restoration", type text}, {"Alternative livelihoods", type text}, {"Fisheries material assistance", type text}, {"Fisheries restoration", type text}, {"In kind business", type text}, {"In kind communities", type text}, {"In kind grave", type text}, {"In kind replacement land", type text}, {"In kind residential", type text}, {"In kind tree saplings", type text}, {"In kind vulnerable", type text}, {"Preferred employment", type text}, {"Skills Development", type text}, {"Transitional allowance (food coupon)", type text}}),
#"Sorted Rows" = Table.Sort(#"Changed Type",{{"Ag", Order.Ascending}}),
#"Replaced Value" = Table.ReplaceValue(#"Sorted Rows",null,"Não",Replacer.ReplaceValue,{"Agriculture restoration", "Alternative livelihoods", "Fisheries material assistance", "Fisheries restoration", "In kind business", "In kind communities", "In kind grave", "In kind replacement land", "In kind residential", "In kind tree saplings", "In kind vulnerable", "Preferred employment", "Skills Development", "Transitional allowance (food coupon)"}),
#"Merged Queries" = Table.NestedJoin(#"Replaced Value",{"Ag"},Saplings,{"Ag"},"Saplings",JoinKind.LeftOuter),
#"Expanded Saplings" = Table.ExpandTableColumn(#"Merged Queries", "Saplings", {"Classe Do Bem", "Tipo Do Bem", "Quantidade", "Saplings"}, {"Classe Do Bem", "Árvore", "Total Perdido", "Total Substituído"}),
#"Merged Queries1" = Table.NestedJoin(#"Expanded Saplings",{"Ag"},Graves,{"Ag"},"Graves",JoinKind.LeftOuter),
#"Expanded Graves" = Table.ExpandTableColumn(#"Merged Queries1", "Graves", {"Quantidade"}, {"Campas"}),
#"Removed Duplicates" = Table.Distinct(#"Expanded Graves"),
#"Replaced Value1" = Table.ReplaceValue(#"Removed Duplicates",null,"",Replacer.ReplaceValue,{"Árvore", "Total Perdido", "Total Substituído", "Campas"}),
#"Reordered Columns" = Table.ReorderColumns(#"Replaced Value1",{"Ag", "CCN", "Phase_Priority", "DT", "Agriculture restoration", "Alternative livelihoods", "Fisheries material assistance", "Fisheries restoration", "In kind business", "In kind communities", "In kind grave", "In kind replacement land", "In kind residential", "In kind tree saplings", "In kind vulnerable", "Preferred employment", "Skills Development", "Transitional allowance (food coupon)", "Árvore", "Total Perdido", "Total Substituído", "Campas"}),
#"Sorted Rows2" = Table.Sort(#"Reordered Columns",{{"Ag", Order.Ascending}})
in
#"Sorted Rows2"

// EntCat
let
Source = Table.Combine({Recurring, Once}),
#"Removed Duplicates" = Table.Distinct(Source),
#"Sorted Rows" = Table.Sort(#"Removed Duplicates",{{"Ag", Order.Ascending}})
in
#"Sorted Rows"

// HH_Ent
let
Source = Excel.CurrentWorkbook(){[Name="HH_Import"]}[Content],
#"Merged Queries" = Table.NestedJoin(Source, {"CCN"}, DT, {"CCN"}, "AI", JoinKind.LeftOuter),
#"Expanded AI" = Table.ExpandTableColumn(#"Merged Queries", "AI", {"Ag", "Phase_Priority", "DT", "Survey date"}, {"Ag", "Phase_Priority", "DT", "Survey date"}),
#"Sorted Rows" = Table.Sort(#"Expanded AI",{{"Ag", Order.Ascending}}),
#"Filtered Rows" = Table.SelectRows(#"Sorted Rows", each ([Ag] <> null)),
#"Merged Queries1" = Table.NestedJoin(#"Filtered Rows", {"Ag"}, AF, {"Ag"}, "AF", JoinKind.LeftOuter),
#"Expanded AF" = Table.ExpandTableColumn(#"Merged Queries1", "AF", {"isometrix_status"}, {"status"}),
#"Removed Duplicates" = Table.Distinct(#"Expanded AF"),
#"Grouped Rows" = Table.Group(#"Removed Duplicates", {"CCN", "Head_Family_Fullname", "Locality", "Settlement", "Production_Zone", "Head_Family_Surname", "Head_Family_ID_Number", "Head_Family_ID_Type", "Head_Family_Contact_Number", "Gender_of_Family_Head", "Created_Date", "Ag", "Phase_Priority", "DT", "Survey date"}, {{"status", each Text.Combine(List.Sort([status],Order.Ascending),";"), type text}})
in
#"Grouped Rows"

// Rec
let
Source = Recurring,
#"Replaced Value3" = Table.ReplaceValue(Source,"Ldr","LDR",Replacer.ReplaceText,{"CT"}),
#"Grouped Rows1" = Table.Group(#"Replaced Value3",  {"Ag", "CCN", "Phase_Priority", "Category", "Freq"}, {{"CT", each Text.Combine(List.Sort([CT], Order.Ascending),"; "), type text}}),
#"Replaced Value1" = Table.ReplaceValue(#"Grouped Rows1","In kind grave","Grave Reinterment",Replacer.ReplaceText,{"CT"}),
#"Replaced Value" = Table.ReplaceValue(#"Replaced Value1","In kind tree saplings","Replacement Saplings",Replacer.ReplaceText,{"CT"}),
#"Pivoted Column1" = Table.Pivot(#"Replaced Value", List.Distinct(#"Replaced Value"[Category]), "Category", "CT"),
#"Replaced Value4" = Table.ReplaceValue(#"Pivoted Column1","Cash -","",Replacer.ReplaceText,{"Cash"})
in
#"Replaced Value4"

// Recurring
let
Source = HH_EC,
#"Filtered Rows" = Table.SelectRows(Source, each ([Freq] = "Recurring")),
#"Grouped Rows" = Table.Group(#"Filtered Rows", {"Ag", "CCN", "Phase_Priority", "CT", "Category", "Freq"}, {{"Count", each Table.RowCount(_), Int64.Type}}),
#"Replaced Value2" = Table.ReplaceValue(#"Grouped Rows","Cash ","Cash - ",Replacer.ReplaceText,{"CT"})
in
#"Replaced Value2"

// HH_1ceOff
let
Source = Once,
#"Grouped Rows1" = Table.Group(Source, {"Ag", "CCN", "Phase_Priority", "Category","Freq"}, {{"CT", each Text.Combine(List.Sort([CT], Order.Ascending),"; "), type text}}),
#"Pivoted Column" = Table.Pivot(#"Grouped Rows1", List.Distinct(#"Grouped Rows1"[Category]), "Category", "CT"),
#"Replaced Value" = Table.ReplaceValue(#"Pivoted Column","In kind ","",Replacer.ReplaceText,{"In kind"}),
#"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Residential","Residential Package",Replacer.ReplaceText,{"In kind"}),
#"Capitalized Each Word" = Table.TransformColumns(#"Replaced Value1",{{"In kind", Text.Proper, type text}})
in
#"Capitalized Each Word"

// Once
let
Source = HH_EC,
#"Filtered Rows" = Table.SelectRows(Source, each ([Freq] = "Once")),
#"Grouped Rows" = Table.Group(#"Filtered Rows", {"CCN", "Category", "CT", "Freq"}, {{"Phase_Priority", each List.Min([Phase_Priority]), type text}, {"Ag", each List.Min([Ag]), type nullable text}})
in
#"Grouped Rows"

// CM
let
Source = SummaryTestData,
#"C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\*Commitments xlsx" = Source{[#"Folder Path"="C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\",Name="Commitments.xlsx"]}[Content],
#"Imported Excel Workbook" = Excel.Workbook(#"C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\Commitments xlsx"),
#"Replaced Value" = Table.ReplaceValue(#"Imported Excel Workbook","__2","",Replacer.ReplaceText,{"Item"}),
CM_Table = #"Replaced Value"{[Item="CM",Kind="Table"]}[Data],
#"Renamed Columns" = Table.RenameColumns(CM_Table,{{"Other", "Livelihood"}}),
#"Unpivoted Columns" = Table.UnpivotOtherColumns(#"Renamed Columns", {"Sub - Commitment", "Commitment", "CT", "Freq", "LandAccess", "EC", "EntCat", "Type", "Type of document needed for sign-off"}, "Category", "ComType"),
#"Grouped Rows" = Table.Group(#"Unpivoted Columns", {"Sub - Commitment", "CT", "Freq", "LandAccess", "EC", "Type", "Category"}, {{"Count", each Table.RowCount(), type number}}),
#"Filtered Rows" = Table.SelectRows(#"Grouped Rows", each true),
#"Grouped Rows1" = Table.Group(#"Filtered Rows", {"CT", "Freq", "EC", "Category"}, {{"Count", each Table.RowCount(*), type number}}),
#"Reordered Columns" = Table.ReorderColumns(#"Grouped Rows1",{"EC", "Category", "CT", "Freq", "Count"})
in
#"Reordered Columns"

// HH_EC
let
Source = EC,
#"Sorted Rows" = Table.Sort(Source,{{"Phase_Priority", Order.Ascending}}),
#"Merged Queries" = Table.NestedJoin(#"Sorted Rows", {"EC"}, CM, {"EC"}, "CM", JoinKind.FullOuter),
#"Expanded CM" = Table.ExpandTableColumn(#"Merged Queries", "CM", {"Category", "CT", "Freq"}, {"Category", "CT", "Freq"})
in
#"Expanded CM"

// EC
let
Source = AssetSources,
#"Grouped Rows" = Table.Group(Source, {"Ag", "CCN", "Phase_Priority", "Asset_Class", "Claimant_Asset_Rights", "House_Size"}, {{"Count", each Table.RowCount(*), Int64.Type}}),
#"Replaced Value6" = Table.ReplaceValue(#"Grouped Rows","","Owner",Replacer.ReplaceValue,{"Claimant_Asset_Rights"}),
#"Filtered Rows" = Table.SelectRows(#"Replaced Value6", each ([Asset_Class] <> "TA")),
#"Merged Columns" = Table.CombineColumns(#"Filtered Rows",{"Asset_Class","Claimant_Asset_Rights"},Combiner.CombineTextByDelimiter("*", QuoteStyle.None),"Impact"),
#"Replaced Value" = Table.ReplaceValue(#"Merged Columns","_NA","",Replacer.ReplaceText,{"Impact"}),
#"Duplicated Column" = Table.DuplicateColumn(#"Replaced Value", "Impact", "EC"),
#"Replaced Value3" = Table.ReplaceValue(#"Duplicated Column","Land_Owner","1A",Replacer.ReplaceText,{"EC"}),
#"Replaced Value10" = Table.ReplaceValue(#"Replaced Value3","Residence_Owner","2A",Replacer.ReplaceText,{"EC"}),
#"Replaced Value13" = Table.ReplaceValue(#"Replaced Value10","Residence_NonOwner","2A@",Replacer.ReplaceText,{"EC"}),
#"Replaced Value7" = Table.ReplaceValue(#"Replaced Value13","Crops_Owner","3A",Replacer.ReplaceText,{"EC"}),
#"Replaced Value8" = Table.ReplaceValue(#"Replaced Value7","Crops_Non-Owner","1B;3B",Replacer.ReplaceText,{"EC"}),
#"Replaced Value1" = Table.ReplaceValue(#"Replaced Value8","Land_Non-Owner","3B",Replacer.ReplaceText,{"EC"}),
#"Replaced Value4" = Table.ReplaceValue(#"Replaced Value1","Business_Owner","6A",Replacer.ReplaceText,{"EC"}),
#"Replaced Value12" = Table.ReplaceValue(#"Replaced Value4","Tree_Owner","3C",Replacer.ReplaceText,{"EC"}),
#"Replaced Value11" = Table.ReplaceValue(#"Replaced Value12","Structure_Owner","2D",Replacer.ReplaceText,{"EC"}),
#"Split Column by Delimiter" = Table.ExpandListColumn(Table.TransformColumns(#"Replaced Value11", {{"EC", Splitter.SplitTextByDelimiter(";", QuoteStyle.Csv), let itemType = (type nullable text) meta [Serialized.Text = true] in type {itemType}}}), "EC"),
#"Replaced Value2" = Table.ReplaceValue(#"Split Column by Delimiter","Grave_Owner","7A",Replacer.ReplaceText,{"EC"}),
#"Replaced Value15" = Table.ReplaceValue(#"Replaced Value2","Residence_Non-Owner","2C",Replacer.ReplaceValue,{"EC"}),
#"Replaced Value9" = Table.ReplaceValue(#"Replaced Value15",">= 70 sqm","*",Replacer.ReplaceText,{"House_Size"}),
#"Replaced Value5" = Table.ReplaceValue(#"Replaced Value9","< 70 sqm","",Replacer.ReplaceText,{"House_Size"}),
#"Merged Columns1" = Table.CombineColumns(#"Replaced Value5",{"House_Size","EC"},Combiner.CombineTextByDelimiter("", QuoteStyle.None),"EC"),
#"Replaced Value14" = Table.ReplaceValue(#"Merged Columns1","None","",Replacer.ReplaceText,{"EC"}),
#"Removed Columns" = Table.RemoveColumns(#"Replaced Value14",{"Impact","Count"}),
#"Removed Duplicates" = Table.Distinct(#"Removed Columns"),
#"Trimmed Text" = Table.TransformColumns(#"Removed Duplicates",{{"EC", Text.Trim, type text}, {"CCN", Text.Trim, type text}, {"Phase_Priority", Text.Trim, type text}}),
#"Sorted Rows2" = Table.Sort(#"Trimmed Text",{{"Ag", Order.Ascending}, {"EC", Order.Ascending}})
in
#"Sorted Rows2"

// Asset_Import
let
Source = AssetSources,
#"Appended Query1" = Table.Combine({Source, HHta, Mach}),
#"Removed Other Columns" = Table.SelectColumns(#"Appended Query1",{"Phase_Priority", "CCN", "Asset_Class", "Quantity", "Claimant_Asset_Rights", "Asset_ID", "Ag", "Asset_Type"}),
#"Changed Type" = Table.TransformColumnTypes(#"Removed Other Columns",{{"Phase_Priority", type text}, {"CCN", type text}, {"Asset_Class", type text}, {"Claimant_Asset_Rights", type text}, {"Asset_ID", type text}, {"Asset_Type", type text}, {"Ag", type text}}),
#"Trimmed Text" = Table.TransformColumns(#"Changed Type",{{"Phase_Priority", Text.Trim, type text}, {"CCN", Text.Trim, type text}, {"Asset_Class", Text.Trim, type text}, {"Claimant_Asset_Rights", Text.Trim, type text}, {"Asset_ID", Text.Trim, type text}, {"Asset_Type", Text.Trim, type text}, {"Ag", Text.Trim, type text}}),
#"Capitalized Each Word" = Table.TransformColumns(#"Trimmed Text",{{"Asset_Type", Text.Proper, type text}}),
#"Replaced Value" = Table.ReplaceValue(#"Capitalized Each Word",null,"Owner",Replacer.ReplaceValue,{"Claimant_Asset_Rights"}),
#"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Tree - ","",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value8" = Table.ReplaceValue(#"Replaced Value1","Citrine","Citrus",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value2" = Table.ReplaceValue(#"Replaced Value8","Structure - ","",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value3" = Table.ReplaceValue(#"Replaced Value2","Business - ","",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value7" = Table.ReplaceValue(#"Replaced Value3","Cassava","Other Tree",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value6" = Table.ReplaceValue(#"Replaced Value7","Aloe Vera Medicinal Use","Aloe Vera Medicinal",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value5" = Table.ReplaceValue(#"Replaced Value6","Land - Non Owner","Land Nonowner",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value4" = Table.ReplaceValue(#"Replaced Value5","Land - Owner","Land Owner",Replacer.ReplaceText,{"Asset_Type"}),
#"Filtered Rows1" = Table.SelectRows(#"Replaced Value4", each ([Asset_Class] <> "Crops")),
#"Sorted Rows" = Table.Sort(#"Filtered Rows1",{{"Ag", Order.Ascending}}),
#"Merged Queries" = Table.NestedJoin(#"Sorted Rows",{"Asset_Class", "Asset_Type"},CalcRates,{"AssetClass", "AssetType"},"CalcRates",JoinKind.LeftOuter),
#"Expanded CalcRates" = Table.ExpandTableColumn(#"Merged Queries", "CalcRates", {"Classe Do Bem", "Bem", "CalcAssetType", "Tipo Do Bem"}, {"Classe Do Bem", "Bem", "Calculate_Asset_Type", "Tipo Do Bem"}),
#"Appended Query" = Table.Combine({#"Expanded CalcRates", Crops}),
#"Merged Queries1" = Table.NestedJoin(#"Appended Query",{"Asset_Class", "Calculate_Asset_Type"},CalcRates,{"AssetClass", "CalcAssetType"},"Rates",JoinKind.LeftOuter),
#"Expanded Rates1" = Table.ExpandTableColumn(#"Merged Queries1", "Rates", {"Old_Rate", "Rate", "Unit"}, {"Old_Rate", "Rate", "Unit"}),
#"Removed Duplicates" = Table.Distinct(#"Expanded Rates1"),
#"Added Custom" = Table.AddColumn(#"Removed Duplicates", "Amount", each [Rate]*[Quantity]),
#"Added Custom1" = Table.AddColumn(#"Added Custom", "Amount_OR", each [Old_Rate]*[Quantity]),
#"Merged Queries2" = Table.NestedJoin(#"Added Custom1", {"Ag"}, DT, {"Ag"}, "DT", JoinKind.LeftOuter),
#"Expanded DT" = Table.ExpandTableColumn(#"Merged Queries2", "DT", {"DT", "Survey date"}, {"DT", "Survey date"}),
#"Sorted Rows2" = Table.Sort(#"Expanded DT",{{"Ag", Order.Ascending}, {"Asset_Class", Order.Ascending}}),
#"Changed Type1" = Table.TransformColumnTypes(#"Sorted Rows2",{{"Old_Rate", type number}, {"Amount_OR", type number}})
in
#"Changed Type1"

// AI
let
Source = Excel.CurrentWorkbook(){[Name="Asset_Import"]}[Content]
in
Source

// DT
let
Source = AF,
#"Grouped Rows1" = Table.Group(Source, {"Ag", "ccn", "phase_priority", "DT"}, {{"latest_survey_date", each List.Max([latest_survey_date]), type nullable date}}),
#"Grouped Rows2" = Table.Group(#"Grouped Rows1", {"Ag", "ccn", "phase_priority"}, {{"DT", each Text.Combine(List.Sort([DT],Order.Ascending),";"), type text},{"Survey date", each List.Max([latest_survey_date]), type nullable date}}),
#"Renamed Columns" = Table.RenameColumns(#"Grouped Rows2",{{"ccn", "CCN"}, {"phase_priority", "Phase_Priority"}}),
#"Replaced Value" = Table.ReplaceValue(#"Renamed Columns","Económica;Física","Física",Replacer.ReplaceText,{"DT"}),
#"Sorted Rows" = Table.Sort(#"Replaced Value",{{"Ag", Order.Ascending}})
in
#"Sorted Rows"

// Mach
let
Source = AF,
#"Filtered Rows" = Table.SelectRows(Source, each ([TAM] ="M")),
#"Grouped Rows" = Table.Group(#"Filtered Rows", {"ccn", "TAM"}, {{"Phase_Priority", each List.Min([phase_priority]), type text}}),
#"Added Custom2" = Table.AddColumn(#"Grouped Rows", "Ag", each [ccn]&"|"&[Phase_Priority]),
#"Renamed Columns" = Table.RenameColumns(#"Added Custom2",{{"TAM", "Asset_Class"}, {"ccn", "CCN"}}),
#"Replaced Value2" = Table.ReplaceValue(#"Renamed Columns","M","Land",Replacer.ReplaceText,{"Asset_Class"}),
#"Duplicated Column" = Table.DuplicateColumn(#"Replaced Value2", "Asset_Class", "Asset_Type"),
#"Replaced Value1" = Table.ReplaceValue(#"Duplicated Column","TA","Transport Allowance",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value3" = Table.ReplaceValue(#"Replaced Value1","Land","Machamba Cleaning",Replacer.ReplaceText,{"Asset_Type"}),
#"Duplicated Column1" = Table.DuplicateColumn(#"Replaced Value3", "Asset_Type", "Calculate_Asset_Type"),
#"Added Custom1" = Table.AddColumn(#"Duplicated Column1", "Asset_ID", each [Asset_Class]&[CCN]&[Phase_Priority]),
#"Replaced Value" = Table.ReplaceValue(#"Added Custom1","_","",Replacer.ReplaceText,{"Asset_ID"}),
#"Added Custom" = Table.AddColumn(#"Replaced Value", "Quantity", each 1, Int64.Type),
#"Sorted Rows1" = Table.Sort(#"Added Custom",{{"Ag", Order.Ascending}})
in
#"Sorted Rows1"

// HHta
let
Source = AF,
#"Grouped Rows" = Table.Group(Source, {"Ag", "ccn", "TAM", "phase_priority"}, {{"count", each Table.RowCount(*), Int64.Type}}),
#"Removed Columns" = Table.RemoveColumns(#"Grouped Rows",{"count"}),
#"Filtered Rows" = Table.SelectRows(#"Removed Columns", each ([TAM] ="TA")),
#"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"TAM", "Asset_Class"}, {"ccn", "CCN"}, {"phase_priority", "Phase_Priority"}}),
#"Duplicated Column" = Table.DuplicateColumn(#"Renamed Columns", "Asset_Class", "Asset_Type"),
#"Replaced Value1" = Table.ReplaceValue(#"Duplicated Column","TA","Transport Allowance",Replacer.ReplaceText,{"Asset_Type"}),
#"Duplicated Column1" = Table.DuplicateColumn(#"Replaced Value1", "Asset_Type", "Calculate_Asset_Type"),
#"Added Custom1" = Table.AddColumn(#"Duplicated Column1", "Asset_ID", each [Asset_Class]&[CCN]&[Phase_Priority]),
#"Replaced Value" = Table.ReplaceValue(#"Added Custom1","*","",Replacer.ReplaceText,{"Asset_ID"}),
#"Added Custom" = Table.AddColumn(#"Replaced Value", "Quantity", each 1, Int64.Type),
#"Sorted Rows1" = Table.Sort(#"Added Custom",{{"Ag", Order.Ascending}})
in
#"Sorted Rows1"

// Crops
let
Source = AssetSources,
#"Removed Other Columns" = Table.SelectColumns(Source,{"Asset_Class", "Asset_ID", "Asset_Type_Cassava", "Asset_Type_Amaranth", "Asset_Type_Bambara_Groundnut", "Asset_Type_Banana", "Asset_Type_Beans", "Asset_Type_Butter_Beans", "Asset_Type_Cabbage", "Asset_Type_Carrot", "Asset_Type_Chilli", "Asset_Type_Cowpea", "Asset_Type_Cucumber", "Asset_Type_Eggplant", "Asset_Type_Lemon_Balm", "Asset_Type_Lettuce", "Asset_Type_Maize", "Asset_Type_Millet", "Asset_Type_Okra", "Asset_Type_Onion", "Asset_Type_Other_Beans", "Asset_Type_Peanut", "Asset_Type_Pepper", "Asset_Type_Pineapple", "Asset_Type_Potato", "Asset_Type_Pumpkin", "Asset_Type_Rice", "Asset_Type_Sesame", "Asset_Type_Sorghum", "Asset_Type_Spinach", "Asset_Type_Squash", "Asset_Type_Sugarcane", "Asset_Type_Sweet_Potato", "Asset_Type_Tea", "Asset_Type_Tomato", "Asset_Type_Watermelon", "Asset_Type_Yam", "Asset_Type_Uncultivated", "Asset_Type_Other_Crop", "Asset_Type"}),
#"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each ([Asset_Class] = "Crops")),
#"Unpivoted Columns" = Table.UnpivotOtherColumns(#"Filtered Rows", {"Asset_Class", "Asset_ID"}, "CropType", "Value"),
#"Filtered Rows1" = Table.SelectRows(#"Unpivoted Columns", each ([Value] = "Yes")),
#"Replaced Value" = Table.ReplaceValue(#"Filtered Rows1","Asset_Type_","",Replacer.ReplaceText,{"CropType"}),
#"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","_"," ",Replacer.ReplaceText,{"CropType"}),
#"Removed Duplicates" = Table.Distinct(#"Replaced Value1"),
#"Capitalized Each Word" = Table.TransformColumns(#"Removed Duplicates",{{"CropType", Text.Proper, type text}}),
#"Merged Queries" = Table.NestedJoin(#"Capitalized Each Word",{"Asset_Class", "CropType"},CalcRates,{"AssetClass", "AssetType"},"Rates1",JoinKind.LeftOuter),
#"Filtered Rows2" = Table.SelectRows(#"Merged Queries", each ([CropType] <> "Other Crop")),
#"Expanded Rates1" = Table.ExpandTableColumn(#"Filtered Rows2", "Rates1", {"AssetClass", "Classe Do Bem", "AssetType", "Bem", "CalcAssetType", "Tipo Do Bem"}, {"AssetClass", "Classe Do Bem", "AssetType", "Bem", "CalcAssetType", "Tipo Do Bem"}),
#"Removed Duplicates1" = Table.Distinct(#"Expanded Rates1"),
#"Grouped Rows" = Table.Group(#"Removed Duplicates1", {"Asset_ID", "Asset_Class", "CalcAssetType", "Classe Do Bem", "Tipo Do Bem"}, {{"CropType", each Text.Combine(List.Sort([CropType],Order.Ascending),";"), type text}, {"Bem", each Text.Combine(List.Sort([Bem],Order.Ascending),";"), type text}}),
#"Grouped Rows1" = Table.Group(#"Grouped Rows", {"Asset_ID", "Asset_Class", "Classe Do Bem"}, {{"Calculate_Asset_Type", each Text.Combine(List.Sort([CalcAssetType],Order.Ascending),";"), type text}, {"Asset_Type", each Text.Combine(List.Sort([CropType],Order.Ascending),";"), type text}, {"Tipo Do Bem", each Text.Combine(List.Sort([Tipo Do Bem],Order.Ascending),";"), type text}, {"Bem", each Text.Combine(List.Sort([Bem],Order.Ascending),";"), type text}}),
#"Merged Queries1" = Table.NestedJoin(#"Grouped Rows1",{"Asset_ID"},AssetSources,{"Asset_ID"},"Assets",JoinKind.LeftOuter),
#"Expanded Assets" = Table.ExpandTableColumn(#"Merged Queries1", "Assets", {"Status", "Phase_Priority", "CCN", "Quantity", "Claimant_Asset_Rights", "Ag"}, {"Status", "Phase_Priority", "CCN", "Quantity", "Claimant_Asset_Rights", "Ag"})
in
#"Expanded Assets"

// HH_Import
let
Source = HH,
#"Cleaned Text" = Table.TransformColumns(Source,{{"CCN", each Text.PadStart(_,5,"0"), type text}}),
#"Sorted Rows2" = Table.Sort(#"Cleaned Text",{{"CCN", Order.Ascending}}),
#"Filtered Rows1" = Table.SelectRows(#"Sorted Rows2", each ([CCN] <> "00000")),
#"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows1",{"CCN", "Head_Family_Fullname", "Locality", "Settlement", "Production_Zone", "Head_Family_Surname", "Head_Family_ID_Number", "Head_Family_ID_Type", "Head_Family_Contact_Number", "Gender_of_Family_Head", "Created_Date"}),
#"Filtered Rows" = Table.SelectRows(#"Removed Other Columns", each ([Head_Family_Surname] <> "<Null>")),
#"Merged Queries" = Table.NestedJoin(#"Filtered Rows", {"CCN"}, Filter, {"CCN"}, "Filter", JoinKind.Inner),
#"Removed Duplicates" = Table.Distinct(#"Merged Queries", {"CCN"})
in
#"Removed Duplicates"

// Headings
let
Source = AF,
#"Filtered Rows" = Table.SelectRows(Source, each ([[Source.Name](http://source.name/)] <> "line.csv" and [[Source.Name](http://source.name/)] <> "point.csv" and [[Source.Name](http://source.name/)] <> "poly.csv")),
#"Demoted Headers" = Table.DemoteHeaders(#"Filtered Rows"),
#"Transposed Table" = Table.Transpose(#"Demoted Headers"),
#"Duplicated Column" = Table.DuplicateColumn(#"Transposed Table", "Column1", "Column1 - Copy"),
#"Capitalized Each Word1" = Table.TransformColumns(#"Duplicated Column",{{"Column1", Text.Proper, type text}}),
#"Replaced Value0" = Table.ReplaceValue(#"Capitalized Each Word1","Ccn","CCN",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value010" = Table.ReplaceValue(#"Replaced Value0","Id","ID",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value20" = Table.ReplaceValue(#"Replaced Value010","Of","of",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value" = Table.ReplaceValue(#"Replaced Value20","Isometrix_","",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value8" = Table.ReplaceValue(#"Replaced Value","Newrate","NewRate",Replacer.ReplaceText,{"Column1"}),
#"Reordered Columns" = Table.ReorderColumns(#"Replaced Value8",{"Column1 - Copy", "Column1"}),
#"Transposed Table1" = Table.Transpose(#"Reordered Columns"),
#"Promoted Headers" = Table.PromoteHeaders(#"Transposed Table1", [PromoteAllScalars=true])
in
#"Promoted Headers"

// AssetSources
let
Source = AF,
#"Filtered Rows" = Table.SelectRows(Source, each ([[Source.Name](http://source.name/)] <> "line.csv" and [[Source.Name](http://source.name/)] <> "point.csv" and [[Source.Name](http://source.name/)] <> "poly.csv")),
#"Demoted Headers" = Table.DemoteHeaders(#"Filtered Rows"),
#"Transposed Table" = Table.Transpose(#"Demoted Headers"),
#"Duplicated Column" = Table.DuplicateColumn(#"Transposed Table", "Column1", "Column1 - Copy"),
#"Capitalized Each Word1" = Table.TransformColumns(#"Duplicated Column",{{"Column1", Text.Proper, type text}}),
#"Replaced Value0" = Table.ReplaceValue(#"Capitalized Each Word1","Ccn","CCN",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value010" = Table.ReplaceValue(#"Replaced Value0","Id","ID",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value20" = Table.ReplaceValue(#"Replaced Value010","Of","of",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value" = Table.ReplaceValue(#"Replaced Value20","Isometrix_","",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value8" = Table.ReplaceValue(#"Replaced Value","Newrate","NewRate",Replacer.ReplaceText,{"Column1"}),
#"Reordered Columns" = Table.ReorderColumns(#"Replaced Value8",{"Column1 - Copy", "Column1"}),
#"Transposed Table1" = Table.Transpose(#"Reordered Columns"),
#"Promoted Headers" = Table.PromoteHeaders(#"Transposed Table1", [PromoteAllScalars=true]),
#"Appended Query" = Table.Combine({#"Promoted Headers", AF}),
#"Promoted Headers0" = Table.PromoteHeaders(#"Appended Query", [PromoteAllScalars=true]),
#"Filtered Rows0" = Table.SelectRows(#"Promoted Headers0", each ([CCN] <> null) and ([Survey_Status] = "Active")),
#"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows0",{"Survey_Status", "Latest_Survey_Date", "Phase_Priority", "CCN", "Asset_Class", "Asset_Type", "Calculate_Asset_Type", "Quantity", "Claimant_Asset_Rights", "Area_Affected", "House_Size", "Asset_ID", "Asset_Notes", "Asset_Type_Cassava", "Asset_Type_Amaranth", "Asset_Type_Bambara_Groundnut", "Asset_Type_Banana", "Asset_Type_Beans", "Asset_Type_Butter_Beans", "Asset_Type_Cabbage", "Asset_Type_Carrot", "Asset_Type_Chilli", "Asset_Type_Cowpea", "Asset_Type_Cucumber", "Asset_Type_Eggplant", "Asset_Type_Lemon_Balm", "Asset_Type_Lettuce", "Asset_Type_Maize", "Asset_Type_Millet", "Asset_Type_Okra", "Asset_Type_Onion", "Asset_Type_Other_Beans", "Asset_Type_Peanut", "Asset_Type_Pepper", "Asset_Type_Pineapple", "Asset_Type_Potato", "Asset_Type_Pumpkin", "Asset_Type_Rice", "Asset_Type_Sesame", "Asset_Type_Sorghum", "Asset_Type_Spinach", "Asset_Type_Squash", "Asset_Type_Sugarcane", "Asset_Type_Sweet_Potato", "Asset_Type_Tea", "Asset_Type_Tomato", "Asset_Type_Watermelon", "Asset_Type_Yam", "Asset_Type_Uncultivated", "Asset_Type_Other_Crop", "Ag"}),
#"Replaced Value00" = Table.ReplaceValue(#"Removed Other Columns","None","0",Replacer.ReplaceText,{"House_Size"}),
#"Replaced Value1" = Table.ReplaceValue(#"Replaced Value00",null,"0",Replacer.ReplaceValue,{"House_Size"}),
#"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","","0",Replacer.ReplaceValue,{"House_Size"}),
#"Filtered Rows1" = Table.SelectRows(#"Replaced Value2", each ([Quantity] <> "None")),
#"Changed Type1" = Table.TransformColumnTypes(#"Filtered Rows1",{{"Phase_Priority", type text}, {"CCN", type text}, {"Asset_Class", type text}, {"Asset_Type", type text}, {"Calculate_Asset_Type", type text}, {"Claimant_Asset_Rights", type text}, {"Asset_ID", type text}, {"Asset_Notes", type text}, {"Asset_Type_Cassava", type text}, {"Asset_Type_Amaranth", type text}, {"Asset_Type_Bambara_Groundnut", type text}, {"Asset_Type_Banana", type text}, {"Asset_Type_Beans", type text}, {"Asset_Type_Butter_Beans", type text}, {"Asset_Type_Cabbage", type text}, {"Asset_Type_Carrot", type text}, {"Asset_Type_Chilli", type text}, {"Asset_Type_Cowpea", type text}, {"Asset_Type_Cucumber", type text}, {"Asset_Type_Eggplant", type text}, {"Asset_Type_Lemon_Balm", type text}, {"Asset_Type_Lettuce", type text}, {"Asset_Type_Maize", type text}, {"Asset_Type_Millet", type text}, {"Asset_Type_Okra", type text}, {"Asset_Type_Onion", type text}, {"Asset_Type_Other_Beans", type text}, {"Asset_Type_Peanut", type text}, {"Asset_Type_Pepper", type text}, {"Asset_Type_Pineapple", type text}, {"Asset_Type_Potato", type text}, {"Asset_Type_Pumpkin", type text}, {"Asset_Type_Rice", type text}, {"Asset_Type_Sesame", type text}, {"Asset_Type_Sorghum", type text}, {"Asset_Type_Spinach", type text}, {"Asset_Type_Squash", type text}, {"Asset_Type_Sugarcane", type text}, {"Asset_Type_Sweet_Potato", type text}, {"Asset_Type_Tea", type text}, {"Asset_Type_Tomato", type text}, {"Asset_Type_Watermelon", type text}, {"Asset_Type_Yam", type text}, {"Asset_Type_Uncultivated", type text}, {"Quantity", type number}, {"House_Size", type number}}),
#"Rounded Up1" = Table.TransformColumns(#"Changed Type1",{{"House_Size", Number.RoundUp, Int64.Type}, {"Quantity", Number.RoundUp, Int64.Type}}),
#"Cleaned Text" = Table.TransformColumns(#"Rounded Up1",{{"CCN", each Text.PadStart(*,5,"0"), type text}}),
#"Capitalized Each Word" = Table.TransformColumns(#"Cleaned Text",{{"Asset_Notes", Text.Proper, type text}}),
#"Added Custom" = Table.AddColumn(#"Capitalized Each Word", "sizes", each if Text.Contains([Asset_Notes], "Seedling") then "Seedling" else if Text.Contains([Asset_Notes], "Sapling") then "Sapling" else if [House_Size] >= 70 then ">= 70 sqm" else if [House_Size] > 0 then "< 70 sqm" else "", type text),
#"Removed Columns1" = Table.RemoveColumns(#"Added Custom",{"House_Size"}),
#"Duplicated Column0" = Table.DuplicateColumn(#"Removed Columns1", "sizes", "House_Size"),
#"Replaced Value3" = Table.ReplaceValue(#"Duplicated Column0","Seedling","",Replacer.ReplaceText,{"House_Size"}),
#"Merged Columns" = Table.CombineColumns(#"Replaced Value3",{"Asset_Type", "sizes"},Combiner.CombineTextByDelimiter(":", QuoteStyle.None),"Asset_Type"),
#"Replaced Value10" = Table.ReplaceValue(#"Merged Columns","*"," ",Replacer.ReplaceText,{"Asset_Type"}),
#"Trimmed Text" = Table.TransformColumns(#"Replaced Value10" ,{{"Asset_Type", each Text.TrimEnd(*,":"), type text}}),
#"Replaced Value6" = Table.ReplaceValue(#"Trimmed Text","Structure - Fishing Agricultural Shelter open:Seedling","Structure - Fishing Agricultural Shelter open",Replacer.ReplaceText,{"Asset_Type"}),
#"Replaced Value9" = Table.ReplaceValue(#"Replaced Value6","*"," ",Replacer.ReplaceText,{"Asset_Type"}),
#"Trimmed Text0" = Table.TransformColumns(#"Replaced Value9",{{"Asset_Type", each Text.TrimEnd(_,":"), type text}}),
#"Replaced Value60" = Table.ReplaceValue(#"Trimmed Text0","Structure - Fishing Agricultural Shelter open:Seedling","Structure - Fishing Agricultural Shelter open",Replacer.ReplaceText,{"Asset_Type"})
in
#"Replaced Value60"

// AF
let
Source = Excel.CurrentWorkbook(){[Name="AllFields"]}[Content],
#"Added Custom2" = Table.AddColumn(Source, "Ag", each [ccn]&"|"&[phase_priority]),
#"Added Custom3" = Table.AddColumn(#"Added Custom2", "DT", each if [asset_class]="Residence" then "Física" else "Económica"),
#"Added Custom1" = Table.AddColumn(#"Added Custom3", "TAM", each if[asset_class] = "Residence" or [asset_class]="Business" or [asset_class]="Structure" then "TA" else if Text.Contains([phase_priority],"P4") and ([asset_class] = "Land" or [asset_class]="Crops") then "M" else null),
#"Sorted Rows" = Table.Sort(#"Added Custom1",{{"Ag", Order.Ascending}}),
#"Replaced Value" = Table.ReplaceValue(#"Sorted Rows","None","Active",Replacer.ReplaceText,{"survey_status"}),
#"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Initial","Active",Replacer.ReplaceText,{"survey_status"}),
#"Filtered Rows" = Table.SelectRows(#"Replaced Value1", each ([phase_priority] <> "NA") and ([survey_status] = "Active") and ([quantity] <> "0.0")),
#"Changed Type" = Table.TransformColumnTypes(#"Filtered Rows",{{"latest_survey_date", type datetimezone}}),
#"Changed Type1" = Table.TransformColumnTypes(#"Changed Type",{{"latest_survey_date", type date}})
in
#"Changed Type1"

// Filter
let
Source = Excel.CurrentWorkbook(){[Name="filter"]}[Content],
#"Changed Type" = Table.TransformColumnTypes(Source,{{"CCN", type text}}),
#"Cleaned Text" = Table.TransformColumns(#"Changed Type",{{"CCN", each Text.PadStart(_,5,"0"), type text}})
in
#"Cleaned Text"

// AllFields
let
Source = DataSource,
#"Filtered Rows1" = Table.SelectRows(Source, each ([Name] <> "households.csv")),
#"Filtered Hidden Files1" = Table.SelectRows(#"Filtered Rows1", each [Attributes]?[Hidden]? <> true),
#"Sorted Rows" = Table.Sort(#"Filtered Hidden Files1",{{"Date created", Order.Descending}}),
#"Invoke Custom Function1" = Table.AddColumn(#"Sorted Rows", "Transform File from Assets", each #"Transform File from Assets"([Content])),
#"Renamed Columns1" = Table.RenameColumns(#"Invoke Custom Function1", {"Name", "[Source.Name](http://source.name/)"}),
#"Filtered Rows" = Table.SelectRows(#"Renamed Columns1", each ([[Source.Name](http://source.name/)] <> "households.csv")),
#"Renamed Columns" = Table.RenameColumns(#"Filtered Rows",{{"Date created", "Source.Date"}}),
#"Removed Other Columns1" = Table.SelectColumns(#"Renamed Columns",{"[Source.Name](http://source.name/)", "Source.Date", "Transform File from Assets"}),
#"Expanded Table Column1" = Table.ExpandTableColumn(#"Removed Other Columns1", "Transform File from Assets", Table.ColumnNames(#"Transform File from Assets"(#"Sample File"))),
#"Replaced Value3" = Table.ReplaceValue(#"Expanded Table Column1","None","",Replacer.ReplaceText,{"created_date"}),
#"Cleaned Text1" = Table.TransformColumns(#"Replaced Value3",{{"ccn", each Text.PadStart(*,5,"0"), type text}}),
#"Sorted Rows1" = Table.Sort(#"Cleaned Text1",{{"ccn", Order.Ascending}}),
#"Merged Queries" = Table.NestedJoin(#"Sorted Rows1", {"ccn"}, Filter, {"CCN"}, "Filter", JoinKind.Inner),
#"Filtered Rows2" = Table.SelectRows(#"Merged Queries", each ([quantity] <> null and [quantity] <> "0.0")),
#"Replaced Value" = Table.ReplaceValue(#"Filtered Rows2","*"," - ",Replacer.ReplaceText,{"asset_type"})
in
#"Replaced Value"

// HH
let
Source = SummaryTestData,
#"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "households.csv" or [Name] = "line.csv" or [Name] = "point.csv" or [Name] = "poly.csv")),
#"C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\csv_all\_households csv" = #"Filtered Rows"{[#"Folder Path"="C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\csv_all\",Name="households.csv"]}[Content],
#"Imported CSV" = Csv.Document(#"C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\csv_all\_households csv",[Delimiter=",", Columns=48, Encoding=65001, QuoteStyle=QuoteStyle.None]),
#"Transposed Table" = Table.Transpose(#"Imported CSV"),
#"Capitalized Each Word" = Table.TransformColumns(#"Transposed Table",{{"Column1", Text.Proper, type text}}),
#"Replaced Value" = Table.ReplaceValue(#"Capitalized Each Word","Ccn","CCN",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Id","ID",Replacer.ReplaceText,{"Column1"}),
#"Replaced Value2" = Table.ReplaceValue(#"Replaced Value1","Of","of",Replacer.ReplaceText,{"Column1"}),
#"Transposed Table1" = Table.Transpose(#"Replaced Value2"),
#"Promoted Headers" = Table.PromoteHeaders(#"Transposed Table1", [PromoteAllScalars=true])
in
#"Promoted Headers"

// CalcRates
let
Source = SummaryTestData,
#"C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\_Rates xlsx" = Source{[#"Folder Path"="C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\",Name="Rates.xlsx"]}[Content],
#"Imported Excel Workbook" = Excel.Workbook(#"C:\Users\L1020839\Documents\Agreements\Agreement\SummaryData\_Rates xlsx"),
Rates_Table = #"Imported Excel Workbook"{[Item="Rates",Kind="Table"]}[Data],
#"Changed Type" = Table.TransformColumnTypes(Rates_Table,{{"AssetClass", type text}, {"AssetType", type text}, {"CalcAssetType", type text}, {"New_Rate", Int64.Type}, {"Unit", type text}}),
#"Replaced Value" = Table.ReplaceValue(#"Changed Type","Crops - ","",Replacer.ReplaceText,{"AssetType"}),
#"Replaced Value1" = Table.ReplaceValue(#"Replaced Value","Bird House","Birdhouse",Replacer.ReplaceText,{"AssetType"}),
#"Capitalized Each Word" = Table.TransformColumns(#"Replaced Value1",{{"AssetType", Text.Proper, type text}}),
#"Renamed Columns" = Table.RenameColumns(#"Capitalized Each Word",{{"New_Rate", "Rate"}})
in
#"Renamed Columns"

// Transform Sample File from Assets
let
Source = Csv.Document(#"Sample File Parameter1",[Delimiter=",", Encoding=1252, QuoteStyle=QuoteStyle.None]),
#"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true])
in
#"Promoted Headers"

// Transform File from Assets
let
Source = (#"Sample File Parameter1" as binary) => let
Source = Csv.Document(#"Sample File Parameter1",[Delimiter=",", Encoding=1252, QuoteStyle=QuoteStyle.None]),
#"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true])
in
#"Promoted Headers"
in
Source

// Sample File Parameter1
#"Sample File" meta [IsParameterQuery=true, BinaryIdentifier=#"Sample File", Type="Binary", IsParameterQueryRequired=true]

// Sample File
let
Source = DataSource,
#"Filtered Rows" = Table.SelectRows(Source, each ([Name] <> "HOUSEHOLDS.csv")),
#"Sorted Rows" = Table.Sort(#"Filtered Rows",{{"Name", Order.Descending}}),
Navigation1 = #"Sorted Rows"{0}[Content]
in
Navigation1

// DataSource
let
Source = SummaryTestData,
#"Filtered Rows" = Table.SelectRows(Source, each ([Name] = "households.csv" or [Name] = "line.csv" or [Name] = "point.csv" or [Name] = "poly.csv"))
in
#"Filtered Rows"

</aside>