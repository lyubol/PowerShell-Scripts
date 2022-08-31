# Function to return the "INSERT INTO" part of the insert statement
function Create-InsertStatement{
    [CmdletBinding()]
    param
    (
        [Parameter (Mandatory = $true, 
            Position = 1, 
            HelpMessage = 'The name of the table where the data will be inserted')] 
        [string]$TableName
    )

    Write-Output "INSERT INTO $($TableName) ("
    foreach($i in 0..$($CSVFile[0].psobject.properties.name.Length - 1))
    {
        if ($i -eq $CSVFile[0].psobject.properties.name.Length - 1) {
           "    $($CSVFile[0].psobject.properties.name[$i]))"
        }else {
            "    $($CSVFile[0].psobject.properties.name[$i]),"
        }
    }

}


# Function to return the "VALUES" part of the insert statement
function Create-ValuesStatement {
    [CmdletBinding()]
    param
    (
        [Parameter (Mandatory = $true, 
            Position = 1, 
            HelpMessage = 'The name of the variable, which points to the CSV file')] 
        $CSVFile
    )

    Write-Output "VALUES"
    $columnNames = @($CSVFile[0].psobject.Properties.Name)

    $valuesStatements = foreach($record in $CSVFile[0..$($CSVFile[0].psobject.properties.name.Length)]){
        $values = $columnNames.ForEach({
            # fetch value from `$record.$_`, escape single quotes
            "'{0}'" -f $record.$_.Replace("'","''")
        })

        # Generate insert command string
        "($($values -join ', '))" + ","
    }

    return $valuesStatements[0..$($valuesStatements.Length - 2)], $valuesStatements[-1].Substring(0,$valuesStatements[-1].Length - 1)
}


# Read CSV file
$CSVFile = Import-Csv "C:\Users\L_L\Desktop\Employees_v2.csv" -Delimiter ","

# Execute functions to get the full "INSERT" statement
Create-InsertStatement -TableName "Employees.General"
Create-ValuesStatement $CSVFile
