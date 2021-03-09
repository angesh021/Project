<?php
session_start();
 unset($_SESSION['login']);
 header('Location: loginform.php');
 exit;
   ?>
