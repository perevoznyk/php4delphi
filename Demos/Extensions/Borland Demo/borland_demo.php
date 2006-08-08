<?

if (isset($_GET) && !empty($_GET['action']))
  $action = $_GET["action"];
   else
     $action = "";

if ($action == "runquery")
{
  $id = $_GET["CustNo"];
  echo runquery($id);
}
 else
   echo produce_page($action);


?>

