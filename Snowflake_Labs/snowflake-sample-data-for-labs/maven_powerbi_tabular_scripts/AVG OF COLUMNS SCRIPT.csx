// Creates a AVG measure for every currently selected column
foreach(var c in Selected.Columns)
{
    var newMeasure = c.Table.AddMeasure(
        "Avg of " + c.Name,                    // Name
        "AVG(" + c.DaxObjectFullName + ")",    // DAX expression
        "_Base Measures"
    );
    
    // Set the format string on the new measure:
    newMeasure.FormatString = "0.00";

    // Provide some documentation:
    newMeasure.Description = "This measure is the avg of column " + c.DaxObjectFullName;
    
}