clear-host;
$a = 'string';
$b = 'This is a $a';
$b;
$c = "This is a $a";
$c
$d = 'What if we want a single quote (like '')?'
$d
$d = "We could also do it this way: `'.";
$d
'Here''s a string with placeholders: {0}, {1}, {0:D2}' -f 1, 2

$long_string = @"
Here is a haiku
Sometimes the line is long and so
Some formatting help?
"@

$long_string