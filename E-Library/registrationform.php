<?php
require_once'header.php';
session_start();

?>
<title>Registration Form</title>


<body>
	<form action="registration.php" method="POST">
		<!-- Start of form-->
        
	<section class="register">
        <!-- BUTTON TO RETURN TO LOgIN FORM-->
    <div class="topnav">
  <a  href="loginform.php">Login</a>
        </div>
        <!-- START OF REGISTRATION FORM-->
		<p class="box">Please enter your details in the requested fields and click
            "register"</p>
        
            

<div class="formcontent">
        <div class="error">
            <p><?php require_once 'messages.php'; ?></p>
        </div>
		<p>UserName:</p>
		<p>
			<input class="text" autofocus type="text" name="username" />
        </p>

		<p class="pass">Password:</p>
		<p>
			<input class="pass" type="password" name="pass" minlength="6" maxlength="6" />
        </p>

        <p class="cpass">Confirm Password:</p>
		<p>
			<input class="cpass" type="password" name="confirmpass" minlength="6" maxlength="6"/>
        </p>
        <div class="position">
        <p>First Name:</p>
		<p>
			<input class="text" type="text" name="firstname"/>
        </p>

        <p>Last Name:</p>
		<p>
			<input class="text" type="text" name="lastname"/>
        </p>

		<p class="add1">Address line1:</p>
		<p>
			<input class="add1" type="text" name="add1"/>
        </p>	

        <p class="add2">Address line2:</p>
		<p>
			<input class="add2" type="text" name="add2" />
        </p>	
        
        <div class="position">
		<p>City:</p>
		<p>
			<select class="text" name="city">
                <option>Select</option>
				<option>Dublin 1</option>
                <option>Dublin 2</option>
                <option>Dublin 3</option>
                <option>Dublin 4</option>
                <option>Dublin 5</option>
                <option>Dublin 6</option>
                <option>Dublin 7</option>
                <option>Dublin 8</option>
                <option>Dublin 9</option>
                <option>Dublin 10</option>
                <option>Dublin 11</option>
                <option>Dublin 12</option>
			</select>
        </p>
        <p class="pass">Telephone:</p>
		<p>
        </p>
			<input class="pass"  name="telephone" type="tel"/>
        </p>
        
        <p class="cpass">Mobile:</p>
		<p>
        </p>
			<input class="cpass"  minlength="10" maxlength="10" name="mobile" type="tel"/>
        </p>

		<p>
			<input class="btn" type="submit" value="REGISTER" name="submit"/>
        </p>

        
        </div>
		</div>	
	</section>		
	</div>
	</form>
    <!-- end of form-->

    <?php
require_once'footer.php';
?>

