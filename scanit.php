<?php
 
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "scanit";
    $table = "Scanit"; // lets create a table named Employees.
 
    // we will get actions from the app to do operations in the database...
    $action = $_POST["action"];
     
    // Create Connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check Connection
    if($conn->connect_error){
        die("Connection Failed: " . $conn->connect_error);
        return;
    }
 
    // If connection is OK...
    if("GET_ALL" == $action){
        $db_data = array();
        $sql = "SELECT pro_name, manu_date, count_id from $table";
        $result = $conn->query($sql);
        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                $db_data[] = $row;
            }
            // Send back the complete records as a json
            echo json_encode($db_data);
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }

    // Update an Employee
    if("UPDATE_EMP" == $action){
        // App will be posting these values to this server
        $pro_name = $_POST["pro_name"];
        $manu_date = $_POST["manu_date"];
	$count_id = $_POST['count_id'];
        $sql = "UPDATE $table SET count_id = ($count_id)-1 WHERE (pro_name = '$pro_name' AND manu_date= '$manu_date')";
        if($conn->query($sql) === TRUE){
            echo "success";
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }
 
    // Delete an Employee
    if('DELETE_EMP' == $action){
        $pro_name = $_POST["pro_name"];
        $manu_date = $_POST["manu_date"];
        $sql = "DELETE FROM $table WHERE (pro_name = '$pro_name' AND manu_date = '$manu_date')"; // don't need quotes since id is an integer.
        if($conn->query($sql) === TRUE){
            echo "success";
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }
 
?>