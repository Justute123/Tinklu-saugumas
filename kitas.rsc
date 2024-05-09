:local fileSize [/file get webfig/#Files size]
:local blockSize 1024
:local startPosition 0

# reading in blocks while file contents does not end
:while($startPosition < $fileSize) do={

    :local fileContens ""
    # getting file contents in parts starting from start position
    :local block [/file get webfig/#Files contents length=$blockSize skip=$startPosition]
    # preparing a smaller file content part
    :set concatinatedFileContentsWithBlock ($fileContents . $block)
    # review start position
    :set startPosition ($startPosition + $blockSize)

# all contents lines store in lines variable
    :local lines [:toarray $concatinatedFileContentsWithBlock]
    # pick first element of lines and write it to ip variable then print it and save it to blacklist in router.
    :foreach line in=$lines do={
        :local ip [:pick $line 0]
        :put $ip
        /ip firewall address-list add address=$ip list=blacklist
    }
    
}