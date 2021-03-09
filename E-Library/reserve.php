<?php
require_once"db.php";
session_start();


//USING SESSION TO SAVE USERNAME, TO RETRIEVE FOR RESERVATION 
$login = $_SESSION['login'];

///RESERVE FUCTION TO  RESERVE A BOOK AND ADD RESERVATION TABLE IN DATABASE
if (isset($_POST['ISBN'])){

	  $isbn=$_POST["ISBN"];
	  $sql= "INSERT INTO reservation  (ISBN, userName, ReservationDate) values ('$isbn','$login', NOW())" ;
	  $sql2 = mysqli_query($db, "UPDATE book SET reserved='Y' WHERE ISBN like '%$isbn%'");
	  if (mysqli_query($db, $sql)){
		  $_SESSION['messages'][] = "The Book Have Been Reserved Successfully"; 
		  header('Location:search.php');
		  exit;
	}else{
		$_SESSION['messages'][] = "This Book Is Already Reserved";
		$_SESSION['messages'][] = "This Book Is Not Availabled"; 
		  header('Location:search.php');
		  exit;
	}
  }

  ?>