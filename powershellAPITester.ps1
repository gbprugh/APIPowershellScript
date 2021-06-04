#Sample Powershell script to test each API Endpoint:
#GETs for All People in the Database, People by Name, and Person by ID
#POST for adding a new person to the database

#Defining Functions
function GetRequest([string] $Route)
{
	Write-Host "Testing GET Request.";
	$Result = New-Object PSObject;
	
	Try
	{
		$Result = Invoke-RestMethod -Uri $Route -Method Get;
		WriteToLog ("GET to $Route passed");
		Write-Host "GET test passed.";
	}
	Catch
	{
		LogErrorMessage "GET to $Route failed." $_.Exception.Message;
		Write-Host "GET test failed.";
	}
	
	return $Result;
}

function PostRequest([string]$Route, [string]$Body)
{
	$ExampleBody = $Body | ConvertTo-Json;
	
	Write-Host "Testing POST request";
	$Result = New-Object PSObject;
	
	Try
	{
		$Result = Invoke-RestMethod -Uri $Route -Method Post -Body $ExampleBody;
		WriteToLog ("POST to $Route passed");
		Write-Host "POST test passed.";
	}
	Catch
	{
		LogErrorMessage "POST to $Route failed." $_.Exception.Message;
		WriteToLog $Body;
		Write-Host "POST test failed.";
	}
	
	return $Result;
}

function WriteToLog([string]$Text)
{

	$Text | Out-File $LOGFILE -Append;
}

function LogErrorMessage([string]$Result, [string]$Error)
{
	WriteToLog $Result
	WriteToLog ("Error Message: " + $Error);
	WriteToLog "";
}

#Constant Base URL and Log File name
Set-Variable BASEURL ("https://localhost:44390/api/people");
Set-Variable LOGFILE ("RestAPITest.log");

#Variables
$ExampleName = $BASEURL + "/geoff";
$ExampleId = $BASEURL +  "/3";
$ExampleBody = [PSCustomObject]@{
    firstName = 'Glenn'
    lastName = 'Kitten'
    address = '8579 Water Boulevard'
    age = 4
    interests = @(
	@{
		value = 'Management'
	}
    )
};

#Calling the functions testing each endpoint
$AllPeople = GetRequest $BASEURL;
$PersonByName = GetRequest $ExampleName;
$PersonById = GetRequest $ExampleId;
$AddNewPerson = PostRequest $BASEURL $ExampleBody;
