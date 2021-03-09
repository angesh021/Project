<?php
require_once"db.php";
session_start();

//FUNCTION TO DELETE A RESERVATION
//THIS FUNCTION IS BEING CALLED FROM THE RESERVATION.PHP
 if (isset($_POST['delete'])){

    $delete=$_POST["delete"];
    $sql= "DELETE from reservation where ISBN='$delete'";
    $sql2 = mysqli_query($db, "UPDATE book SET reserved='N' WHERE ISBN like '%$delete%'");
    if (mysqli_query($db, $sql)){
        $_SESSION['messages'][] = "Record Deleted Successfully"; 
        header('Location:reservation.php');
        exit;
    }
}
?>
