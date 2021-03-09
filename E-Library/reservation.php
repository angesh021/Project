<?php
require_once'header.php';
require_once'footer.php';
require_once'db.php';

//USING SESSION TO PREVENT LOGIN BYPASS AND IDENTIFY USER
session_start();
if($_SESSION['login']){

?>


<body>
<section CLASS="reserve">
<div class="topnav">
  <a  href="logout.php">LogOut</a>
  <a class="reservation" href="search.php">BACK</a>
</div>

<h1>VIEW RESERVATION</h1>
<div class="formcontentRes">
<br><br><br>

<h2 class="message"><?php require_once 'messages.php'; ?></h2>
<table class="tableR" border="1">
<?php

$login = $_SESSION['login'];
$result = mysqli_query($db,"SELECT * FROM reservation inner JOIN book on reservation.isbn=book.isbn where UserName like'%$login%' ");

$fields_num = mysqli_num_fields($result);
echo "<thead>";
 for($i=0; $i<$fields_num; $i++)
 {
     $field = mysqli_fetch_field($result);
     echo "<th>{$field->name}</th>";
 }
echo "</thead>";


//DISPLAY ROW
while ( $row = mysqli_fetch_row($result) ) {

    
?>

<!--BUTTON FOR DELETE-->
<form action="delete.php" method="post" id="myform"></form>


		<tr>
			<td><?php echo $row[0]; ?></td>
			<td><?php echo $row[1]; ?></td>
			<td><?php echo $row[2]; ?></td>
			<td><?php echo $row[3]; ?></td>
			<td><?php echo $row[4]; ?></td>
			<td><?php echo $row[5]; ?></td>
			<td><?php echo $row[6]; ?></td>
			<td><?php echo $row[7]; ?></td>
			<td><?php echo $row[8]; ?></td>
			<td><?php echo $row[9]; ?></td>
			
      
            <td>Delete<input class="delete" name="delete" type="submit" value="<?php echo $row[0];?>" form="myform"></td>
			</td>
            
		</tr>
	<?php } ?>
</table>
</div>
</body>
</html>

<?php
  
}
else{
	header('Location: loginform.php');

   }
  
   exit;
   ?>