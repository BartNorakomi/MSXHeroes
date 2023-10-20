# Load the .tmx file
[xml]$tmxData = Get-Content -Path "mapXXXX.tmx"

# Define the output file path
$outputFilePath = "output.dat"

# Find object layers
$objectLayers = $tmxData.SelectNodes("//objectgroup")

# Open the output file for writing (create or overwrite)
$outputFile = [System.IO.File]::Create($outputFilePath)

# Initialize object count
$objectCount = 0

# Iterate through object layers and count objects
foreach ($objectLayer in $objectLayers) {
    $objectCount += $objectLayer.SelectNodes("object").Count
}

# Write the total object count to the output file as a single byte
$outputFile.WriteByte([byte]$objectCount)

# Iterate through object layers
foreach ($objectLayer in $objectLayers) {
    $objectLayerName = $objectLayer.name

    $objects = $objectLayer.SelectNodes("object")

    # Iterate through objects in the current layer
    foreach ($object in $objects) {
        $xAscii = $object.x  # Assuming x contains ASCII values
        $xInt = [int]$xAscii  # Convert ASCII to integer
        $xByte = [byte]$xInt  # Convert integer to byte

        $yAscii = $object.y  # Assuming y contains ASCII values
        $yInt = [int]$yAscii  # Convert ASCII to integer
        $yByte = [byte]$yInt  # Convert integer to byte

        $outputFile.WriteByte($xByte)
        $outputFile.WriteByte($yByte)

        # Check for custom properties with the name "value" or "id"
        $customProperties = $object.SelectNodes("properties/property")
        foreach ($property in $customProperties) {
            $propertyName = $property.name
            $propertyValue = $property.value
            $propertyInt = [int]$propertyValue  # Convert property value to integer
            $propertyByte = [byte]$propertyInt   # Convert integer to byte

            if ($propertyName -eq "value" -or $propertyName -eq "id") {
                $outputFile.WriteByte($propertyByte)
            }
        }
    }
}

# Close the output file
$outputFile.Close()
