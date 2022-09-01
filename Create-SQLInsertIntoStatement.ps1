<#
.SYNOPSIS
    Returns INSERT INTO SQL statement
.DESCRIPTION
    Returns the INSERT INTO (<columns>) VALUES part of an SQL INSERT INTO statement.
.INPUTS
    Name of target SQL table and a variable, which points to a CSV file.
.OUTPUTS
    System.String
.EXAMPLE
    Example output: INSERT INTO Employees.General (Id, FirstName, LastName) VALUES
.NOTES
    Version 1
    Developed By: Lyubomir Lirkov
    Last Updated: 2022/08/31
#>
function Create-InsertStatement{
    [CmdletBinding()]
    param
    (
        [Parameter (Mandatory = $true, 
            Position = 1, 
            HelpMessage = 'The name of the table where the data will be inserted')] 
        [string]$TableName,

        [Parameter (Mandatory = $true, 
            Position = 2, 
            HelpMessage = 'The name of the variable, which points to the CSV file')] 
        $CSVFile
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


<#
.SYNOPSIS
    Returns INSERT INTO SQL statement
.DESCRIPTION
    Returns the VALUES part of an SQL INSERT INTO statement.
.INPUTS
    Variable, which points to a CSV file.
.OUTPUTS
    System.String
.EXAMPLE
    Example output: ('1', 'Martyn', 'Smith')
.NOTES
    Version 1
    Developed By: Lyubomir Lirkov
    Last Updated: 2022/08/31
#>
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

    $valuesStatements = foreach($record in $CSVFile){
        $values = $columnNames.ForEach({
            # fetch value from `$record.$_`, escape single quotes
            "'{0}'" -f $record.$_.Replace("'","''")
        })

        # Generate string
        "($($values -join ', '))" + ","
    }

    return $valuesStatements[0..$($valuesStatements.Length - 2)], $valuesStatements[-1].Substring(0,$valuesStatements[-1].Length - 1)
}



# Read CSV file
$CSVFile = Import-Csv "C:\Users\L_L\Desktop\Employees.csv" -Delimiter ","

# Execute functions to get the full "INSERT" statement
Create-InsertStatement -TableName "Employees.General" -CSVFile $CSVFile
Create-ValuesStatement $CSVFile

<# Output:
INSERT INTO Employees.General (
    Id,
    FirstName,
    LastName)
VALUES
('1', 'Shayla', 'Dawson'),
('2', 'John', 'Smith'),
('3', 'Martin', 'James'),
('4', 'Rowan', 'Webb'),
('5', 'Halen', 'Glass')
#>