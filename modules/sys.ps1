function Get-Cpu-usage () {
    $process=Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average #| Select Average
    #$valeur=$(Get-Counter -ComputerName localhost '\Process(*)\% Processor Time' | Select-Object -ExpandProperty countersamples | Select-Object -Property instancename, cookedvalue | Sort-Object -Property cookedvalue -Descending | Select-Object -First 20 | ft InstanceName,@{L='CPU';E={($_.Cookedvalue/100).toString('P')}} -AutoSize)
    $process|Format-Table -AutoSize
    
} #fucntion

function Get-mem-usage () {
    #Get-WmiObject WIN32_PROCESS | Sort-Object -Property ws -Descending | Select-Object -first 5 ProcessID,Name,WS
    $memoire = Get-Process | Sort-Object -Property WS -Descending| Select-Object Name,WS,PM,VM -first 5
    $memoire|Format-Table -AutoSize
    
} #fucntion

function Get-Sys-infos () {
    Show-Messages "CPU :" 'titre' $true
    Get-Cpu-usage
    sleep 1
    Show-Messages "MEM :" 'titre' $true
    Get-Mem-usage
    

} #fucntion