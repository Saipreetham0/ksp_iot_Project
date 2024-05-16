<?php
header('Content-Type: application/json');
ob_start();  // Start output buffering

// Define the correct username and password
$correct_username = "admin";
$correct_password = "1234";

// Check if the POST request contains the username and password fields
if (isset($_POST['username']) && isset($_POST['password'])) {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Check if the provided username and password match the correct credentials
    if ($username === $correct_username && $password === $correct_password) {
        // Authentication successful
        ob_end_clean();  // Clear the buffer and turn off output buffering
        header('Location: dashboard.php');  // Redirect to dashboard
        exit;  // Ensure no further execution of the script
    } else {
        // Authentication failed
        echo json_encode(['success' => false, 'error' => 'Invalid credentials']);
    }
} else {
    // Invalid request
    echo json_encode(['success' => false, 'error' => 'Missing fields']);
}
ob_end_flush();  // Send output buffer and turn off output buffering
?>
