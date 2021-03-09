<?php
require_once'header.php';
require_once'footer.php';
require_once'db.php';

//USING SESSION TO PREVENT LOGIN BYPASS AND IDENTIFY USER
session_start();
if(!$_SESSION['login']){
  header('Location: loginform.php');
}
else{
?>
<title>SEARCH</title>
<body>

<!-- Start of form PARTIAL SEARCH-->
<form  method="POST" class="form">
  <section CLASS="search">
           <div class="topnav">
  <a  href="logout.php">LogOut</a>
  <a class="reservation" href="reservation.php">View Reservation</a>
</div>
            <h1>SEARCH FOR A BOOK</h1>
            <h2><?php require_once 'messages.php';?></h2>
            <div class="formcontent2"><section1>

            <p class="text">Search by Book Title Or Author</p>
            <p> 
                  <input class="box1" autofocus type="text" name="search" />
             </p>

             <p>
                  <input class="btnsearch" type="submit" value="SEARCH" name="query"/>
            </p>
</form>
<!-- END of form-->


<!-- BOOK CATEGORY RETRIVED FROM DATABASE FOR DROPDOWN MENU SEARCH-->
<form action="search.php" method="POST" class="form">
            <p class="text">Search by Category</p>
            <select  id="option"  name="option" class="select">
                  <option>Select</option>
                  <?php
                  $records = mysqli_query($db, "SELECT CategoryID, Description FROM category ");
                  
                  while ($row = mysqli_fetch_array($records)){ ?>
                    <option name="a" value="<?php echo $row['CategoryID']; ?>"><?php echo $row['Description']; ?></option>
                  
                  <?php 
                }
                  ?>
                  <input class="btnsearch" type="submit" name="option1" />
                  </select>
                  </form>
<!-- END of form-->



<div class="table">
    <!-- BUTTON TO RESERVE-->
<form action="reserve.php" method="post" id="myform"></form>
<table class="table" border="1">
<?php

//FUNCTION TO DO PARTIAL SEARCH FROM DATABASE
if(isset($_POST['query']))
{
    $b = $_POST['search'];
    
    

//QUERY SELECT
$result = mysqli_query($db,"SELECT * FROM Book WHERE BookTitle LIKE '%$b%' OR Author LIKE '%$b%' LIMIT 5");

//DISPLAY HEADER
$fields_num = mysqli_num_fields($result);
echo "<thead>";
 for($i=0; $i<$fields_num; $i++)
 {
     $field = mysqli_fetch_field($result);
     echo "<th>{$field->name}</th>";
 }
echo "</thead>";

//DISPLAY ROW
while ( $row = mysqli_fetch_row($result)) {
    
   

?>
  
<tr>

		<td><?php echo $row[0]; ?></td>
            <td><?php echo $row[1]; ?></td>
            <td><?php echo $row[2]; ?></td>
            <td><?php echo $row[3]; ?></td>
            <td><?php echo $row[4]; ?></td>
            <td><?php echo $row[5]; ?></td>
            <td><?php echo $row[6]; ?></td>
            <td>Reserve<input class="reserve" name="ISBN" type="submit" value="<?php echo $row[0];?>" form="myform"></td>
            
           
            

			</td>
            
        </tr>
        
      <?php }}
      ?>



<?php 
                 //FUNCTION FOR DROPDOWN MENU RETRIVE DATA FROM DATABASE

 if(isset($_POST['option1'])){
    $file=fopen("category.txt","r+") or exit("Unable to open file!");
    $newData = $_POST['option'] ;
    fwrite($file,$newData);
    $lines=file_get_contents("category.txt");

     $result = mysqli_query($db,"SELECT * FROM book where CategoryID like '%$lines%' LIMIT 5");
 

     //DISPLAY HEADER
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
  

<tr>

		<td><?php echo $row[0]; ?></td>
            <td><?php echo $row[1]; ?></td>
            <td><?php echo $row[2]; ?></td>
            <td><?php echo $row[3]; ?></td>
            <td><?php echo $row[4]; ?></td>
            <td><?php echo $row[5]; ?></td>
            <td><?php echo $row[6]; ?></td>
            <td>Reserve<input class="reserve" name="ISBN" type="submit" value="<?php echo $row[0];?>" form="myform"></td>
            
           
            

			</td>
            
        </tr>
        
      <?php }} ?>
 
</table>
</div>
</section1>
</section> 
<?php
// CLOSING BRACKET FOR SESSION ON THE TOP
exit; 

   }

   ?>