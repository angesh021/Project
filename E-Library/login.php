<?php
require_once"db.php";
session_start();
  

// CHECK IF ALL FIELDS IS FILLED IN LOGINFORM
if (empty ($_POST["username"]) || empty ($_POST["password"])) {
	$_SESSION['messages'][] = "Please fill all required fields"; 
	header('Location:loginform.php');
	exit;
 }

 //CHECK IF USER NEED TO REGISTER 
 if(count($_POST)>0) {
	$result = mysqli_query($db,"SELECT * FROM user WHERE Username='" . $_POST["username"]."'");
	$count  = mysqli_num_rows($result);
	
	if($count==0) {
		$_SESSION['messages'][] = "Username Does Not Exists ";
		$_SESSION['messages'][] = "Please Register"; 
   header('Location:loginform.php');
   exit;
	}
}

/// VERIFY USERNAME AND PASSWORD FROM DATABASE
if(count($_POST)>0) {
	$result = mysqli_query($db,"SELECT * FROM user WHERE Username='" . $_POST["username"] . "' and Password = '". $_POST["password"]."'");
	$count  = mysqli_num_rows($result);
	
	if($count==0) {
        $_SESSION['messages'][] = "Invalid Username Or Password "; 
   header('Location:loginform.php');
	} else {
		$_SESSION['login'] = $_POST["username"]; 
		$_SESSION['messages'][] = "Login Successfully. Welcome ".$_POST["username"]; 
   header('Location:search.php');

   exit;
	}
}

?>

