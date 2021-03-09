
<?php
require_once"db.php";
session_start();

//Code to check if ALL FIELDS ARE FILLED in registration form
if (empty ($_POST["username"]) ||
empty ($_POST["pass"]) ||
empty ($_POST["confirmpass"]) ||
empty ($_POST["firstname"]) ||
empty ($_POST["lastname"]) ||
empty ($_POST["add1"]) ||
empty ($_POST["add2"]) ||
empty ($_POST["city"]) ||
empty ($_POST["telephone"]) ||
empty ($_POST["mobile"])) {
   $_SESSION['messages'][] = "Please fill all required fields"; 
   header('Location:registrationform.php');
   exit;
}

///CHECK IF USERNAME ALREADY EXISTS OR NOT
if (isset($_POST['submit'])) {
   $username = $_POST['username'];
   $sql_user = mysqli_query($db, "SELECT * FROM user WHERE username='$username'");
   if (mysqli_num_rows($sql_user) > 0) {
      $_SESSION['messages'][] = "Username Already Exists"; 
   header('Location:registrationform.php');
   exit;
}
}


//Code to check if password is matched to confirm password in registration form
$p = $_POST['pass'];
$c =  $_POST['confirmpass'];
if ($p !== $c) {
 $_SESSION['messages'][] = "Password Not Matched";
 header('Location:registrationform.php');
 exit;
}



///INSERT INTO USER TABLE FROM REGISTRATIONFORM.PHP
if (isset($_POST['username']) && isset($_POST['pass'])
&& isset($_POST['firstname']) && isset($_POST['lastname']) && isset($_POST['add1']) 
&& isset($_POST['add2']) && isset($_POST['city']) && isset($_POST['telephone']) && isset($_POST['mobile']) && isset($_POST['submit'])) {
$n = $_POST['username'];
$p = $_POST['pass'];
$f = $_POST['firstname'];
$l = $_POST['lastname'];
$a1 = $_POST['add1'];
$a2 = $_POST['add2'];
$ci = $_POST['city'];
$t = $_POST['telephone'];
$m = $_POST['mobile'];
require_once"db.php";
$db = mysqli_connect('localhost', 'root', '', 'library') or die(mysqli_error($db));
$sql= "INSERT INTO user (Username, Password, FirstName, LastName, AddLine1, AddLine2, City, Telephone, Mobile)
VALUES ('$n', '$p', '$f', '$l', '$a1', '$a2', '$ci', '$t', '$m')";
mysqli_query($db, $sql);

}
mysqli_close($db);



///VALIDATAE IF REGISTRATION IS SUCCESSFUL
if (!empty ($_POST["username"]) ||
!empty ($_POST["pass"]) ||
!empty ($_POST["confirmpass"]) ||
!empty ($_POST["firstname"]) ||
!empty ($_POST["lastname"]) ||
!empty ($_POST["add1"]) ||
!empty ($_POST["add2"]) ||
!empty ($_POST["city"]) ||
!empty ($_POST["telephone"]) ||
!empty ($_POST["mobile"])) {
   $_SESSION['messages'][] = "Registration Successfull"; 
   header('Location:loginform.php');
   exit;
}

?>