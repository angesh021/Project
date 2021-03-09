<?php
//CALL THE HEADER
require_once'header.php';

//USING SESSION TO PREVENT LOGIN BYPASS AND IDENTIFY USER
session_start();
?>
<title>LOGIN FORM</title>

<body>

    <!-- Start of form-->
	<form action="login.php" class="form" method="POST">

<section>
    <h1 class="title" >WELCOME TO DUBLIN LIBRARY</h1>
    
<div class="formcontent1"><section1>
	<h2 class="logincontent">Login Form</h2>
		<p>UserName:</p>
		<p>
			<input class="inputbox" autofocus type="text" id = "username" name="username" />
		</p>
		<p>Password:</p>
		<p>
			<input class="inputbox" type="password" id="password" name="password" minlength="6" maxlength="6"/>
		</p>

        <!--  LOGIN BUTTON-->
		<p>
			<input class= "btn login" type="submit" value="LOGIN"/>
        </p>
        <p1 class=account>Don't have an account?</p1>

		<!--DISPLAY SESSION MESSAGES -->
        <p2 class=message><?php require_once 'messages.php'; ?></p2>
        

	</section1>
</div>
</section>
	</form>
    <!-- end of form-->
    
    <!--  REGISTER BUTTON-->
    <form action="registrationform.php" class="form">
        <p>
            <input class="registerlogin" type="submit" value="REGISTER" onClick="parent.location='registrationform.php'"/>   
        </p>
        </form>
<!-- end of form-->


 <?php
 //CALL THE FOOTER
require_once'footer.php';

?>
