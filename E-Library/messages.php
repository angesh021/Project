<?php
///THIS CAN BE CALLED IN DIFFERENT FORM TO DISPLAY ERROR AS AN UNORDERED LIST
//session_start();

if (empty ($_SESSION['messages'])){
    return;
}

$messages = $_SESSION['messages'];
unset($_SESSION['messages']);



?>

<ul>
    <?php foreach ($messages as $message): ?>
        <li><?php echo $message; ?></li>
    <?php endforeach; ?>
</ul>


<?php
// STORE THE USER SESSION AND PREVENT BYPASS
if (empty ($_SESSION['login'])){
    return;
}

$login = $_SESSION['login'];

?>
