#arrays are just a list of elements
$array = @(); #an empty array
$array += 1, 2, 3; #adding some elements to the array individually
$array += 4..10; #adding more elements, tersely
$array += "a"; #by default, arrays contain objects (i.e. anything)
$array;

[int[]]$array = 1..10; #this one can only contain ints, though
$array += "a"; #sad trombone

for ($i = 0; $i -lt $array.Length; $i++) {
    $array[$i] = [math]::pow($array[$i], 2); #let's square every element!
}
$array; #output entire array to screen
$array[1..4]; #output array elements with index 1-4 (inclusive) to the screen

$hash = @{
    "a" = 1;
    "b" = 2;
}; #here, we're specifying the elements of the hash explicitly

$hash["c"] = 3; #adding another element
$hash["d"]; #referencing a non-existent key is no problem
$hash["d"]++; #element at key "d" will auto-vivify
$hash["d"];

$hash = @{}; #reset to an empty hash
foreach ($i in 1..10) {
    $hash[$i] = [math]::pow($i, 2);
}
$hash;
$key = 5;
"$key $hash[$key]";
foreach ($key in $hash.keys | Sort-Object) {
    "$key => $($hash[$key])";
}

$aoh = @( #an array-of-hashes
    @{"bunny" = "white"; "tiger" = "orange"},
    @{"trout" = "rainbow"; "salmon" = "pink"}
);
$aoh[0]['bunny'];

$hoa = @{ #a hash-of-arrays
    "brady" = @(35, 34, 12, 12, 10, 10, 8, 8);
    "partridge" = @(37, 18, 16, 13, 9, 7)
};

$hoa['brady'][1];