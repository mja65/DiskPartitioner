# $PathtoArchive = "E:\Emulators\Amiga Files\3.9\AmigaOS39-p00h.iso"

# $Test = & $Script:ExternalProgramSettings.SevenZipFilePath l $PathtoArchive "-ir!OS-Version3.9\`*"
#        $Test = & $Script:ExternalProgramSettings.SevenZipFilePath l $PathtoArchive "-ir!OS-Version3.9\`*"
# $OutputtoParse = [System.Collections.Generic.List[PSCustomObject]]::New()

# $Test | ForEach-Object {
#     if ($_.Length -gt 30){
#         if ($_.Substring(20,5) -eq "....."){
#             $NameLength = $_.Length-53
#             $OutputtoParse += [PSCustomObject]@{
#                 Date = $_.Substring(0,10)
#                 Time = $_.Substring(11,8)
#                 Attributes = $_.Substring(20,5)
#                 Size = [int]$_.Substring(26,12)
#                 SizeCompressed =[int]$_.Substring(39,12)
#                 Name  = $_.Substring(53,$NameLength)
#             }
#         }
#     }
# }

#& $Script:ExternalProgramSettings.SevenZipFilePath l $PathtoArchive "-ir!OS-Version3.9\Workbench3.5\S\Startup-Sequence" "-ir!OS-Version3.9\Workbench3.5\L\FastFileSystem" "-ir!OS-Version3.9\Workbench3.5\C\execute" "-ir!OS-Version3.9\Workbench3.9\Libs\workbench.library" "-ir!OS-Version3.9\Workbench3.9\Prefs\screenmode"