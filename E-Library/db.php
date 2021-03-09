<?php
//this php is called in all form for connection to the database
$db = mysqli_connect('localhost', 'root', '', 'library') or die(mysqli_error($db));
