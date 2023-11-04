// Creates a SUM measure for every currently selected column and hide the column.
foreach(var t in Selected.Tables)
{
    var newMeasure = t.AddMeasure(
        "Count Rows of " + t.Name,                    // Name
        "COUNTROWS(" + t.DaxObjectFullName + ")",    // DAX expression
        "_Base Measures"
    );
    
    // Set the format string on the new measure:
    newMeasure.FormatString = "0";

    // Provide some documentation:
    newMeasure.Description = "This measure is the COUNTROWS of Table " + t.DaxObjectFullName;
    
}