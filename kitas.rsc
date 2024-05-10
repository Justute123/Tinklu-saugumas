#KEISTAS
:local fileSize [/file get webfig/#Files size]
:local content [/file get [/file get webfig/#Files] contents] ;
:local contentLen [:len $content];
:local blockSize 1024
:local divResult 0
:local liekResult 0
:local blockNumber 0


:set divResult ($fileSize / $blockSize)
:set liekResult ($fileSize % $blockSize)

# getting total blocks number
:if ($liekResult > 0) do{
    :set blockNumber ( $divResult + 1) 
}

# kol block still exists
:local position 0

:while ($blockNumber > 0) do={
    :local fileContents ""

    :local block [/file get webfig/#Files contents length=$blockSize skip=$position]
    :set fileContents ($fileContents . $block)
    :set blockNumber ($blockNumber - 1)


# all contents lines store in lines variable
    :local lines [:toarray $fileContents]
    # pick first element of lines and write it to ip variable then print it and save it to blacklist in router.
    :foreach line in=$lines do={
        #nesu tikra ar pick tikrai isrenka ip
        :local ip [:pick $line 0]
        :put $ip
        /ip firewall address-list add address=$ip list=blacklist
        :set position ($position + 1)
    }
    
}