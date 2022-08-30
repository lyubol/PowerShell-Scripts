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
function Create-ValuesStatement{
    Write-Output "VALUES($($CSVFile[0].Id), '$($CSVFile[0].FirstName)', '$($CSVFile[0].LastName)', $($CSVFile[0].Salary)),"
    foreach($i in 1..$($CSVFile[0].psobject.properties.name.Length))
    {
        foreach($LINE in $CSVFile[$i])
        {
            if ($i -eq $CSVFile[0].psobject.properties.name.Length) {
                "    ($($LINE.Id), '$($LINE.FirstName)', '$($LINE.LastName)', $($LINE.Salary))"
            }else {
                "    ($($LINE.Id), '$($LINE.FirstName)', '$($LINE.LastName)', $($LINE.Salary)),"
            }  
        }
    }

}

# Read source CSV file
$CSVFile = Import-Csv "C:\Users\L_L\Desktop\Employees.csv"

# Execute functions to get the full "INSERT" statement
Create-InsertStatement -TableName "Employees.General"
Create-ValuesStatement



